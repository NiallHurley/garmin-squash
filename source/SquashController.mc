using Toybox.System;
using Toybox.Application;
using Toybox.WatchUi as Ui;

class SquashController {

    //! Object that contains the data that will
    //! be displayed on screen
    var mTimer;
    var mModel;
    var mRunning;

    //! Constructor
    //! @param mModel Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize() {
    	mTimer = null;
    	mModel = Application.getApp().model;
    	mRunning = false;    	                    
        shouldSave = true;
    }
    
    function start() {
        System.println("SC: start");
    	mModel.start();
    	mRunning = true;
    	mTimer = new Timer.Timer();
    	mTimer.start(method(:onTimer), 1000, true);
    }
    
    function stop(){
     	System.println("SC: stop");
    	mModel.stop();
    	mRunning = false;  
    }
    
    // Save the ording
    function save() {
    	System.println("SC: save");
        // Save the recording
        mModel.save();
        // Give the system some time to finish the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar("Saving...", null), 
        	new SquashProgressDelegate(), WatchUi.SLIDE_DOWN);
        mTimer = new Timer.Timer();
        mTimer.start(method(:onExit), 3000, false);
    }
    
    function discard() {
    	System.println("SC: discard");
        // Discard the recording
        mModel.discard();
        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar("Discarding...", null), 
        	new SquashProgressDelegate(), WatchUi.SLIDE_DOWN);
        mTimer = new Timer.Timer();
        mTimer.start(method(:onExit), 3000, false);
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
        System.println("SquashDelegate onMenu");
        return true;
    }
    
    /*
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
        }
        return true;
    }
    */

    //! Function called when the reset button of the UI is pressed.
    function onReset() {
    	System.println("SC: onReset");
      return true;
    }

	// Are we running currently?
    function isRunning() {
        return mRunning;
    }
    
    // Handle the start/stop button
    function onStartStop() {
       System.println("SC: onStartStop");
        if(mRunning) {
            stop();
            System.println("SC: onStartStop - stop");
            WatchUi.pushView(new Rez.Menus.MainMenu(), 
            	new SquashMenuDelegate(), WatchUi.SLIDE_UP);
        } else {
        	System.println("SC: onStartStop - start");
            start();
        }
    }

    //! Function called when user taps a touch screen.
    //! Replacement of Button feature that does not exist
    //! in sdk v1.3.1
    function onTap(evt) {
    	return true;
    }

    //! Event used when back button is pressed.
    //! It shows a confirmation dialig before quitting the App
    function onBack() {
        System.println("SC: onBack");
        return true;
    }    
       
    function onTimer(){
    	Ui.requestUpdate();
    }
    
    function onExit(){
    	System.println("SC: onExit");
    	System.exit();
    }
}