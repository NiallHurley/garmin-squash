using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording as Record;
using Toybox.FitContributor as Fit;

//! Class used to record an activity
class ActivitySession {

    //! Garmin session object
    hidden var session;
    //! Time when the session started
    hidden var sessionStarted;
	// Field ID from resources.
	const CURRENTSTEPS_FIELD_ID = 1;
	const TOTALSTEPS_FIELD_ID = 2;	
	const CURRENTSTEPDIST_FIELD_ID = 3;
	const TOTALSTEPDIST_FIELD_ID = 4;	
	hidden var mStepsFieldCurrent;
	hidden var mStepsFieldTotal;
	hidden var mStepDistFieldCurrent;
	hidden var mStepDistFieldTotal;
	hidden var mModel;
	

    //! Constructor
    function initialize() {
        session = null;        
        mModel = Application.getApp().model;
    }
    
    function getModel(){
    // check if var mModel is null, if true, re get it and test for null... 
	    if (mModel == null){
	         System.println("mModel is null");
	         mModel = Application.getApp().model;
	         } else {         
	          System.println("mModel is not null");
	        }   
        if (mModel == null){
         System.println("mModel is still null");	         
         } else {         
          System.println("mModel is not null");
        }   	   
	    return mModel;        
    }

    //! Start recording a new session
    //! If the session was already recording, nothing happens
    function start(){
        System.println("Session Start");    
        if (session==null){
	        if(Toybox has :ActivityRecording ) {
	            if(!isRecording()) {
	                   session = Record.createSession({:name=>"Squash", 
	                                                   :sport=>Record.SPORT_TENNIS});
	                System.println("Session Created");
	                sessionStarted = Time.now(); 	                
	                mStepsFieldCurrent = session.createField("CurrentSteps", CURRENTSTEPS_FIELD_ID, Fit.DATA_TYPE_UINT32, { :mesgType=>Fit.MESG_TYPE_RECORD, :units=>"steps" });
	                mStepsFieldTotal = session.createField("TotalSteps", TOTALSTEPS_FIELD_ID, Fit.DATA_TYPE_UINT32, { :mesgType=>Fit.MESG_TYPE_SESSION, :units=>"steps" });
	                mStepDistFieldCurrent = session.createField("CurrentStepDist", CURRENTSTEPDIST_FIELD_ID, Fit.DATA_TYPE_UINT32, { :mesgType=>Fit.MESG_TYPE_RECORD, :units=>"steps" });
	                mStepDistFieldTotal = session.createField("TotalStepDist", TOTALSTEPDIST_FIELD_ID, Fit.DATA_TYPE_UINT32, { :mesgType=>Fit.MESG_TYPE_SESSION, :units=>"steps" });
	            }
	        }	        
	    }
	    session.start();		
		vibrate();
    }

    //! Stops the current session
    //! If the session was already stopped, nothing happens
    function stop() {        
        System.println("Session pausing/stopping");     
        session.stop();
    }
    
    function endSession(){
	    sessionStarted = null;
        session = null;
        System.println("Session stopped");
        vibrate();
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
    
    // called by the save confirm delegate
    //   - plenty of checks as this was proving troublesome
    function save(){                
       var numStepsToSave;
       System.println("Session save begin....");
       if (session == null){
         System.println("Session is null");
         } else {         
          System.println("Session is not null");
        }       
        getModel();
       if (mModel == null){
         System.println("mModel is null");
         } else {         
          System.println("mModel is not null");
        }
       mModel.update();       
       numStepsToSave = mModel.numberOfSteps;              
       System.println(numStepsToSave.toString());              
       mStepsFieldTotal.setData(numStepsToSave);
       mStepDistFieldTotal.setData(numStepsToSave*mModel.stepLength);
       session.save();
       System.println("Session saved.");
       endSession();        
    }
    
    function updateSteps(numStepsToSave){
       mStepsFieldCurrent.setData(numStepsToSave);            
    }
    function updateStepDist(stepDist){
    	mStepDistFieldCurrent.setData(stepDist);
    }
     
    // Discard the current session
    function discard() {
        session.discard();
        endSession();
    }
    
    //! Returns true if the session is recording
    function isRecording() {
        if (session == null){
         return false;
         } else {         
          return session.isRecording();
        }
    }

    //! Returns a string containing the session's elapsed time
    function getElapsedTime(){
            var time = "0:00:00";
            if (isRecording()) {
                var elapsedTime = 0;
                elapsedTime = Time.now().subtract(sessionStarted);
                var time_in_seconds = elapsedTime.value();
                var hrs = time_in_seconds / 3600;
                time_in_seconds -= (hrs * 3600);
                var min = time_in_seconds / 60;
                time_in_seconds -= (min * 60);
                time = Lang.format("$1$:$2$:$3$",
                [ hrs, min.format("%0.2d"), time_in_seconds.format("%0.2d") ]);
            }
            return time;
    }

    //! Performs a vibration. Used as feedback to the user
    //! for starting and stopping recording the session
    function vibrate() {
        if (Attention has :vibrate) {
            var vibrateData = [
                    new Attention.VibeProfile(  25, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile( 100, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  25, 100 )
                  ];

            Attention.vibrate(vibrateData);
        }
    }

    //! Adds a new lap to the fit file and
    //! sets players' score counters to 0
    //! (new set starts)
    function addLap() {
        session.addLap();
    }

}

