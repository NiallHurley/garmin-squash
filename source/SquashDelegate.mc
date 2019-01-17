using Toybox.WatchUi as Ui;
using Toybox.Time as Time;
using Toybox.System;

var shouldSave = true;
var exitApp = false;

//! Class that handles events coming from
//! the Squash View
class SquashDelegate extends Ui.BehaviorDelegate {

    //! Object that contains the data that will
    //! be displayed on screen
    var dataTracker;

    //! Constructor
    //! @param dataTracker Shared objtect that contains
    //!       the data that will be displayed on screen
    function initialize(dataTracker) {
        BehaviorDelegate.initialize();
        self.dataTracker = dataTracker;
        shouldSave = true;
    }

    //! Function called when the menu button is pressed
    //! In this view, it should start or stop recording
    //! the session
    function onMenu() {
        System.println("SquashDelegate onMenu");
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
            System.println("SD: enter Key pressed");
             if (dataTracker.getSession().isRecording()) {  
                System.println("SD: calling exitConfirm");
                exitConfirm();               
            	} else {
	            	System.println("SD: calling session start");
		            dataTracker.getSession().start();
		            Ui.requestUpdate();       
		            return true;
	         }
        }
        return true;
    }

    //! Function called when the reset button of the UI is pressed.
    function onReset() {
      return true;
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
        System.println("SD: onBack");
        if (!dataTracker.getSession().isRecording()) {  
                System.println("SD: calling exitConfirm");
                exitConfirm();
                }
        return true;
    }
    
    function exitConfirm(){
    //! confirmation dialog to exit or continue
        var dialog;
        System.println("SD: exitConfirm called.");
        dialog = new MyConfirmationView("Exit the app");
    	Ui.pushView(dialog,
            new ExitConfirmationDelegate(), Ui.SLIDE_LEFT );            
        return true;               
    }  
}

class MyConfirmationView extends Ui.Confirmation{
    //! Generic confirmationView which stores the promptString and logs activity to the console
	var promptString;
	
	function initialize(promptString){
		System.println("myCV: initialise");
		Confirmation.initialize(promptString);
		self.promptString = promptString;
		System.println("MyCV: " + self.promptString);
		return true;
	}

	function onKey(keyEvent) {
        System.println("MyCV: Key pressed");
                var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();        
        System.println("MyCV: Key: " + key.toString() + ", keyType: " + keyType.toString() + promptString);  // e.g. KEY_MENU = 7
        return true;
     }
     
      function onBack() {
        System.println("MyCV: onBack");
        return true;
     }
      function onMenu() {
        System.println("MyCV: onMenu");
        return true;
     }
}


//! Delegate that handles the event from the Confirmation dialog
//! that appears before quitting the App.
class ExitConfirmationDelegate extends Ui.ConfirmationDelegate {
    
    function initialize() {
        ConfirmationDelegate.initialize();
        System.println("ECD: initialise");      
        return true; 
    }

    //! Event that happens on response of the user.
    //! When the user replies YES, then the App exits.
    function onResponse(response) {
       System.println(response);
        if (response == Ui.CONFIRM_YES) {
        	System.println("ECD: exit yes");
        	exitApp = true;
        	System.exit();
         System.println("ECD: line reached");	                  
        } else {
            System.println("ECD: Cancel");       
    	}
    	return true;	
    }
}

class SaveConfirmationDelegate extends Ui.ConfirmationDelegate {
    //! called from Activity session when the session is stopped - asks the user
    //!  if they would like to save/discard the session data.. then exits (to app.onStop)
	var activitySession;
    
    function initialize(activitySession) {
        ConfirmationDelegate.initialize();
        self.activitySession = activitySession;
        System.println("SCD: initialized");
        return true;
    }

    function onResponse(response) {
        System.println("saveConfirm reached");	        
        if (response == Ui.CONFIRM_YES) {
	        System.println("SCD: confirm yes - saving");
	        shouldSave = true;
	        self.activitySession.save();	        
        } else {
        	System.println("SCD: confirm no - not saving");
        	self.activitySession.discard();
        	shouldSave = false;
        }
        return true;
    }
}
