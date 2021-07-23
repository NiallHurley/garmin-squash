//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//
using Toybox.WatchUi as Ui;
using Toybox.Application;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Graphics as Gfx;

class SquashView extends Ui.View {

    hidden var mModel;    
    hidden var mController;
    hidden var mTimer;   

    hidden var mPrompt;
    hidden var mPromptLabel;

    hidden var mTimerLabel;
    hidden var mTimerLabelText;

    hidden var mClockLabel;
    hidden var mClockLabelText;

    hidden var mStepsLabel;
    hidden var mStepsLabelText;

    hidden var mHRLabel;
    hidden var mHRLabelText;
    hidden var heartImage;

    hidden var bitmapImage;

    // Initialize the View
    function initialize() {
        // Call the superclass initialize
        View.initialize();
        System.println("SquashView initialize");        
        // Get the model and controller from the Application
        mModel = Application.getApp().model;
        mController = Application.getApp().controller;
        // Initialize the label
        mTimerLabel = null;
        mClockLabel = null;
        mStepsLabel = null;
        mHRLabel = null;
        // load the resources
        mTimerLabelText = Ui.loadResource(Rez.Strings.timer_label);
        mClockLabelText = Ui.loadResource(Rez.Strings.clock_label);
        mStepsLabelText = Ui.loadResource(Rez.Strings.steps_label);
        mHRLabelText = Ui.loadResource(Rez.Strings.heartrate_label);        
        mPrompt = Ui.loadResource(Rez.Strings.prompt);
        mTimer = new Timer.Timer();    

        bitmapImage = new Ui.Bitmap({
            :rezId=>Rez.Drawables.bitmap_heart,
            :locX=>10,
            :locY=>30
        });
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("SquashView onLayout");
        // Load the layout from the resource file
        setLayout(Rez.Layouts.MainLayout(dc));
        // Cache the label away
        mPromptLabel = View.findDrawableById("PromptLabel");
        mTimerLabel = View.findDrawableById("TimerLabel");
        mStepsLabel = View.findDrawableById("StepsLabel");
        mHRLabel = View.findDrawableById("HRLabel");
        mClockLabel = View.findDrawableById("ClockLabel");
        
        heartImage =  Ui.loadResource(Rez.Drawables.bitmap_heart); 
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        System.println("SquashView onShow");
        mTimer.start(method(:onTimer), 1000, true);
    }

    // Update the view - this is called about once a second (see :onShow)
    function onUpdate(dc) {
        //System.println("SquashView onUpdate");
        // If we are running, show a running clock
        if(mController.isRunning() ) {
            // Elapsed  time
            var time = mController.getTime();        
            var timeString = Lang.format("$1$:$2$", [time / 60, (time % 60).format("%02d")]);
            mTimerLabel.setText(mTimerLabelText+timeString);
    
            // Clock Time
            var clockTime = System.getClockTime(); // ClockTime object  
            var clockTimeString = clockTime.hour.format("%02d")+":"+clockTime.min.format("%02d")+":"+clockTime.sec.format("%02d");
            mClockLabel.setText(mClockLabelText+clockTimeString);
            mClockLabel.setColor(Gfx.COLOR_LT_GRAY);
            
            // Steps
            var steps = mController.getSteps();
            mStepsLabel.setText(mStepsLabelText+(steps).toString());

            // HR            
            var heartRate = mController.getHR();
            mHRLabel.setText(mHRLabelText + heartRate.toString());
            dc.drawBitmap(dc.getWidth() / 2, dc.getHeight() / 2, heartImage);
            bitmapImage.draw(dc);

            mPromptLabel.setText("");
        } else {
            mPromptLabel.setText(mPrompt);
            mTimerLabel.setText("");
            mStepsLabel.setText("");
            mClockLabel.setText("");    
            mHRLabel.setText("");             
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        System.println("SquashView onHide");
        return true;
        //mTimer.stop();        
    }

    // Handler for the timer callback
    function onTimer() {
        //System.println("SquashView onTimer");
        Ui.requestUpdate();        
    }    

}
