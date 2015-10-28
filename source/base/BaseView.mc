using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class BaseView extends Ui.View {

	// Update the view
	function onUpdate(dc) {
     	// Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        View.findDrawableById("TimeLabel").setText(timeString);
    	// call the parent to update the display
    	View.onUpdate(dc);
	}

}
