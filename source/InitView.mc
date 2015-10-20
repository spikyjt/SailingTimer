using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;

class InitView extends Ui.View {

	hidden var timer;
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	timer = new Timer.Timer();
    	timer.start(method(:updateTime), 1000, true);
    }

    //! Update the view
    function onUpdate(dc) {
     	// Get and show the current time
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function updateTime() {
    	Ui.requestUpdate();
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	timer.stop();
    }

}

class InitDelegate extends STBehaviorDelegate {

	function onEnter() {
		timerView = new TimerView();
		Ui.pushView(timerView, new TimerDelegate(), Ui.SLIDE_UP);
        return true;
	}

}
