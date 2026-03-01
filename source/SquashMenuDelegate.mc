//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application;
using Toybox.Timer;


// This delegate handles input for the Menu pushed when the user
// hits the stop button
class SquashMenuDelegate extends Ui.MenuInputDelegate {

    hidden var mController;
    hidden var mDeathTimer;

    // Constructor
    function initialize() {
        MenuInputDelegate.initialize();
        mController = Application.getApp().controller;
        System.println("SMD: init");
    }

    function onTap(event) {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.inputButtons == 0) {
            System.println("SMD: tap accepted (touchscreen-only device)");
            return false; // allow tap to propagate
        } else {
            System.println("SMD: tap ignored (physical buttons available)");
            return true; // suppress tap
        }
    }

    // Handle the menu input
    function onMenuItem(item) {
        if (item == :resume) {
        	System.println("SMD: menu:resume");
            mController.start();            
            return;
        } else if (item == :save) {
            System.println("SMD: menu:save");
            mController.save();
            if (mDeathTimer != null) {
                mDeathTimer.stop();
                mDeathTimer = null;
            }
            mDeathTimer = new Timer.Timer();
            var exitFn = mController.method(:onExit);
            if (exitFn != null) {
                mDeathTimer.start(exitFn, 3000, false);
            } else {
                System.println("SMD: onExit method not found on controller");
            }
            return;
        } else if (item == :discard) {
            System.println("SMD: menu:discard selected");
            mController.discard();
            if (mDeathTimer != null) {
                mDeathTimer.stop();
                mDeathTimer = null;
            }
            mDeathTimer = new Timer.Timer();
            var exitFn = mController.method(:onExit);
            if (exitFn != null) {
                mDeathTimer.start(exitFn, 3000, false);
            } else {
                System.println("SMD: onExit method not found on controller");
            }
            return;
        } else {
        	System.println("SMD: menu:discard");	
            mController.discard();
            return;
        }
    }

	/*function onBack(){
		mController.start();	
		return true;
	}
	function onKey(keyEvent) {
       //! if a key is pressed - print to debug window
        System.println("SMenuDelegate: Key pressed");
        var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();
        System.println("Key: " + key.toString() + ", keyType: " + keyType.toString());  // e.g. KEY_MENU = 7
        
        //! if key is the enter key (start/stop button)...
        //!  ... if recording an activity, prompt for the user to exit
        //!  ... else start the activity
        if (key==Ui.KEY_ENTER){
     	   mController.save();
     	   return true;
        } else {
        return false;
        }

    }*/
    

}
