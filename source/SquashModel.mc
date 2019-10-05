using Toybox.ActivityMonitor as Act;
using Toybox.WatchUi as Ui;
using Toybox.System;


//! Class that holds the data that has to be
//! valculated and is displayed in the UI.
// - formerly known as dataTracker
class SquashModel {
    //! Number of steps done during the activity
    hidden var numberOfSteps;
    //! Number of calories burned during the activity
    hidden var numberOfCalories;
    //! Number of steps done when the activity started
    hidden var initialSteps;
    //! Amount of calories burnt until the activity started
    hidden var initialCalories;
    //! Session used to record the activity
    hidden var session;

    //! Constructor
    function initialize() {
        session = new ActivitySession();
        System.println("SM: initialise");
        restart();
    }
    
    function start(){
    	session.start();
    }
    
    function stop(){
    	session.stop();
	}
	
	// Save the current session
    function save() {
       session.save();
    }

    // Discard the current session
    function discard() {
        session.discard();
    }

    //! Restarts all the data field to make it ready
    //! to record a new session
    function restart() {
        numberOfSteps = 0;
        numberOfCalories = 0;
        var activityInfo = Act.getInfo();
        initialSteps = activityInfo.steps;
        initialCalories = activityInfo.calories;
        if (session != null && session.isRecording()) {  
            System.println("Session stop");          
            session.stop();
        }
    }

    //! Updates the calculated values taken from
    //! the activity info data
    function update() {
        var activityInfo = Act.getInfo();
        numberOfSteps = activityInfo.steps - initialSteps;
        numberOfCalories = activityInfo.calories - initialCalories;        
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
        return session;
    }
}