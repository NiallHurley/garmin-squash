using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording as Record;
using Toybox.FitContributor as Fit;

//! Class used to record an activity
class ActivitySession {

    //! Garmin session object
    hidden var session;
    //! Time when the session started
    hidden var sessionStarted;

    //! Constructor
    function initialize() {
        session = null;
    }

    //! Start recording a new session
    //! If the session was already recording, nothing happens
    function start(){
        System.println("Start");    
        if(Toybox has :ActivityRecording ) {
            if(!isRecording()) {
                   session = Record.createSession({:name=>"Squash", 
                                                   :sport=>Record.SPORT_TENNIS,
                                                   :subSport=>Record.SUB_SPORT_MATCH});
                System.println("Session Created");                                                   
                session.start();
                sessionStarted = Time.now();
                vibrate();
            }
        }
    }

    //! Stops the current session
    //! If the session was already stopped, nothing happens
    function stop() {
        // ask user for confirmation
        System.println("Session stopping");     
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
    function save(){   
       if(isRecording()) {
           System.println("Session save begin....");
            session.save();
           System.println("Session saved.");
           endSession();
        }
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

