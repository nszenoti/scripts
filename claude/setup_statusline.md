# Claude Code Status Line — Setup Guide

Hand this file to Claude Code and it will configure your status line interactively.

---

## How to Use This File

Paste this prompt into Claude Code:

```
Read ~/.config/claude-helpers/setup_statusline.md and follow the setup instructions inside it.
```

---

## Instructions for Claude Code

You are setting up a custom status line for the user. Follow these steps exactly.

### Step 1 — Ask: defaults or customize?

Say exactly this:

---

**Setting up your Claude Code status line!**

Here's what the default setup includes:

```
Line 1 — 🤖 Claude Sonnet 4.6 | 🧠 12% | 🔢 24.3K | 💰 $0.0041
Line 2 — 🌿 main              (worktree shown only if multiple exist)
```

| Component | Included |
|---|---|
| Model name | ✅ |
| Context % | ✅ |
| Tokens consumed | ✅ |
| Cost | ✅ |
| Git branch | ✅ |
| Git worktree (auto-hides if none) | ✅ |
| 5h rate limit | ❌ |
| 5h reset time | ❌ |
| 7-day rate limit | ❌ |
| Lines added/removed | ❌ |

**Proceed with defaults or customize?**
- Type `defaults` to install as-is
- Type `customize` to pick what to include

---

Wait for the user's response.

- If `defaults` → skip straight to Step 3 using all ✅ components above.
- If `customize` → continue to Step 2.

---

### Step 2 — Customize (only if user chose `customize`)

Say: "Pick what to include — defaults are pre-selected:"

| # | Component | What it shows | Default |
|---|---|---|---|
| 1 | **Model** | e.g. `Claude Sonnet 4.6` | ✅ |
| 2 | **Context %** | How full the context window is | ✅ |
| 3 | **Tokens consumed** | Raw token count | ✅ |
| 4 | **Cost** | Session spend e.g. `$0.04` | ✅ |
| 5 | **5h rate limit** | How much of the 5-hour quota is used | ❌ |
| 6 | **5h reset time** | When the 5h window resets e.g. `resets 2:00PM` | ❌ |
| 7 | **7-day rate limit** | Weekly quota usage % | ❌ |
| 8 | **Git branch** | Current branch name | ✅ |
| 9 | **Git worktree** | Shown only when worktrees exist, hidden otherwise | ✅ |
| 10 | **Lines added/removed** | e.g. `+42 -7` for this session | ❌ |

Wait for the user's response, then proceed to Step 3 with their chosen components.

---

### Step 3 — Generate the script

Based on the selected components (defaults or custom), generate a bash script and save it to `~/.claude/statusline.sh`.

Use the template below, including only the selected sections.

#### Full template (include/exclude sections per selection):

