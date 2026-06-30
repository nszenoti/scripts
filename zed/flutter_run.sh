#!/bin/bash

if [ -f ".fvm/fvm_config.json" ]; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

# Pass through directly if -d/--device-id already specified
for arg in "$@"; do
  if [[ "$arg" == "-d" || "$arg" == "--device-id" || "$arg" == --device-id=* ]]; then
    "${FLUTTER[@]}" "$@"
    exit 0
  fi
done

# Device picker only for "run" command
if [ "$1" = "run" ]; then

  # Use saved device from flutter_device_pick.sh if present
  if [ -f ".flutter_device" ]; then
    selected_id=$(cat .flutter_device | xargs)
    echo "Using saved device: $selected_id"
  else
    echo "Fetching devices..."
    device_list=$("${FLUTTER[@]}" devices 2>/dev/null | grep -E "•")

    if [ -z "$device_list" ]; then
      echo "No devices found. Start a simulator or connect a device."
      exit 1
    fi

    echo ""
    echo "$device_list" | awk -F'•' '{print NR". "$1}'
    echo ""
    read -rp "Pick device number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
      echo "Invalid choice."
      exit 1
    fi

    selected_id=$(echo "$device_list" | awk -F'•' "NR==$choice{print \$2}" | xargs)

    if [ -z "$selected_id" ]; then
      echo "No device at #$choice."
      exit 1
    fi
  fi

  echo ""
  echo "Running on: $selected_id"
  "${FLUTTER[@]}" run -d "$selected_id" "${@:2}"
else
  "${FLUTTER[@]}" "$@"
fi
