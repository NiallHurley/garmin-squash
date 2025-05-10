using Toybox.System;
using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Timer;

class SquashController {

    //! Object that contains the data that will
    //! be displayed on screen
    var mTimer;
    var mModel;
    var mRunning;
    var mView;

    //! Constructor
    //! @param mModel Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize(view) {
    	mTimer = null;
    	mModel = Application.getApp().model;
        mView = view;
    	mRunning = false;    	                    
        shouldSave = true;
        return;
    }
    
    function start() {
        System.println("SC: start");
    	mModel.start();
    	mRunning = true;
        if (mTimer != null) {
            mTimer.stop();
            mTimer = null;
        }
    	mTimer = new Timer.Timer();
    	mTimer.start(mView.getOnTimer(), 1000, true);
        return;
    }
    
    function stop(){
     	System.println("SC: stop");
    	mModel.stop();
    	mRunning = false;  
        return;
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
        if (mTimer != null) {
            mTimer.stop();
            mTimer = null;
        }
        mTimer = new Timer.Timer();
        if (mView != null) {
            var exitFn = method(:onExit);;
            mTimer.start(exitFn, 3000, false);
        } else {
            System.println("SC: mView is null — can't call onExit");
        }
        return;
    }
    
    function discard() {
    	System.println("SC: discard");
        // Discard the recording
        mModel.discard();
        // Give the system some time to discard the recording. Push up a progress bar
        // and start a timer to allow all processing to finish
        WatchUi.pushView(new WatchUi.ProgressBar("Discarding...", null), 
        	new SquashProgressDelegate(), WatchUi.SLIDE_DOWN);
        if (mTimer != null) {
            mTimer.stop();
            mTimer = null;
        }
        mTimer = new Timer.Timer();
        if (mView != null) {
            var exitFn = method(:onExit);
            mTimer.start(exitFn, 3000, false);
        } else {
            System.println("SC: mView is null — can't call onExit");
        }
        return;
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
        System.println("SquashDelegate onMenu");
        return;
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

    function onKey(keyEvent) {
        var key = keyEvent.getKey();
        var keyType = keyEvent.getType(); 
        System.println("Key: " + key.toString() + ", keyType: " + keyType.toString());

        if (key == Ui.KEY_ENTER || key == Ui.KEY_START) {
            onStartStop();
            return true;
        } else if (key == Ui.KEY_UP) {
            System.println("SC: UP key pressed");
            // Optional: navigate up or handle UI event
            return true;
        } else if (key == Ui.KEY_DOWN) {
            System.println("SC: DOWN key pressed");
            // Optional: navigate down or handle UI event
            return true;
        } else if (key == Ui.KEY_ESC) {
            onBack();
            return true;
        }
        return false;
    }

    //! Function called when the reset button of the UI is pressed.
    function onReset() {
    	System.println("SC: onReset");
      return;
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
            return;
        } else {
        	System.println("SC: onStartStop - start");
            start();
            return;
        }
    }

    function onSelect() {
        System.println("SC: onSelect");
        onStartStop();
        return true;
    }

    //! Function called when user taps a touch screen.
    //! Only runs on touchscreen-enabled devices.
    function onTap(evt) {
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.isTouchScreen && deviceSettings.inputButtons == 0) {
            System.println("SC: tap - onStartStop called as device is touchscreen-only");
            onStartStop();
        } else {
            System.println("SC: ignoring tap"); // Prefer physical buttons if available
        }
        return;
    }

    //! Event used when back button is pressed.
    //! It shows a confirmation dialig before quitting the App
    function onBack() {
        System.println("SC: onBack");
        return;
    }    
       
    public function onExit() { 
        System.println("SquashView: onExit called");
        System.exit();
        return;
    }
}