```bash
#!/bin/bash
# ACTIVE: model, context_pct, tokens, cost, git_branch, git_worktree
input=$(cat)

# ── Core fields ──────────────────────────────────────────────────────
MODEL=$(echo "$input"  | jq -r '.model.display_name // "unknown"')
PCT=$(echo "$input"    | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
TOKENS=$(echo "$input" | jq -r '
  (.context_window.current_usage.input_tokens // 0) +
  (.context_window.current_usage.cache_creation_input_tokens // 0) +
  (.context_window.current_usage.cache_read_input_tokens // 0)
')
COST=$(echo "$input"   | jq -r '.cost.total_cost_usd // 0')

# ── Token formatting (human-readable) ────────────────────────────────
if [ "$TOKENS" -ge 1000000 ]; then
  TOKENS_FMT="$(echo "$TOKENS" | awk '{printf "%.1fM", $1/1000000}')"
elif [ "$TOKENS" -ge 1000 ]; then
  TOKENS_FMT="$(echo "$TOKENS" | awk '{printf "%.1fK", $1/1000}')"
else
  TOKENS_FMT="${TOKENS}"
fi

# ── Rate limits (include only if selected) ───────────────────────────
RL5_PCT=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
RL5_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
RL7_PCT=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)

# ── Reset time formatting (macOS/Linux safe) ─────────────────────────
if [ "$RL5_RESET" -gt 0 ] 2>/dev/null; then
  if date --version >/dev/null 2>&1; then
    RESET_TIME=$(date -d "@$RL5_RESET" +"%I:%M%p" 2>/dev/null)   # Linux
  else
    RESET_TIME=$(date -r "$RL5_RESET" +"%I:%M%p" 2>/dev/null)    # macOS
  fi
fi

# ── Git info ─────────────────────────────────────────────────────────
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "."')
BRANCH=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
# Worktree: only shown when multiple worktrees exist
WORKTREE_COUNT=$(git -C "$DIR" worktree list 2>/dev/null | wc -l | tr -d ' ')
if [ "${WORKTREE_COUNT:-0}" -gt 1 ]; then
  WORKTREE=$(basename "$DIR")
else
  WORKTREE=""
fi
ADDED=$(echo "$input"   | jq -r '.cost.total_lines_added // 0')
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# ── Line 1: session info ─────────────────────────────────────────────
LINE1="🤖 ${MODEL}"
LINE1="${LINE1} | 🧠 ${PCT}%"
LINE1="${LINE1} | 🔢 ${TOKENS_FMT}"
LINE1="${LINE1} | 💰 \$$(printf '%.4f' $COST)"
# 5h rate limit — include if selected:
# LINE1="${LINE1} | ⏱️ 5h ${RL5_PCT}%"
# 5h reset time — include if selected:
# [ -n "$RESET_TIME" ] && LINE1="${LINE1} resets ${RESET_TIME}"
# 7d rate limit — include if selected:
# LINE1="${LINE1} | 📅 7d ${RL7_PCT}%"

printf "%s\n" "$LINE1"

# ── Line 2: git info ─────────────────────────────────────────────────
LINE2=""
[ -n "$WORKTREE" ] && LINE2="🌳 ${WORKTREE} | "
[ -n "$BRANCH" ]   && LINE2="${LINE2}🌿 ${BRANCH}"
# Lines added/removed — include if selected:
# [ -n "$LINE2" ] && LINE2="${LINE2} | +${ADDED} -${REMOVED}"

[ -n "$LINE2" ] && printf "%s\n" "$LINE2"

exit 0
```

**Important:**
- Update the `# ACTIVE:` comment at the top to reflect the actual selected components.
- Uncomment rate limit / lines-changed lines only if the user selected them.
- Worktree block is self-guarding — always include it if selected; it auto-hides when no worktrees exist.
- Remove all remaining commented-out lines from the final script — keep it clean.

---

### Step 4 — Wire up settings

Add or merge this into `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "sh ~/.claude/statusline.sh",
    "padding": 0
  }
}
```

If the file already exists, merge the `statusLine` key without overwriting other settings.

Make the script executable:
```bash
chmod +x ~/.claude/statusline.sh
```

---

### Step 5 — Confirm

Tell the user:
- What components were included
- A preview of what their status line will look like (use placeholder values)
- That changes appear after the next Claude Code interaction
- How to modify later (see below)

---

## Modifying Later

To update what's shown, say to Claude Code:

```
Read ~/.config/claude-helpers/setup_statusline.md and update my status line.
```

Claude Code will read the `# ACTIVE:` comment from `~/.claude/statusline.sh` to know your current setup, then present the defaults-or-customize prompt again so you can adjust.

Or be direct:
```
Update my status line — add 5h rate limit, remove tokens
```

---

## Quick Reference — Available JSON Fields

```
model.display_name                          → model name
context_window.used_percentage              → % of context used
context_window.current_usage.input_tokens   → raw input tokens
cost.total_cost_usd                         → session cost in USD
rate_limits.five_hour.used_percentage       → 5h quota used %
rate_limits.five_hour.resets_at             → unix timestamp of reset
rate_limits.seven_day.used_percentage       → 7d quota used %
workspace.current_dir                       → current folder path
cost.total_lines_added                      → lines added this session
cost.total_lines_removed                    → lines removed this session
```
