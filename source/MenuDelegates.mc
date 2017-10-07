using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Time as Time;

class TimerOptionsDelegate extends Ui.MenuInputDelegate {

	function initialize() {
		MenuInputDelegate.initialize();
	}

	function onMenuItem(item) {
		if(item == :TimerOption_standard) {
			mode = MODE_STANDARD;
		} else if(item == :TimerOption_pursuit) {
			mode = MODE_PURSUIT;
			Ui.popView(Ui.SLIDE_LEFT);
			Ui.pushView(new Rez.Menus.PursuitOptions(), new PursuitOptionsDelegate(), Ui.SLIDE_LEFT);
		}
	}

}

class PursuitOptionsDelegate extends Ui.MenuInputDelegate {

	function initialize() {
		MenuInputDelegate.initialize();
	}

	hidden var offsets = {
		:PursuitOption_30 => 30,
		:PursuitOption_60 => 60,
		:PursuitOption_90 => 90,
		:PursuitOption_120 => 120,
		:PursuitOption_150 => 150,
		:PursuitOption_180 => 180,
		:PursuitOption_210 => 210,
		:PursuitOption_240 => 240
	};

	function onMenuItem(item) {
		if(item == :PursuitOption_custom) {
			Ui.popView(Ui.SLIDE_LEFT);
			Ui.pushView(new Ui.NumberPicker(Ui.NUMBER_PICKER_TIME_MIN_SEC, new Time.Duration(0)), new PursuitTimeDelegate(), Ui.SLIDE_LEFT);
		} else {
			pursuitOffset = offsets[item];
		}
	}

}

class PursuitTimeDelegate extends Ui.NumberPickerDelegate {

	function initialize() {
		NumberPickerDelegate.initialize();
	}
	
	function onNumberPicked(value) {
		pursuitOffset = value.value();
	}

}
