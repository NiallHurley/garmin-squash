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
        System.println("SD: Key pressed");
        var key = null;
        var keyType = null;
        key = keyEvent.getKey();
        keyType = keyEvent.getType();
        System.println("Key: " + key.toString() + ", keyType: " + keyType.toString());  // e.g. KEY_MENU = 7
        
        if (key==Ui.KEY_ENTER){
            System.println("SD: enter Key pressed");
             if (dataTracker.getSession().isRecording()) {  
            /* var message = "Continue?";
			 Ui.pushView(
				    new Ui.Confirmation(message),
				    new MyConfirmationDelegate(),
				    Ui.SLIDE_IMMEDIATE);*/		                                                
                System.println("SD: calling exitConfirm");
                exitConfirm();               
            	} else {
	            	System.println("SD: calling session start");
		            dataTracker.getSession().start();
		            Ui.requestUpdate();       
		            return true;
	         }
         /*if (exitApp == true){
			saveConfirm();
	    }*/
        
        }
    	        
            
    }

    //! Function called when the reset button of the UI is pressed.
    function onReset() {
    }


    //! Function called when user taps a touch screen.
    //! Replacement of Button feature that does not exist
    //! in sdk v1.3.1
    function onTap(evt) {
    }

    //! Event used when back button is pressed.
    //! It shows a confirmation dialig before quitting the App
    function onBack() {
        System.println("SD: onBack");
        /* Ui.pushView(new Confirmation(Ui.loadResource(Rez.Strings.confirm_exit)),
            new ExitConfirmationDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;*/
        exitConfirm();
    }
    
    function exitConfirm(){
        var dialog;
        System.println("SD: exitConfirm called.");
        
        dialog = new MyConfirmationView("Exit the app");
    	Ui.pushView(dialog,
            new ExitConfirmationDelegate(), Ui.SLIDE_LEFT );                           
    }  
    
}

class MyConfirmationView extends Ui.Confirmation{
	var promptString;
	
	function initialize(promptString){
		System.println("myCV: initialise");
		//System.println(inputPromptString);
		Confirmation.initialize(promptString);
		self.promptString = promptString;
		System.println("MyCV: " + self.promptString);
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
    }

    //! Event that happens on response of the user.
    //! When the user replies YES, then the App exits.
    function onResponse(response) {
       System.println(response);
        if (response == Ui.CONFIRM_YES) {
        	System.println("ECD: exit yes");
        	exitApp = true;
         //shouldSave = Ui.pushView( new Ui.Confirmation("Save?"), new  SaveConfirmationDelegate(), Ui.SLIDE_RIGHT );  
         System.println("ECD: line reached");	                  
        } else {
            System.println("ECD: Cancel");       
    	}
    	return true;	
    }
    /* function onBack() {
        System.println("ECD: onBack");
        return true;
     }
      function onMenu() {
        System.println("ECD: onMenu");
        return true;
     }
    */
    
}



class SaveConfirmationDelegate extends Ui.ConfirmationDelegate {
	var activitySession;
    
    function initialize(activitySession) {
        ConfirmationDelegate.initialize();
        self.activitySession = activitySession;
        System.println("SCD: initialized");
    }

    function onResponse(response) {
        /*if (response == 0) {
            System.println("Cancel");
        } else {
            System.println("Confirm");
            System.exit();
        }*/
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
        System.println("SCD: about to exit.");
        System.exit();
    }
}
