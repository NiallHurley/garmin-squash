using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System;

//! Class that handles events coming from
//! the Squash View
class SquashDelegate extends Ui.BehaviorDelegate {

    //! Object that contains the data that will
    //! be displayed on screen
    hidden var dataTracker;

    //! Constructor
    //! @param dataTracker Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize(dataTracker) {
        BehaviorDelegate.initialize();
        self.dataTracker = dataTracker;
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
       /* if (dataTracker.getSession().isRecording()) {
            //TODO: Implement this logic in a more encapsulated way
            System.println("Delegate onMenu - session stop");
            //dataTracker.getSession().stop();
        }
        else {
            // Let's set all counters to 0, just in case
            dataTracker.getSession().start();
        }
        Ui.requestUpdate();
        return true;*/
    }
    
     function onKey(keyEvent) {
        System.println("Key pressed");
        var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();
        System.println(key);  // e.g. KEY_MENU = 7
        System.println(keyType); // e.g. PRESS_TYPE_DOWN = 0
        
        if (key==Ui.KEY_ENTER){
            System.println("enter Key pressed");
             if (dataTracker.getSession().isRecording()) {            
             Ui.pushView(new Ui.Confirmation("Exit app?"),
            new ExitConfirmationDelegate(), Ui.SLIDE_LEFT );
            }
            else {
            dataTracker.getSession().start();
            Ui.requestUpdate();       
            return true;
            }
        
        }
            
    }

    //! Function called when the reset button of the UI is pressed.
    function onReset() {
        dataTracker.reset();
    }


    //! Function called when user taps a touch screen.
    //! Replacement of Button feature that does not exist
    //! in sdk v1.3.1
    function onTap(evt) {
    }

    //! Event used when back button is pressed.
    //! It shows a confirmation dialig before quitting the App
    function onBack() {
        /* Ui.pushView(new Confirmation(Ui.loadResource(Rez.Strings.confirm_exit)),
            new ExitConfirmationDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;*/
    }
}

//! Delegate that handles the event from the Confirmation dialog
//! that appears before quitting the App.
class ExitConfirmationDelegate extends Ui.ConfirmationDelegate {

    function initialize() {
        ConfirmationDelegate.initialize();
    }

    //! Event that happens on response of the user.
    //! When the user replies YES, then the App exits.
    function onResponse(response) {
        if (response == Ui.CONFIRM_YES) {
        System.println("confirm yes - exiting");
            System.exit();
        }
    }
}