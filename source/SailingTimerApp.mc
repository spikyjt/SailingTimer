using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

enum
{
	MODE_STANDARD,
	MODE_PURSUIT
}

var timerView;
var mode = MODE_STANDARD;
var pursuitOffset = 0;

var initView;

class SailingTimerApp extends App.AppBase {

	function initialize() {
		AppBase.initialize();
	}

	//! onStart() is called on application start up
	//function onStart(state) {
	//}

	//! onStop() is called when your application is exiting
	//function onStop() {
	//}

	//! Return the initial view of your application here
	function getInitialView() {
		initView = new InitView();
		return [ initView, new InitDelegate() ];
	}

}
