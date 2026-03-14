# Changelog (Fork)

Changes in this fork on top of upstream [ripplebiz/MeshCore](https://github.com/ripplebiz/MeshCore).

## v1.14.0-fork.3

### Enable sensors page on OLED companion variants

The sensors UI page was previously only available on the E-Ink variant. It is now enabled on both `WioTrackerL1_companion_radio_usb` and `WioTrackerL1_companion_radio_ble` builds.

**Changes:**
- `variants/wio-tracker-l1/platformio.ini`: Added `-D UI_SENSORS_PAGE=1` to both USB and BLE companion environments.

**Behavior:**
The Home screen carousel now includes a Sensors page showing live readings (voltage, temperature, humidity, pressure, altitude, power) with auto-scroll when there are more sensors than fit on screen. Refreshes every 5 seconds on OLED.

## v1.14.0-fork.2

### Buzzer off by default

Make the buzzer silent by default on fresh installs. Existing devices with saved preferences are unaffected.

**Changes:**
- `src/helpers/ui/buzzer.cpp`: Removed `quiet(false)` and `startup()` from `begin()` — it now only configures the hardware pin, preventing the buzzer from playing before preferences are loaded.
- `examples/companion_radio/MyMesh.cpp`: Set `_prefs.buzzer_quiet = 1` as the default for fresh installs (was `0` via `memset`).
- `examples/companion_radio/ui-new/UITask.cpp`: Play startup sound only after applying saved preference (`if (!buzzer.isQuiet()) buzzer.startup()`).
- `examples/companion_radio/ui-orig/UITask.cpp`: Same as above.

**Behavior:**

| Scenario | Before | After |
|---|---|---|
| Fresh install | Buzzer ON, startup beep | Buzzer OFF, silent |
| Saved buzzer ON | Startup beep | Startup beep |
| Saved buzzer OFF | Startup beep, then silenced | Silent |
