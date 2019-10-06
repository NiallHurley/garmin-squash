using Toybox.ActivityMonitor as Act;
using Toybox.WatchUi as Ui;
using Toybox.System;


//! Class that holds the data that has to be
//! calculated and is displayed in the UI. - 
//! contains activitySession instance of class which stores session data
// - formerly known as dataTracker
class SquashModel {
    //! Number of steps done during the activity
    var numberOfSteps;
    //! Number of calories burned during the activity
    hidden var numberOfCalories;
    //! Number of steps done when the activity started
    hidden var initialSteps;
    //! Amount of calories burnt until the activity started
    hidden var initialCalories;
    //! Session used to record the activity
    hidden var activitySession;
    const stepLength = 1;

    //! Constructor
    function initialize() {
        activitySession = new ActivitySession();
        System.println("SM: initialise");
        restart();
    }
    
    function start(){
    	activitySession.start();
    }
    
    function stop(){
    	activitySession.stop();
	}
	
	// Save the current session
    function save() {
       System.println("SM: save");
       activitySession.save();
    }

    // Discard the current session
    function discard() {
        activitySession.discard();
    }

    //! Restarts all the data field to make it ready
    //! to record a new session
    function restart() {
        numberOfSteps = 0;
        numberOfCalories = 0;
        var activityInfo = Act.getInfo();
        initialSteps = activityInfo.steps;
        initialCalories = activityInfo.calories;
        if (activitySession != null && activitySession.isRecording()) {  
            System.println("Session stop - (activitySession)");          
            activitySession.stop();
        }
    }

    //! Updates the calculated values taken from
    //! the activity info data
    function update() {
        var activityInfo = Act.getInfo();
        numberOfSteps = activityInfo.steps - initialSteps;
        numberOfCalories = activityInfo.calories - initialCalories;
        activitySession.updateSteps(numberOfSteps);     
        activitySession.updateStepDist(numberOfSteps*stepLength);  
    }

    //! Returns the number of steps done during the current activity
    function getNumberOfSteps() {    
        return numberOfSteps;
    }

    //! Returns the number of calories burnt during the current activity
    function getNumberOfCalories(){
        return numberOfCalories;
    }

    //! Returns the session that records the activity
    function getSession() {
        return activitySession;
    }
}