using Toybox.System;
using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Sensor as Snsr;

//! Class that represents the Squash Application
class SquashApp extends App.AppBase {

    //! Object that contains the data that will
    //! be displayed on screen
    hidden var dataTracker;

    //! Constructor
    function initialize() {
        AppBase.initialize();
        dataTracker = new DataTracker();
    }

    //! onStart() is called on application start up
    function onStart(state) {
        AppBase.onStart(state);
    }

    //! onStop() is called when the application is exiting
    function onStop(state) {
        // Stop the recoding session in case it was
        // not stopped before.
        var dialog;
        System.println("App onStop");
        
        dataTracker.getSession().save();        
        
        // #TODO: move call to saveConfirm here (more appropriate)
        /*
        System.println("saveConfirm called.");
        dialog = new MyConfirmationView("Save");
        //Ui.popView(Ui.SLIDE_LEFT);
    	Ui.pushView(dialog,
            new SaveConfirmationDelegate(dataTracker.getSession()), Ui.SLIDE_LEFT );
        System.println("saveConfirm end.");
        */
        
        // Let's disable the heart rate sensor
        Snsr.setEnabledSensors([]);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    //! Return the initial view of application
    function getInitialView() {
        return [new SquashView(dataTracker), new SquashDelegate(dataTracker) ];
    }

}
