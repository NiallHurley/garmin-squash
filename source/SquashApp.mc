using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;
using Toybox.Lang as Lang;

//! Class that represents the Squash Application
class SquashApp extends App.AppBase {

    //! Object that contains the data that will
    //! be displayed on screen
    var model;
    var controller;   

    //! Constructor
    function initialize() {
        AppBase.initialize();
		model = new SquashModel();        
        controller = new SquashController(null);
    } 

    //! onStart() is called on application start up
    function onStart(state) {        
    }

    //! onStop() is called when the application is exiting
    function onStop(state) {       
    }

    //! Return the initial view of application
    function getInitialView() {
        return [new $.SquashView(), new $.SquashDelegate() ];
    }

}
