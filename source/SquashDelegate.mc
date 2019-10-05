using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System;

var shouldSave = true;
var exitApp = false;

// Confirmation delegate used by the SquashDelegate
class SquashConfirmationDelegate extends Ui.ConfirmationDelegate
{
   hidden var mController;

    // Hold onto the controller
   function initialize(controller) {
       ConfirmationDelegate.initialize();
       mController = controller;
       System.println("SConfDelegate: init");
    }

    // Handle the confirmation dialog response
   function onResponse(response) {
       if( response == WatchUi.CONFIRM_YES ) {
           mController.stop();
           mController.discard();
       }
    }
}


//! Class that handles events coming from
//! the Squash View
// The SquashDelegate forwards the inputs to the
// SquashController. 
class SquashDelegate extends Ui.BehaviorDelegate {

    // Controller class
    var mController;

    // Constructor
    function initialize() {
        // Initialize the superclass
        BehaviorDelegate.initialize();
        // Get the controller from the application class
        mController = Application.getApp().controller;
    }

    // Input handling of start/stop is mapped to onSelect
    function onSelect() {
        // Pass the touchscreen input to the controller
        //mController.onStartStop();
        return true;
	}
    // Block access to the menu button
    function onMenu() {
        return true;
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
     	   mController.onStartStop();
        }
        return true;
    }
    
     // Handle the back action
    function onBack() {
       // If the timer is running, confirm they want to exit
   /*    if(mController.isRunning()) {
           WatchUi.pushView(new WatchUi.Confirmation("Are you sure?"),
               new SquashConfirmationDelegate(mController), WatchUi.SLIDE_IMMEDIATE );
           // Don't let the system handle the message!
           return true;
       }*/
       // Pass the message through to the system
       return true;
    }
}
