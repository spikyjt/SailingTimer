using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class BaseView extends Ui.View {

	const FORMAT_TIME = "$1$:$2$";
	const FORMAT_UP_TIME = "$1$:$2$:$3$";
	const FORMAT_MIN_SEC = "%02d";

	// Update the view
	function onUpdate(dc) {
     	// Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format(FORMAT_TIME, [clockTime.hour, clockTime.min.format(FORMAT_MIN_SEC)]);
        View.findDrawableById("TimeLabel").setText(timeString);
    	// call the parent to update the display
    	View.onUpdate(dc);
	}

}
