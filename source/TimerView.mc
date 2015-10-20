using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention;

class TimerView extends Ui.View {

	var up = false;
	var started = false;

	hidden var seconds;
	hidden var timer;
	hidden var timeTimer;
	hidden var signalVibrate = [ new Attention.VibeProfile(50, 500) ];
    hidden var countdownVibrate = [ new Attention.VibeProfile(50, 300) ];
    hidden var startVibrate = [ new Attention.VibeProfile(50, 1000) ];

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.TimerLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	seconds = 300;
    	up = false;
    	started = false;
    	timerDisplay();
    	timer = new Timer.Timer();
    	timerStart();
    }

    //! Update the view
    function onUpdate(dc) {
     	// Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        // show the timer time
    	var atMinute = timerDisplay();
		// vibrate

		if(seconds == 0) { // pulse at start
			Attention.vibrate(startVibrate);
			startTones();
		} else if(!up) {
			if(atMinute) { // pulse on minute
				Attention.playTone(Attention.TONE_ALARM);
				Attention.vibrate(signalVibrate);
			} else if(seconds <= 10) { // pulse before start
	        	Attention.playTone(Attention.TONE_LOUD_BEEP);
				Attention.vibrate(countdownVibrate);
			}
        } else if(seconds < 5) {
        	startTones();
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	timer.stop();
    }

    function startTones() {
  	    Attention.playTone(Attention.TONE_ALARM);
		Attention.playTone(Attention.TONE_LOUD_BEEP);
	}

    function timerStart() {
    	timer.start(method(:onTimerUpdate), 1000, true);
    	started = true;
    }

    function onTimerUpdate() {
    	if(seconds == 0) {
        	up = true;
    	}
    	if(up) {
    		seconds++;
    	} else {
	    	seconds--;
	    }
    	Ui.requestUpdate();
    }

    function timerDisplay() {
    	var min = seconds / 60;
    	var sec = seconds % 60;
    	var timerString;
    	if(up) {
    		var hour = min / 60;
    		var realMin = min % 60;
 		   	timerString = Lang.format("$1$:$2$:$3$", [hour, realMin.format("%.2d"), sec.format("%.2d")]);
    	} else {
 		   	timerString = Lang.format("$1$:$2$", [min, sec.format("%.2d")]);
 		}
 		View.findDrawableById("TimerLabel").setText(timerString);
 		// return true if on a minute boundary
 		return sec == 0;
    }

    function sync(inc) {
    	if(started) {
			if(!up) {
		    	timer.stop();
		    	started = false;
		    	var minutes = (seconds / 60).toNumber();
		    	if(inc) {
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

}

class STBehaviorDelegate extends Ui.BehaviorDelegate {

	function onKey(evt) {
		if (evt.getKey() == Ui.KEY_ENTER) {
			return onEnter();
		}

		return false;
	}

}

class TimerDelegate extends STBehaviorDelegate {

	function onEnter() {
		timerView.stopStart();
		return true;
	}

	function onBack() {
		if(!timerView.sync()) {
			Ui.popView(Ui.SLIDE_DOWN);
		}
		return true;
	}

	function onNextPage() {
		return timerView.sync();
	}

	function onPreviousPage() {
		return timerView.sync(true);
	}

}
