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

    // Handle the menu input
    function onMenuItem(item) {
        if (item == :resume) {
            mController.start();
            return true;
        } else if (item == :save) {
            mController.save();
            return true;
        } else {
            mController.discard();
            return true;
        }
        return false;
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