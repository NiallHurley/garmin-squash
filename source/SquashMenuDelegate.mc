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
        System.println("SquashMenuDelegate initialize");        
    }

    // Handle the menu input
    function onMenuItem(item) {
        System.println("SquashMenuDelegate onMenuItem");        
        if (item == :resume) {
            System.println("SquashMenuDelegate resume");        
            mController.resume();
            // return true;
        } else if (item == :save) {
            System.println("SquashMenuDelegate save");        
            mController.save();
            // return true;
        } else {
            System.println("SquashMenuDelegate discard");        
            mController.discard();
            // return true;
        }
        // return false;
    }


}