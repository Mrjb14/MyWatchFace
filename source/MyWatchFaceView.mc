import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.ActivityMonitor;

class MyWatchFaceView extends WatchUi.WatchFace {
    var radiusG = 190;
    var radiusH = 195;
    var teta = 0.0;
    var xcenter = 0.0;
    var ycenter = 0.0;
    var myLocation as Array<Double> = [0.0d, 0.0d] as Array<Double>;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        
        var clockTime = System.getClockTime();
        xcenter =  dc.getWidth()/2;
        ycenter =  dc.getHeight()/2;
        // var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        // var view = View.findDrawableById("TimeLabel") as Text;
        // var second = Lang.format("$1$", [clockTime.sec]);
    
        // view.setText(timeString);
        // view.setColor(Graphics.COLOR_RED);
        // Call the parent onUpdate function to redraw the layout
        drawNumbers(dc);

        //HEARTRATE
        var heartrate = View.findDrawableById("HeartRate") as Text;

        heartrate.setLocation(xcenter ,ycenter + 50);
        var hr = Lang.format("$1$", [Activity.getActivityInfo().currentHeartRate]);
        if ((hr == "null") or (hr == "0")){ 
            heartrate.setText("--");
        }else{
            heartrate.setText(hr);
        }
        //SPEED (convert from m/s to km/h)
        var speedDisplay = View.findDrawableById("Speed") as Text;
        speedDisplay.setLocation(xcenter ,ycenter);
        var currentSpeed = Activity.getActivityInfo().currentSpeed;
        if (currentSpeed == null || currentSpeed == 0) {
            speedDisplay.setText("--");
        } else {
            var speedKmh = currentSpeed * 3.6; // Convert m/s to km/h
            speedDisplay.setText(speedKmh.format("%.1f") + " km/h");
        }

        //LOCATION
        var LocationDisplay = View.findDrawableById("Location") as Text;
        LocationDisplay.setLocation(xcenter, ycenter - 50);

        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null && activityInfo has :currentLocation && activityInfo.currentLocation != null) {
            var location = activityInfo.currentLocation.toDegrees();
            var lat = location[0] as Double;
            var lon = location[1] as Double;
            LocationDisplay.setText(lat.format("%.4f") + "," + lon.format("%.4f"));
        } else {
            LocationDisplay.setText("GPS: --");
        }

        View.onUpdate(dc);
        
        drawTrot(dc, clockTime);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    public function drawNumbers(dc) as Void {
        for (var i = 1; i <= 12 ; i = i + 1) {
            var charView = View.findDrawableById("HourChar" + i) as Text;
            var hour = Lang.format("$1$", [i]);

            var teta = (2 * Math.PI / 12) * i;
            var radius = 160;
            var x =  (dc.getWidth()/2) + (radius * Math.sin(teta));
            var y = (dc.getHeight()/2) - (radius * Math.cos(teta)) - 25;
            charView.setText(hour);
            charView.setColor(Graphics.COLOR_YELLOW);
            charView.setLocation(x.toNumber() , y.toNumber() );
            //dc.drawCircle(x.toNumber(), y.toNumber(), 3);
        }
    }

    public function drawTrot(dc, clockTime) as Void {
          // Get and show the current time
        var centerX =  dc.getWidth()/2;
        var centerY =  dc.getHeight()/2;
        
        for (var i = 0; i < 60 ; i = i + 1) {
            // var charView = View.findDrawableById("SecondChar") as Text;
            // charView.setText(second);
            // charView.setColor(Graphics.COLOR_BLUE);
            teta = (2 * Math.PI / 60) * i;
            if (i % 5 == 0) {
                 dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
                radiusG = 200;
                radiusH = 210;
            } else {
                 dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
                radiusG = 205;
                radiusH = 210;
            }
            var x1 = centerX + (radiusG * Math.sin(teta));
            var y1 = centerY - (radiusG * Math.cos(teta));
            var x2 = centerX + (radiusH * Math.sin(teta));
            var y2 = centerY - (radiusH * Math.cos(teta));
           
            dc.drawLine(x1.toNumber(), y1.toNumber(), x2.toNumber(), y2.toNumber());
            //dc.drawCircle(x1.toNumber(), y1.toNumber(), 3);
        }
            var tetasecond = (2 * Math.PI / 60) * clockTime.sec;
            var tetaminute = (2 * Math.PI / 60) * clockTime.min;
            var tetahour = (2 * Math.PI / 12) * clockTime.hour;
            var xsec = centerX + ((radiusG - 10) * Math.sin(tetasecond));
            var ysec = centerY - ((radiusG - 10) * Math.cos(tetasecond));
            var xmin = centerX + ((radiusG - 50) * Math.sin(tetaminute));
            var ymin = centerY - ((radiusG - 50) * Math.cos(tetaminute));
            var xhou = centerX + ((radiusG - 100) * Math.sin(tetahour));
            var yhou = centerY - ((radiusG - 100) * Math.cos(tetahour));

            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
            dc.drawLine(centerX, centerY, xsec.toNumber(), ysec.toNumber());    
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
            dc.drawLine(centerX, centerY, xmin.toNumber(), ymin.toNumber());
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.drawLine(centerX, centerY, xhou.toNumber(), yhou.toNumber());
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
