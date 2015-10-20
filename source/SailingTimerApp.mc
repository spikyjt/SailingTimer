using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

var timerView;

class SailingTimerApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new InitView(), new InitDelegate() ];
    }

}
