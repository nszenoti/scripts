#!/bin/bash

# Pick flutter binary (fvm-aware)
if [ -f ".fvm/fvm_config.json" ]; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

device_list=$("${FLUTTER[@]}" devices 2>/dev/null | grep -E "•")

if [ -z "$device_list" ]; then
  echo "No devices found. Start a simulator or connect a device."
  exit 1
fi

echo ""
echo "$device_list" | awk -F'•' '{
  name = $1; id = $2; type = $3;
  gsub(/^[ \t]+|[ \t]+$/, "", name);
  gsub(/^[ \t]+|[ \t]+$/, "", type);
  printf "%d. %-35s [%s]\n", NR, name, type
}'
echo ""
read -rp "Pick device: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
  echo "Invalid choice."
  exit 1
fi

selected_id=$(echo "$device_list" | awk -F'•' "NR==$choice{print \$2}" | xargs)

if [ -z "$selected_id" ]; then
  echo "No device at #$choice."
  exit 1
fi

echo "$selected_id" > .flutter_device
echo "Selected: $selected_id (saved to .flutter_device)"
