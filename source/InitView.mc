using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Timer as Timer;
using Toybox.Graphics as Gfx;

class InitView extends BaseView {

	hidden var timer;

	function initialize() {
		BaseView.initialize();
	}

	function onLayout(dc) {
		setLayout(Rez.Layouts.InitLayout(dc));
	}

	//! Called when this View is brought to the foreground. Restore
	//! the state of this View and prepare it to be shown. This includes
	//! loading resources into memory.
	function onShow() {
		timerView = new TimerView();
		timer = new Timer.Timer();
		timer.start(method(:updateTime), 1000, true);
		var modeLabel = View.findDrawableById("ModeLabel");
		var offsetLabel = View.findDrawableById("OffsetTimerLabel");
		if(mode == MODE_PURSUIT) {
			modeLabel.setText("Pursuit");
			modeLabel.setColor(Gfx.COLOR_RED);
			offsetLabel.setText(timerView.timerString(true));
		} else {
			modeLabel.setText("Standard");
			modeLabel.setColor(Gfx.COLOR_BLUE);
			offsetLabel.setText("");
		}
		Ui.requestUpdate();
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
	
	function goPursuit() {
		var modeLabel = View.findDrawableById("ModeLabel");
		var offsetLabel = View.findDrawableById("OffsetTimerLabel");
		modeLabel.setText("Pursuit");
		modeLabel.setColor(Gfx.COLOR_RED);
		offsetLabel.setText(timerView.timerString(true));
		Ui.requestUpdate();
	}

}

class InitDelegate extends STBehaviorDelegate {

	function initialize() {
		STBehaviorDelegate.initialize();
	}

	function onEnter() {
		Ui.pushView(timerView, new TimerDelegate(), Ui.SLIDE_UP);
		return true;
	}

	function onMenu() {
		mode = MODE_STANDARD;
		Ui.pushView(new Rez.Menus.TimerOptions(), new TimerOptionsDelegate(), Ui.SLIDE_UP);
	}

}
