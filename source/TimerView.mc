using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention;
using Toybox.Graphics as Gfx;

class TimerView extends BaseView {

	var up = false;
	var inOffset = false;
	var started = false;
	var seconds = 300;

	hidden var timer;
	hidden var timeTimer;
	hidden var center = new [2];

	hidden var vibes = false;
	hidden var tones = false;

	const STATE_MINUTE = 0;
	const STATE_SIGNAL = 1;
	const STATE_COUNTDOWN = 2;
	const STATE_START = 3;
	const STATE_STARTED = 4;

	function initialize() {
		BaseView.initialize();

		if(Attention has :VibeProfile && vibes == false) {
			vibes = [
				[ new Attention.VibeProfile(30, 300) ], // STATE_MINUTE
				[ new Attention.VibeProfile(50, 500) ], // STATE_SIGNAL
				[ new Attention.VibeProfile(50, 300) ], // STATE_COUNTDOWN
				[ new Attention.VibeProfile(50, 1000) ], // STATE_START
				false // STATE_STARTED
			];
		}

		if(Attention has :playTone && tones == false) {
			tones = [
				false, // STATE_MINUTE
				Attention.TONE_ALARM, // STATE_SIGNAL
				Attention.TONE_LOUD_BEEP, // STATE_COUNTDOWN
				Attention.TONE_ALARM, // STATE_START
				Attention.TONE_ALARM // STATE_STARTED
			];
		}
	}

	function onLayout(dc) {
		center[0] = dc.getWidth() / 2;
		center[1] = (dc.getHeight() - dc.getFontHeight(Gfx.FONT_NUMBER_THAI_HOT)) / 2;
		if(mode == MODE_PURSUIT) {
			setLayout(Rez.Layouts.OffsetTimerLayout(dc));
			View.findDrawableById("TimerLabel").setColor(Gfx.COLOR_BLUE);
		} else {
			setLayout(Rez.Layouts.TimerLayout(dc));
		}
	}

	//! Called when this View is brought to the foreground. Restore
	//! the state of this View and prepare it to be shown. This includes
	//! loading resources into memory.
	function onShow() {
		up = false;
		inOffset = false;
		started = false;
		timerDisplay();
		timer = new Timer.Timer();
		timerStart();
	}

	//! Update the view
	function onUpdate(dc) {
		// show the timer time
		timerDisplay();
		// vibrate
		if(seconds == 0 || (mode == MODE_PURSUIT && pursuitSeconds() == 0)) { // pulse at start
			notify(STATE_START);
		} else if(!up) {
			var isMainMinute = !inOffset && (seconds % 60) == 0;
			if(isMainMinute || (mode == MODE_PURSUIT && (pursuitSeconds() % 60) == 0)) { // pulse on minute
				var isSignalMinute = false;
				if(isMainMinute) {
					var min = seconds / 60;
					if(min == 5 || min == 4 || min == 1) { // tone on signal
						isSignalMinute = true;
					}
				}

				notify(isSignalMinute ? STATE_SIGNAL : STATE_MINUTE);
			} else if((mode == MODE_PURSUIT && pursuitSeconds() <= 10) ||
					(mode != MODE_PURSUIT && seconds <= 10)) { // pulse before start (countdown)
				notify(STATE_COUNTDOWN);
			}
		} else if(seconds < 5 && !inOffset) {
			notify(STATE_STARTED);
		}
		// call the parent to update the time and display
		BaseView.onUpdate(dc);
	}

	//! Called when this View is removed from the screen. Save the
	//! state of this View here. This includes freeing resources from
	//! memory.
	function onHide() {
		timer.stop();
	}

	function timerStart() {
		timer.start(method(:onTimerUpdate), 1000, true);
		started = true;
	}

	function onTimerUpdate() {
		if(seconds == 0) {
			if(mode == MODE_PURSUIT) {
				inOffset = true;
				View.findDrawableById("OffsetTimerLabel").setLocation(center[0], center[1]);
				View.findDrawableById("TimerLabel").setText("");
			} else {
				up = true;
			}
		} else if(mode == MODE_PURSUIT && pursuitSeconds() == 0) {
			inOffset = false;
			up = true;
			seconds = 0;
		}
		if(up) {
			seconds++;
		} else {
			seconds--;
		}
		Ui.requestUpdate();
	}

	function timerDisplay() {
 		if(mode == MODE_PURSUIT) {
 			if(!up && seconds >= 0) {
 				View.findDrawableById("TimerLabel").setText(timerString(false));
 			}
 			View.findDrawableById("OffsetTimerLabel").setText(timerString(!up));
 		} else {
 			View.findDrawableById("TimerLabel").setText(timerString(false));
 		}
	}

	function timerString(withOffset) {
		var min;
		var sec;
		if(withOffset) {
			min = pursuitSeconds() / 60;
			sec = pursuitSeconds() % 60;
		} else {
			min = seconds / 60;
			sec = seconds % 60;
		}
		var timerString;
		if(up) {
			var hour = min / 60;
			var realMin = min % 60;
 		   	timerString = Lang.format(FORMAT_UP_TIME, [hour, realMin.format(FORMAT_MIN_SEC), sec.format(FORMAT_MIN_SEC)]);
		} else {
 		   	timerString = Lang.format(FORMAT_TIMER, [min, sec.format(FORMAT_MIN_SEC)]);
 		}

 		return timerString;
 	}

	function sync(inc) {
		if(started) {
			if(!up && !inOffset) {
				timer.stop();
				started = false;
				var minutes = (seconds / 60).toNumber();
				if(inc && minutes < 5) {
					minutes++;
				}
				seconds = minutes * 60;
				timerStart();
				Ui.requestUpdate();
			}
			return true;
		} else {
			return false;
		}
	}

	function stopStart() {
		if(started) {
			timer.stop();
			started = false;
		} else {
			timerStart();
		}
	}

	function pursuitSeconds() {
		return seconds + pursuitOffset;
	}

	function notify(state) {
		if(vibes != false && vibes[state] != false) {
			Attention.vibrate(vibes[state]);
		}

		if(tones != false && tones[state] != false) {
			Attention.playTone(tones[state]);
		}
	}

}

class STBehaviorDelegate extends Ui.BehaviorDelegate {

	function initialize() {
		BehaviorDelegate.initialize();
	}

	function onKey(evt) {
		if (evt.getKey() == Ui.KEY_ENTER) {
			return onEnter();
		}

		return false;
	}

}

class TimerDelegate extends STBehaviorDelegate {

	function initialize() {
		STBehaviorDelegate.initialize();
	}

	function onEnter() {
		timerView.stopStart();
		return true;
	}

	function onBack() {
		if(!timerView.sync(false)) {
			Ui.popView(Ui.SLIDE_DOWN);
		}
		return true;
	}

	function onNextPage() {
		return timerView.sync(false);
	}

	function onPreviousPage() {
		return timerView.sync(true);
	}

}
