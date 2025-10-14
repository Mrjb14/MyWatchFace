import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time;

class MyWatchFaceView extends WatchUi.WatchFace {
    var radiusG = 190;
    var radiusH = 195;
    var teta = 0.0;
    var xcenter = 0.0;
    var ycenter = 0.0;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        var clockTime = System.getClockTime();
        xcenter =  dc.getWidth()/2;
        ycenter =  dc.getHeight()/2;

        // Clear screen and draw background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        drawBackground(dc);

        // Draw background elements and data zones (do NOT call View.onUpdate as it erases)
        drawDataAreas(dc);

        // Draw clock elements (numbers and hands)
        drawNumbers(dc);
        drawTrot(dc, clockTime);

        // Draw data text first, then icons on top (to avoid overlap issues)
        drawSportData(dc);
        drawDataIcons(dc);
        drawAdditionalData(dc);
    }

    // Draw dark sporty background with concentric circles
    public function drawBackground(dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        // Fill entire screen with very dark gray
        dc.setColor(0x1A1A1A, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

        // Draw subtle concentric circles for depth effect
        // Circle 1 - Innermost (lightest)
        dc.setColor(0x404040, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawCircle(centerX, centerY, 80);

        // Circle 2 - Middle
        dc.setColor(0x333333, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(centerX, centerY, 140);

        // Circle 3 - Outer
        dc.setColor(0x2A2A2A, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(centerX, centerY, 200);

        // Circle 4 - Outermost (very subtle)
        dc.setColor(0x222222, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(centerX, centerY, 230);
    }

    public function drawNumbers(dc) as Void {
        var lightBlue = 0x5CC7E8;  // Light blue for hour numbers
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        dc.setColor(lightBlue, Graphics.COLOR_TRANSPARENT);

        for (var i = 1; i <= 12 ; i = i + 1) {
            var hour = Lang.format("$1$", [i]);

            var teta = (2 * Math.PI / 12) * i;
            var radius = 170;
            var x = centerX + (radius * Math.sin(teta));
            var y = centerY - (radius * Math.cos(teta));

            // Draw hour numbers with smallest font
            dc.drawText(x.toNumber(), y.toNumber(), Graphics.FONT_XTINY, hour, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    public function drawTrot(dc, clockTime) as Void {
          // Get and show the current time
        var centerX =  dc.getWidth()/2;
        var centerY =  dc.getHeight()/2;

        // Define sport colors
        var sportBlue = 0x00A3E0;      // Electric blue for major marks
        var lightBlue = 0x5CC7E8;       // Light blue
        var darkGray = 0x606060;        // Dark gray for minor marks

        for (var i = 0; i < 60 ; i = i + 1) {
            teta = (2 * Math.PI / 60) * i;
            if (i % 5 == 0) {
                 dc.setColor(sportBlue, Graphics.COLOR_BLACK);
                radiusG = 200;
                radiusH = 210;
            } else {
                 dc.setColor(darkGray, Graphics.COLOR_BLACK);
                radiusG = 205;
                radiusH = 210;
            }
            var x1 = centerX + (radiusG * Math.sin(teta));
            var y1 = centerY - (radiusG * Math.cos(teta));
            var x2 = centerX + (radiusH * Math.sin(teta));
            var y2 = centerY - (radiusH * Math.cos(teta));

            dc.drawLine(x1.toNumber(), y1.toNumber(), x2.toNumber(), y2.toNumber());
        }

        // Clock hands with sporty blue/gray theme
        var tetasecond = (2 * Math.PI / 60) * clockTime.sec;
        var tetaminute = (2 * Math.PI / 60) * clockTime.min;
        var tetahour = (2 * Math.PI / 12) * clockTime.hour;
        var xsec = centerX + ((radiusG - 10) * Math.sin(tetasecond));
        var ysec = centerY - ((radiusG - 10) * Math.cos(tetasecond));
        var xmin = centerX + ((radiusG - 50) * Math.sin(tetaminute));
        var ymin = centerY - ((radiusG - 50) * Math.cos(tetaminute));
        var xhou = centerX + ((radiusG - 100) * Math.sin(tetahour));
        var yhou = centerY - ((radiusG - 100) * Math.cos(tetahour));

        // Second hand - Dark gray
        dc.setColor(darkGray, Graphics.COLOR_BLACK);
        dc.drawLine(centerX, centerY, xsec.toNumber(), ysec.toNumber());

        // Minute hand - Light blue
        dc.setColor(lightBlue, Graphics.COLOR_BLACK);
        dc.drawLine(centerX, centerY, xmin.toNumber(), ymin.toNumber());

        // Hour hand - White
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawLine(centerX, centerY, xhou.toNumber(), yhou.toNumber());

        // Center dot in sport blue
        dc.setColor(sportBlue, Graphics.COLOR_BLACK);
        dc.fillCircle(centerX, centerY, 4);
    }

    // Draw graphical icons for data zones in triangle layout (above rectangles)
    public function drawDataIcons(dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var lightBlue = 0x5CC7E8;
        var sportBlue = 0x00A3E0;
        var lightGray = 0xB0B0B0;

        // Speed arrow icon - Top (moved higher above rectangle)
        dc.setColor(sportBlue, Graphics.COLOR_TRANSPARENT);
        var speedX = centerX;
        var speedY = centerY - 125;
        dc.fillRectangle(speedX - 2, speedY + 6, 4, 10);
        dc.fillPolygon([[speedX - 6, speedY + 6], [speedX + 6, speedY + 6], [speedX, speedY]]);

        // Heart icon - Bottom left (moved higher above rectangle)
        dc.setColor(lightBlue, Graphics.COLOR_TRANSPARENT);
        var heartX = centerX - 72;
        var heartY = centerY + 42;
        dc.fillCircle(heartX - 4, heartY, 4);
        dc.fillCircle(heartX + 4, heartY, 4);
        dc.fillPolygon([[heartX - 8, heartY + 1], [heartX + 8, heartY + 1], [heartX, heartY + 9]]);

        // Altitude/Mountain icon - Bottom right (moved higher above rectangle)
        dc.setColor(lightGray, Graphics.COLOR_TRANSPARENT);
        var altX = centerX + 72;
        var altY = centerY + 43;
        // Draw mountain shape (triangle)
        dc.fillPolygon([[altX - 8, altY + 8], [altX, altY - 2], [altX + 8, altY + 8]]);
        // Second smaller peak
        dc.fillPolygon([[altX - 3, altY + 8], [altX + 4, altY + 2], [altX + 8, altY + 8]]);
    }

    // Draw data areas with sporty blue/gray design in triangle layout
    public function drawDataAreas(dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        // Define sport blue colors
        var sportBlue = 0x00A3E0;      // Electric blue
        var darkBlue = 0x005A8C;        // Dark blue
        var lightBlue = 0x5CC7E8;       // Light blue
        var darkGray = 0x404040;        // Dark gray
        var lightGray = 0x808080;       // Light gray

        // Speed zone - Top (main focus, larger)
        dc.setColor(sportBlue, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(centerX - 55, centerY - 105, 110, 35, 8);
        dc.setColor(lightBlue, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(centerX - 55, centerY - 105, 110, 35, 8);

        // Heart rate zone - Bottom left
        dc.setColor(darkBlue, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(centerX - 115, centerY + 60, 85, 28, 6);
        dc.setColor(sportBlue, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(centerX - 115, centerY + 60, 85, 28, 6);

        // Altitude zone - Bottom right
        dc.setColor(darkGray, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(centerX + 30, centerY + 60, 85, 28, 6);
        dc.setColor(lightGray, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(centerX + 30, centerY + 60, 85, 28, 6);
    }

    // Draw sport data with styled text in triangle layout
    public function drawSportData(dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        var lightBlue = 0x5CC7E8;
        var whiteColor = Graphics.COLOR_WHITE;
        var lightGray = 0xB0B0B0;

        // SPEED - Top (main focus) - Rectangle: centerY - 105, height 35
        var currentSpeed = Activity.getActivityInfo().currentSpeed;
        var speedText = "";
        if (currentSpeed == null || currentSpeed == 0) {
            speedText = "--";
        } else {
            var speedKmh = currentSpeed * 3.6;
            speedText = speedKmh.format("%.1f");
        }
        dc.setColor(whiteColor, Graphics.COLOR_TRANSPARENT);
        // Center of rectangle: centerY - 105 + 35/2 = centerY - 87.5
        dc.drawText(centerX, centerY - 87, Graphics.FONT_TINY, speedText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // HEART RATE - Bottom left - Rectangle: centerX - 115, centerY + 60, width 85, height 28
        var hr = Activity.getActivityInfo().currentHeartRate;
        var hrText = "";
        if (hr == null || hr == 0) {
            hrText = "--";
        } else {
            hrText = hr.format("%d");
        }
        dc.setColor(lightBlue, Graphics.COLOR_TRANSPARENT);
        // Center of rectangle: X = centerX - 115 + 85/2 = centerX - 72.5, Y = centerY + 60 + 28/2 = centerY + 74
        dc.drawText(centerX - 72, centerY + 74, Graphics.FONT_XTINY, hrText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // ALTITUDE - Bottom right - Rectangle: centerX + 30, centerY + 60, width 85, height 28
        var activityInfo = Activity.getActivityInfo();
        var altText = "";
        if (activityInfo != null && activityInfo.altitude != null) {
            var altitude = activityInfo.altitude;
            if (altitude > 1000) {
                altText = (altitude / 1000.0).format("%.2f") + "k";
            } else {
                altText = altitude.format("%d");
            }
        } else {
            altText = "--";
        }
        dc.setColor(lightGray, Graphics.COLOR_TRANSPARENT);
        // Center of rectangle: X = centerX + 30 + 85/2 = centerX + 72.5, Y = centerY + 60 + 28/2 = centerY + 74
        dc.drawText(centerX + 72, centerY + 74, Graphics.FONT_XTINY, altText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Draw additional data elements (battery, steps, date)
    public function drawAdditionalData(dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var sportBlue = 0x00A3E0;
        var lightBlue = 0x5CC7E8;

        // Battery indicator (left side, moved higher)
        var stats = System.getSystemStats();
        var battery = stats.battery;
        var batteryX = centerX - 105;
        var batteryY = centerY - 35;

        // Battery outline with bright border
        dc.setColor(lightBlue, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(batteryX, batteryY, 28, 13, 2);
        dc.fillRectangle(batteryX + 28, batteryY + 3, 3, 7);

        // Battery fill based on level with vivid colors
        var fillWidth = (battery / 100.0 * 26).toNumber();
        if (battery > 50) {
            dc.setColor(0x00FF00, Graphics.COLOR_TRANSPARENT); // Bright green
        } else if (battery > 20) {
            dc.setColor(0xFF8800, Graphics.COLOR_TRANSPARENT); // Bright orange
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(batteryX + 1, batteryY + 1, fillWidth, 11);

        // Battery percentage text below icon with matching color
        if (battery > 50) {
            dc.setColor(0x00FF00, Graphics.COLOR_TRANSPARENT);
        } else if (battery > 20) {
            dc.setColor(0xFF8800, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(batteryX + 16, batteryY + 17, Graphics.FONT_XTINY, battery.format("%d") + "%", Graphics.TEXT_JUSTIFY_CENTER);

        // Steps counter (right side, moved higher)
        var activityMonitor = ActivityMonitor.getInfo();
        var steps = activityMonitor.steps;
        var stepsX = centerX + 105;
        var stepsY = centerY - 35;

        // Steps icon (footprint) in bright yellow
        dc.setColor(0xFFFF00, Graphics.COLOR_TRANSPARENT); // Bright yellow
        dc.fillCircle(stepsX - 3, stepsY - 3, 3);
        dc.fillCircle(stepsX + 2, stepsY, 3);
        dc.fillCircle(stepsX - 2, stepsY + 4, 2);

        // Steps count below icon in bright yellow
        var stepsText = "";
        if (steps > 9999) {
            stepsText = (steps / 1000.0).format("%.1f") + "k";
        } else {
            stepsText = steps.format("%d");
        }
        dc.setColor(0xFFFF00, Graphics.COLOR_TRANSPARENT);
        dc.drawText(stepsX, stepsY + 14, Graphics.FONT_XTINY, stepsText, Graphics.TEXT_JUSTIFY_CENTER);

        // Date display (bottom center, moved higher)
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [today.day, today.month]);

        dc.setColor(sportBlue, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 100, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }

}
