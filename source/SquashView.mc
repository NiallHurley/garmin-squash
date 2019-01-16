using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

using Toybox.Sensor as Snsr;
using Toybox.Time as Time;
using Toybox.System as System;

//! These are four global variables used by the
//! SquashDelegate to determine if the user
//! touch a player score button. This implementation
//! is ugly, and it must be replaced by the button
//! if it's ever offered in the sdk of older devices
var heightButton = 0;
var widthButton = 0;


//! Class that represents the main Squash App
//! View
class SquashView extends Ui.View {

    hidden const VERTICAL_SPACING = 2;
    hidden const EXTRA_VERTICAL_SPACING = 10;
    hidden const HORIZONTAL_SPACING = 10;

    //! Value of current heart rate read from sensor
    hidden var heartRate;
    //! Object that contains the data that will
    //! be displayed on screen
    hidden var dataTracker;

    //! Vertical place in the screen where we start
    //! drawing. In round watches we should leave
    //! some initial vertical space.
    hidden var initialY;

    //! Constructor
    //! @param dataTracker Shared objtect that contains
    //! the data that will be displayed on screen
    function initialize(dataTracker) {
        View.initialize();
        self.dataTracker = dataTracker;
        heartRate = 0;

        Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        Snsr.enableSensorEvents( method(:onSnsr) );
    }

    //! Load resources
    function onLayout(dc) {
        initialY = EXTRA_VERTICAL_SPACING;
        if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND) {
            initialY += 30;
        }

        heightButton = dc.getFontHeight(Gfx.FONT_TINY) + dc.getFontHeight(Gfx.FONT_NUMBER_MILD) + VERTICAL_SPACING;
        widthButton = (dc.getWidth() / 2) - HORIZONTAL_SPACING;
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.setPenWidth(2);
        if (dataTracker.getSession().isRecording()) {
            dataTracker.update();
        }
        var time = dataTracker.getSession().getElapsedTime();
        var clockTime = System.getClockTime(); // ClockTime object

        var x = dc.getWidth() / 2 - HORIZONTAL_SPACING;
        var y = initialY;

        x = dc.getWidth() / 2 - HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_SMALL, Ui.loadResource(Rez.Strings.steps_label), Gfx.TEXT_JUSTIFY_RIGHT);
        x = dc.getWidth() / 2 + HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_TINY, Ui.loadResource(Rez.Strings.hr_label), Gfx.TEXT_JUSTIFY_LEFT);
        y = y + dc.getFontHeight(Gfx.FONT_TINY) + VERTICAL_SPACING;
        x = dc.getWidth() / 2 - HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_NUMBER_MILD, dataTracker.getNumberOfSteps(), Gfx.TEXT_JUSTIFY_RIGHT);
        x = dc.getWidth() / 2 + HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_NUMBER_MILD, heartRate, Gfx.TEXT_JUSTIFY_LEFT);

        y = y + dc.getFontHeight(Gfx.FONT_NUMBER_MILD) + (VERTICAL_SPACING / 2);
        dc.drawLine(0, y, dc.getWidth(), y);
        y = y + (VERTICAL_SPACING / 2);

        x = dc.getWidth() / 2 - HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_TINY, Ui.loadResource(Rez.Strings.time_label), Gfx.TEXT_JUSTIFY_RIGHT);

        x = dc.getWidth() / 2 + HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_TINY, Ui.loadResource(Rez.Strings.calories_label), Gfx.TEXT_JUSTIFY_LEFT);

        y = y + dc.getFontHeight(Gfx.FONT_TINY) + VERTICAL_SPACING;
        x = dc.getWidth() / 2 - HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_NUMBER_MILD, time, Gfx.TEXT_JUSTIFY_RIGHT);

        x = dc.getWidth() / 2 + HORIZONTAL_SPACING;
        dc.drawText(x, y, Gfx.FONT_NUMBER_MILD, dataTracker.getNumberOfCalories(), Gfx.TEXT_JUSTIFY_LEFT);

        y = y + dc.getFontHeight(Gfx.FONT_NUMBER_MILD) + (VERTICAL_SPACING / 2);
        //dc.drawLine(0, y, dc.getWidth(), y);
         y = y + (VERTICAL_SPACING / 2);

         // draw vertical line
        x = dc.getWidth() / 2;
        //dc.drawLine(x, VERTICAL_SPACING, x, y);
        dc.drawLine(x, VERTICAL_SPACING, x, (2*dc.getHeight()/3)+(VERTICAL_SPACING / 2)  );
        
         y = y + VERTICAL_SPACING;
        x = (dc.getWidth()/2) ;//HORIZONTAL_SPACING;
        dc.setColor(Gfx.COLOR_LT_GRAY,Gfx.COLOR_BLACK);
        dc.drawText(x, y, Gfx.FONT_SMALL, clockTime.hour.format("%02d") + ":" +
		    clockTime.min.format("%02d") + ":" +
		    clockTime.sec.format("%02d")
        , Gfx.TEXT_JUSTIFY_CENTER);
        
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! Function called to read heart rate sensor value
    function onSnsr(sensor_info)
    {
        if( sensor_info.heartRate != null )
        {
            heartRate = sensor_info.heartRate.toString();
        }
        else
        {
            heartRate = "---";
        }
        Ui.requestUpdate();
    }
}
