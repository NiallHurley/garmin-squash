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
       return;
   }

   // Handle the confirmation dialog response
   function onResponse(response) {
       if (response == WatchUi.CONFIRM_YES) {
           mController.stop();
           mController.discard();
       }
       return true;
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
        System.println("SD: onSelect pressed");
        mController.onStartStop();
        return true;
    }

    // Block access to the menu button
    function onMenu() {
        System.println("SD: Menu pressed");
        return true;
    }

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        var keyType = keyEvent.getType();
        System.println("SD: Key: " + key.toString() + ", keyType: " + keyType.toString());

        // Handle START/ENTER button
        if (key == Ui.KEY_ENTER || key == Ui.KEY_START) {
            System.println("SD: START/ENTER pressed");
            mController.onStartStop();
            return true;

        // Handle UP button
        } else if (key == Ui.KEY_UP) {
            System.println("SD: UP key pressed");
            return true;

        // Handle DOWN button
        } else if (key == Ui.KEY_DOWN) {
            System.println("SD: DOWN key pressed");
            return true;

        // Handle BACK or LAP/RESET button
        } else if (key == Ui.KEY_ESC || key == Ui.KEY_DOWN_RIGHT) {
            System.println("SD: BACK key pressed");
            onBack();
            return true;
        }

        return false;
    }

    // Handle the back action
    function onBack() {
        System.println("SD: onBack pressed");
        return true;
    }
}