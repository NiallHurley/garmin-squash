// need to merge data tracker and activity session into one thing... more like the NamasteModel

//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;
using Toybox.Attention;
using Toybox.FitContributor;
using Toybox.ActivityRecording;
using Toybox.ActivityMonitor as Act;
using Toybox.Sensor as Snsr;



// This class handles the computation of the Quantitative Enlightenment
// metric.
using Toybox.WatchUi as Ui;
using Toybox.ActivityRecording as Record;
using Toybox.FitContributor as Fit;



// TODO: could add mZones - HR Zones to the display... i.e. current

//! Class used to record an activity
class SquashModel {
    //! Garmin session object
    hidden var session;
    //! Time when the session started
    hidden var sessionStarted=0;

    //! Number of steps done during the activity
    hidden var numberOfSteps;
    //! Number of calories burned during the activity
    hidden var numberOfCalories;
    //! Number of steps done when the activity started
    hidden var initialSteps;
    //! Amount of calories burnt until the activity started
    hidden var initialCalories;

    hidden var heartRate;

    var vibrateData1 = [new Attention.VibeProfile(100, 100),
                        new Attention.VibeProfile(100, 100),
                        new Attention.VibeProfile(100, 100)];

    var vibrateData2 = [new Attention.VibeProfile( 25, 100),
                        new Attention.VibeProfile(100, 100),
                        new Attention.VibeProfile( 25, 100),
                        new Attention.VibeProfile(100, 100)];

    //! Constructor
    function initialize() {
        System.println("SquashModel initialise " + sessionStarted);
        numberOfSteps = 0;
        numberOfCalories = 0;
        var activityInfo = Act.getInfo();
        initialSteps = activityInfo.steps;
        initialCalories = activityInfo.calories;
        Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        Snsr.enableSensorEvents( method(:onSnsr) );
    }


    //! Start recording a new session
    //! If the session was already recording, nothing happens
    function start(){
        System.println("SquashModel start");    
        session = Record.createSession({:name=>"Squash", 
                                        :sport=>Record.SPORT_TRAINING,
                                        :subSport=>Record.SUB_SPORT_CARDIO_TRAINING});
        System.println("Session Created");                                                   
        session.start();
        sessionStarted = Time.now();
        Attention.vibrate(vibrateData1);        
    }

    //! Stops the current session
    //! If the session was already stopped, nothing happens
    function stop() {
        System.println("SquashModel stop");
        // ask user for confirmation
        System.println("Session stopping");     
        session.stop();
        Attention.vibrate(vibrateData1);
    }
    
    // Resume the current session
    function resume(){
        System.println("SquashModel stop");
        // ask user for confirmation
        System.println("Session stopping");     
        session.start();
        Attention.vibrate(vibrateData1);
    }

    // called by the save confirm delegate
    function save(){   
        System.println("SquashModel Session save begin....");
        session.save();
        Attention.vibrate(vibrateData2);
    }
     
    // Discard the current session
    function discard() {
        System.println("SquashModel discard");
        session.discard();        
    }

    //! Returns the session's elapsed time in seconds
    //  - will this return 0 onExit? (if so can store prevElapsedTime...)
    function getElapsedTimeInSeconds(){
        //System.println("SquashModel getElapsedTimeInSeconds");
        var time_in_seconds = 0;
        if (session.isRecording()) {
            var elapsedTime = 0;
            elapsedTime = Time.now().subtract(sessionStarted);
            time_in_seconds = elapsedTime.value();
        }
        return time_in_seconds;
    }

    //! Returns a string containing the session's elapsed time
    function formatElapsedTime(time_in_seconds){
            var time = "0:00:00";            
            var hrs = time_in_seconds / 3600;
            time_in_seconds -= (hrs * 3600);
            var min = time_in_seconds / 60;
            time_in_seconds -= (min * 60);
            time = Lang.format("$1$:$2$:$3$",
            [ hrs, min.format("%0.2d"), time_in_seconds.format("%0.2d") ]);
            System.println(time);
            return time;
    }

    //! Performs a vibration. Used as feedback to the user
    //! for starting and stopping recording the session
    /*function vibrate() {
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
    }*/
  
    //! Adds a new lap to the fit file and
    //! sets players' score counters to 0
    //! (new set starts)
    function addLap() {
        session.addLap();
    }    

    //! Returns the number of steps done during the current activity
    function getNumberOfSteps() {
        var activityInfo = Act.getInfo();
        numberOfSteps = activityInfo.steps - initialSteps;
        return numberOfSteps;
    }

    //! Returns the number of calories burnt during the current activity
    function getNumberOfCalories(){
        var activityInfo = Act.getInfo();        
        numberOfCalories = activityInfo.calories - initialCalories;
        return numberOfCalories;
    }

    function getHeartRate(){
        return heartRate;
    }

    //! Function called to read heart rate sensor value
    function onSnsr(sensor_info)
    {
        if( sensor_info.heartRate != null )
        {
            heartRate = sensor_info.heartRate;
        }
        else
        {
            heartRate = -1;
        }
        Ui.requestUpdate();
    }


}

