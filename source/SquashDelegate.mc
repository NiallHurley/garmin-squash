using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording;
using Toybox.Application;
using Toybox.System;

//using Toybox.Time as Time;
//using Toybox.System;


//! Class that handles events coming from
//! the Squash View
class SquashDelegate extends Ui.InputDelegate {

    //! Object that contains the data that will
    //! be displayed on screen
    var squashController;
    var isTouchScreen;

    //! Constructor
    //! @param dataTracker Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize() {
        // Initialize the superclass
        InputDelegate.initialize();
        squashController = Application.getApp().controller;
        var mySettings = System.getDeviceSettings();
        isTouchScreen  = mySettings.isTouchScreen;
        System.println("SquashDelegate initialise - is touch screen: " + isTouchScreen );
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
        System.println("SquashDelegate onMenu");
        return true;
    }

    function onBack() {
        System.println("SquashDelegate onBack");
        // return true;
    }

    
    // block access to onHide (swipe from L to R)
    function onHide() {
        System.println("SquashDelegate onHide");
        squashController.onStartStop();
        // return true;
    }

      // block access to onHide (swipe from L to R)
    function onSwipe(swipeEvent) {
        System.println("SquashDelegate onSwipe");
        squashController.onStartStop();
        // return true;
    }
    
    // Input handling of start/stop is mapped to onSelect
    function onSelect() {
        if (isTouchScreen) {
            System.println("isTouchScreen - onSelect is blocked");        
            // do nothing when the touch screen is touched... 
        }
        else{
            // Pass the input to the controller
            System.println("SquashDelegate onSelect");
            squashController.onStartStop();
            // return true;
        }
    }

    
    //! Function called when the reset button of the UI is pressed.
    function onReset() {
        System.println("SquashDelegate onReset");
        return true; // block this call
    }

    function onKey(keyEvent) {
       //! if a key is pressed - print to debug window and block call
        System.println("SquashDelegate: Key pressed");
        var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();
        System.println("Key: " + key.toString() + ", keyType: " + keyType.toString());  // e.g. KEY_MENU = 7  

        // if is a touch screen device then capture the top-right button press (to override Garmin's remapping of the OnSelect function <eyeroll>)
        if(isTouchScreen){ 
            if((key==4)&&(keyType==2)){
                // if the top right button is pressed then call start/stop
                // Pass the input to the controller
                System.println("SquashDelegate onSelect");
                squashController.onStartStop();
                // return true;
            }
        }


        return true;
    }
    
}