import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MyWatchFaceView extends WatchUi.WatchFace {
    
    var centerX = 242;
    var centerY = 227;
    var radiusG = 50;
    var radiusH = 52;
    var teta = 0.0;

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
        // Get and show the current time
        
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        var second = Lang.format("$1$", [clockTime.sec]);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        for (var i = 0; i < second.toNumber() ; i = i + 1) {
            // var charView = View.findDrawableById("SecondChar") as Text;
            // charView.setText(second);
            // charView.setColor(Graphics.COLOR_BLUE);
            teta = (3.14 / 60) * i;
            var x1 = centerX + (radiusG * Math.sin(teta));
            var y1 = centerY - (radiusG * Math.cos(teta));
            var x2 = centerX + (radiusH * Math.sin(teta));
            var y2 = centerY - (radiusH * Math.cos(teta));

            //dc.drawLine(x1.toNumber(), y1.toNumber(), x2.toNumber(), y2.toNumber());
            dc.drawCircle(x1.toNumber(), y1.toNumber(), 10);
            System.println(second + " " + x1 + " " + y1 + " " + x2 + " " + y2);
        }
        dc.drawLine(10, 50, 10 + second.toNumber() , 55);
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();
        System.println(30 + screenWidth + " " + screenHeight);

        view.setText(timeString);
        view.setColor(Graphics.COLOR_RED);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
