using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;

//! Class that represents the Squash Application
class SquashApp extends App.AppBase {

    //! Object that contains the data that will
    //! be displayed on screen
    var model;
    var controller;

    //! Constructor
    function initialize() {
        AppBase.initialize();
        model = new $.SquashModel();
        controller = new $.SquashController();
        System.println("App initialise"); 
    }

    //! onStart() is called on application start up
    function onStart(state) {        
    System.println("App onStart"); 
    }

    //! onStop() is called when the application is exiting
    function onStop(state) {
        // Stop the recoding session in case it was
        // not stopped before.                
        System.println("App onStop");        
    }

    //! Return the initial view of application
    function getInitialView() {
        System.println("App getInitialView"); 
        return [new SquashView(), new SquashDelegate() ];
    }

}
