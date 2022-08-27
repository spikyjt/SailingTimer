using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

var is24Hour;
var isRound;

class BaseView extends Ui.View {

	const FORMAT_TIME = "$1$:$2$$3$";
	const FORMAT_UP_TIME = "$1$:$2$:$3$";
	const FORMAT_TIMER = "$1$:$2$";
	const FORMAT_MIN_SEC = "%02d";

	function initialize() {
		View.initialize();

		if(is24Hour == null || isRound == null) {
			var devSettings = Sys.getDeviceSettings();
			if(is24Hour == null) {
				is24Hour = devSettings.is24Hour;
			}

			if(isRound == null) {
				isRound = devSettings.screenShape == Sys.SCREEN_SHAPE_ROUND;
			}
		}
	}

	// Update the view
	function onUpdate(dc) {
	 	// Get and show the current time
		var clockTime = Sys.getClockTime();
		var timeData = new [3];
		timeData[0] = clockTime.hour;
		timeData[1] = clockTime.min.format(FORMAT_MIN_SEC);
		timeData[2] = "";
		if(!is24Hour) {
			timeData[0] = clockTime.hour == 0 ? 12 : clockTime.hour % 12;
			timeData[2] = clockTime.hour < 12 ? "AM" : "PM";
		}
		var timeString = Lang.format(FORMAT_TIME, timeData);
		var view = View.findDrawableById("TimeLabel") as Ui.Text;
		view.setText(timeString);
		// call the parent to update the display
		View.onUpdate(dc);
	}

}
