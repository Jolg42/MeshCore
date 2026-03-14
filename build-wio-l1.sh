#!/usr/bin/env bash
export FIRMWARE_VERSION=v1.0.0
export PATH="$HOME/.platformio/penv/bin:$PATH"

TARGET=WioTrackerL1_companion_radio_ble

sh build.sh build-firmware "$TARGET"

# build.sh's platform detection (get_platform_for_env) can fail silently due to
# invalid control characters in pio's JSON output. Handle UF2 conversion here
# as a fallback for this nRF52840 board.
if [ ! -f "out/${TARGET}-${FIRMWARE_VERSION}-"*".uf2" ]; then
  echo "UF2 not found in out/, generating from firmware.hex..."
  COMMIT_HASH=$(git rev-parse --short HEAD)
  FIRMWARE_FILENAME="${TARGET}-${FIRMWARE_VERSION}-${COMMIT_HASH}"
  python3 bin/uf2conv/uf2conv.py ".pio/build/${TARGET}/firmware.hex" -c -o ".pio/build/${TARGET}/firmware.uf2" -f 0xADA52840
  cp ".pio/build/${TARGET}/firmware.uf2" "out/${FIRMWARE_FILENAME}.uf2"
  cp ".pio/build/${TARGET}/firmware.zip" "out/${FIRMWARE_FILENAME}.zip" 2>/dev/null || true
  echo "Output: out/${FIRMWARE_FILENAME}.uf2"
fi
