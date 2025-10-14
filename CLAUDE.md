# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Garmin Connect IQ watchface application written in Monkey C for the Forerunner 970 (fr970). The watchface displays:
- Analog clock with hour, minute, and second hands
- Hour markers (1-12) positioned in a circle
- Real-time heart rate
- Current speed
- GPS location coordinates

## Development Environment

This project uses the Garmin Connect IQ SDK and Monkey C language. Development is typically done through Visual Studio Code with the Monkey C extension.

### Build and Deploy Commands

The project uses Visual Studio Code commands through the Monkey C extension:
- **Build**: Use "Monkey C: Build for Device" from the command palette
- **Run/Deploy**: Use "Monkey C: Run" to deploy to simulator or device
- **Edit Products**: Use "Monkey C: Edit Products" to change target devices
- **Edit Permissions**: Use "Monkey C: Configure Permissions" to modify app permissions

### Project Structure

```
source/
  MyWatchFaceApp.mc      - Application entry point, extends AppBase
  MyWatchFaceView.mc     - Main watchface view, extends WatchFace
resources/
  layouts/layout.xml     - UI layout definitions (labels for time, heart rate, speed, etc.)
  drawables/drawables.xml - Image resources (launcher icon)
  strings/strings.xml    - String resources
manifest.xml             - App configuration (permissions, products, API level)
monkey.jungle            - Project configuration file
```

## Architecture

### Application Flow
1. **MyWatchFaceApp** (source/MyWatchFaceApp.mc:5-24): Application entry point
   - `getInitialView()` returns `MyWatchFaceView` instance

2. **MyWatchFaceView** (source/MyWatchFaceView.mc:9-159): Main watchface rendering
   - Extends `WatchUi.WatchFace`
   - `onUpdate()` is called periodically to refresh the display
   - `onPosition()` callback receives GPS location updates

### Key Rendering Logic

The watchface uses a custom analog design rendered programmatically:

- **Hour Numbers** (source/MyWatchFaceView.mc:90-104): `drawNumbers()` positions 12 hour labels in a circle using trigonometry (radius 160px, yellow color)

- **Clock Hands & Markers** (source/MyWatchFaceView.mc:106-149): `drawTrot()` renders:
  - 60 tick marks (major marks every 5 seconds in yellow, minor marks in light gray)
  - Second hand (light gray, radius ~190px)
  - Minute hand (yellow, radius ~150px)
  - Hour hand (white, radius ~100px)

- **Activity Data Display** (source/MyWatchFaceView.mc:52-77):
  - Heart rate from `Activity.getActivityInfo().currentHeartRate` (displays "--" if null/0)
  - Speed from `Activity.getActivityInfo().currentSpeed` (displays "--" if null/0)
  - Location coordinates from GPS via `Position.enableLocationEvents()`

### UI Label System

The layout defines multiple labels in resources/layouts/layout.xml that are positioned dynamically in code:
- 12 HourChar labels (HourChar1-HourChar12) for hour numbers
- HeartRate, Speed, Location labels for activity data
- Labels are positioned using `setLocation()` relative to screen center

### Permissions

The app requests extensive permissions (manifest.xml:23-34):
- Positioning (GPS)
- Sensor/SensorHistory (heart rate)
- Activity data
- ANT+, BLE, Communications, Notifications
- Background processing

## Target Device

Currently configured for Garmin Forerunner 970 (fr970) only. To add more devices, use "Monkey C: Edit Products" command.

## Code Conventions

- Monkey C language (Java/C-like syntax with Connect IQ APIs)
- Uses Toybox modules: Graphics, System, Activity, Position, WatchUi
- Trigonometric calculations use radians (Math.PI, Math.sin, Math.cos)
- Screen coordinates: origin top-left, use `dc.getWidth()/2` and `dc.getHeight()/2` for center
- Null safety: Activity data may be null or 0, always check before displaying

la commande pour lance le projet est :
java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -jar c:\Users\jean-baptiste.bayle\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.2.3-2025-08-11-cac5b3b21\bin\monkeybrains.jar -o bin\MyWatchFace.prg -f c:\Users\jean-baptiste.bayle\Desktop\programmation\Garmin\MyWatchFace\monkey.jungle -y c:\Users\jean-baptiste.bayle\Documents\developer_key -d fr970_sim -w