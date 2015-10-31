using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Graphics as Gfx;

class BaseView extends Ui.View {

	const BAR_THICKNESS = 6;
    const ARC_MAX_ITERS = 300;

	// Update the view
	function onUpdate(dc) {
     	// Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        View.findDrawableById("TimeLabel").setText(timeString);
    	// call the parent to update the display
    	View.onUpdate(dc);
	}

	// pinched from https://github.com/CodyJung/connectiq-apps/tree/master/ArcWatch
	// which, thankfully, is also MIT
	// @todo use dc.drawArc instead, once 1.2 is out
    function drawArc(dc, cent_x, cent_y, radius, theta, color) {
        dc.setColor( color, Gfx.COLOR_WHITE);

        var iters = ARC_MAX_ITERS * ( theta / ( 2 * Math.PI ) );
        var dx = 0;
        var dy = -radius;
        var ctheta = Math.cos(theta/(iters - 1));
        var stheta = Math.sin(theta/(iters - 1));

        dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);

        for(var i=1; i < iters; ++i) {
            var dxtemp = ctheta * dx - stheta * dy;
            dy = stheta * dx + ctheta * dy;
            dx = dxtemp;
            dc.fillCircle(cent_x + dx, cent_y + dy, BAR_THICKNESS);
        }
    }

}
