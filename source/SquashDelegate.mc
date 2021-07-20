using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording;
using Toybox.Application;

//using Toybox.Time as Time;
//using Toybox.System;


//! Class that handles events coming from
//! the Squash View
class SquashDelegate extends Ui.BehaviorDelegate {

    //! Object that contains the data that will
    //! be displayed on screen
    var squashController;

    //! Constructor
    //! @param dataTracker Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize() {
        // Initialize the superclass
        BehaviorDelegate.initialize();
        squashController = Application.getApp().controller;
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
        System.println("SquashDelegate onMenu");
        return true;
    }
    
    // block access to onHide (swipe from L to R)
    function onHide() {
        System.println("SquashDelegate onHide");
        return true;
    }
    
    // Input handling of start/stop is mapped to onSelect
    function onSelect() {
        // Pass the input to the controller
        System.println("SquashDelegate onSelect");
        squashController.onStartStop();
        return true;
    }

    
    //! Function called when the reset button of the UI is pressed.
    function onReset() {
        System.println("SquashDelegate onReset");
        return true; // block this call
    }

    function onKey(keyEvent) {
       //! if a key is pressed - print to debug window
        System.println("SD: Key pressed");
        var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();
        System.println("Key: " + key.toString() + ", keyType: " + keyType.toString());  // e.g. KEY_MENU = 7
        
        //! if key is the enter key (start/stop button)...
        //!  ... if recording an activity, prompt for the user to exit
        //!  ... else start the activity
        if (key==Ui.KEY_ENTER){
            System.println("SD: enter Key pressed");
             if (squashController.isRunning()) {  
                System.println("SD: isRunning");
               // exitConfirm();               
            	} else {
	            	System.println("SD: not isRunning");
		           // dataTracker.getSession().start();
		            Ui.requestUpdate();       
		            return true;
	         }
        }
        return true;
    }
    
}