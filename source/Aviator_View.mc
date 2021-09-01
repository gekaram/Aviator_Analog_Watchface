using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Timer;
using Toybox.Time.Gregorian;
using Toybox.Application.Properties;
//using Toybox.Sensor;

// buffered background screen offset;

// text align - center vertical and horizontal
const cAlign = Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER;
const cTransparent = Graphics.COLOR_TRANSPARENT;
/**
Watch view.
 */
class Aviator_View extends WatchUi.WatchFace {


    var f_hands = null;
	var current_hand = null;
	var hour = null;
    var minute = null;
    var second = null;
    var _isAwake = true;
    var WiFiState;
    var mSecondHandOn;
    var WiFiStatus;
    var mSecondHandColor = 0xffffff;
    var mBatteryWarningLevel = 20;
    var _partialUpdatesAllowed as Boolean;
    enum {
        PosSecond,
        PosMinute = 5,
        PosHour = 13,
        PosEOF2 = 21
    }
    
    var mBuffer;
    var mBackground;

    // prev clip
    var fx, fy, gx, gy;
    // clip
    var ax, ay, bx, by;
        // clip
    var r0, r1, r2;

    // buffer pos
    var bufx, bufy, bufw, bufh, center;
    var screenW = 240;
    var screenH = 240;
    var WiFiMessage;

    
	     //!LOAD COORDINATES FUNCTION
	    function initialize() {
	        WatchFace.initialize();
            _partialUpdatesAllowed = (WatchUi.WatchFace has :onPartialUpdate);

	    }


    	//!LOAD LAYOUT VIEW
    	// Load your resources here
	    function onLayout(dc) {       
		          	      	    
	       	 	bufw = loadResource(Rez.Strings.bufferw).toNumber();
	        	bufh = loadResource(Rez.Strings.bufferh).toNumber();  
		       	bufx = loadResource(Rez.Strings.bufferX).toNumber();
	        	bufy = loadResource(Rez.Strings.bufferY).toNumber();
	        	center = loadResource(Rez.Strings.center).toNumber();
	            screenW = dc.getWidth();
	            screenH = dc.getHeight();
	            ax = screenW;
	            ay = screenH;
	            bx = 0;
	            by = 0;
	            r0 = loadResource(Rez.Strings.r0).toNumber(); //back end of polygon
	            r1 = loadResource(Rez.Strings.r1).toNumber(); //middle tickness
	            r2 = loadResource(Rez.Strings.r2).toNumber(); //length from center
	        	mBuffer = new Graphics.BufferedBitmap({
	                :width=>bufw,
	                :height=>bufh
	        	});
             

	    }

  
	    
	    //!UPDATE CLIP FUNCTION
	    function updateClip(x, y) {
	        if (ax > x) {
	            ax = x;
	        }
	        if (bx < x) {
	            bx = x;
	        }
	        if (ay > y) {
	            ay = y;
	        }
	        if (by < y) {
	            by = y;
	        }
	    }
					   
		
		
		//!DRAW DIAL MARKS							   
		function drawDialMarkers(targetDc,this_x,this_y) {		      

 	      
	      // let's load the dial resources
	      f_hands = loadResource(Rez.Fonts.dial_marks_font_tiles);
	      current_hand = loadResource(Rez.JsonData.dial_marks_tiles_data);
	
	      // draw markers
	      targetDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
	      drawTiles(current_hand[0],f_hands,targetDc,this_x,this_y);
      
	  	}  						  
		
		
		
	  //!DRAW Move Markers					   
		function drawMoveMarkers(targetDc,this_x,this_y) {		      

          
          var mBarLevel = ActivityMonitor.getInfo().moveBarLevel;
	      
	      //mBarLevel = 1;
	      
	      if  (mBarLevel!=0) {
                    
          // let's load the dial resources
	      f_hands = loadResource(Rez.Fonts.move_tile_makers_font);
	      current_hand = loadResource(Rez.JsonData.move_tile_makers_data);
           
          // draw markers
	      targetDc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
           
		          if (mBarLevel>=1) {
		          drawTiles(current_hand[mBarLevel-1],f_hands,targetDc,this_x,this_y);
		          }
       		}
	      

      
	  	}  						  
				
			
				
		//!DRAW DIAL NUMBERS							   
		function drawDialNumbers(targetDc,this_x,this_y) {		      

	     
	      
	      // let's load the dial resources
	      f_hands = loadResource(Rez.Fonts.dial_numbers_font_tiles);
	      current_hand = loadResource(Rez.JsonData.dial_numbers_tiles_data);
	
	      // draw numbers
	      targetDc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
	      drawTiles(current_hand[0],f_hands,targetDc,this_x,this_y);
	  


      
	  	} 	
								  
		  //!DRAW MINUTE AND HOUR HAND FUNCTION			  
		 function drawTime(targetDc,this_x,this_y) {	
		  
		  // prepares to draw hour hand
		  // --------------------------
								      
			  var hour_is = (Math.floor((hour+(minute/60.0))*5.0)).toNumber()%60;
			  var hr_is = hour_is;
			
			// load the appropriate tilemaps as
		  	// hours are split across 12 tilemaps;
			  if (hour_is>=55 && hour_is<=59) {
			    f_hands = loadResource(Rez.Fonts.font_hour_55_59);
			    current_hand = loadResource(Rez.JsonData.font_hour_55_59_data);
			    hr_is = hour_is - 55;
			  }
			  if (hour_is>=50 && hour_is<=54) {
			    f_hands = loadResource(Rez.Fonts.font_hour_50_54);
			    current_hand = loadResource(Rez.JsonData.font_hour_50_54_data);
			    hr_is = hour_is - 50;
			  }
			  if (hour_is>=45 && hour_is<=49) {
			    f_hands = loadResource(Rez.Fonts.font_hour_45_49);
			    current_hand = loadResource(Rez.JsonData.font_hour_45_49_data);
			    hr_is = hour_is - 45;
			  }
			 if (hour_is>=40 && hour_is<=44) {
			    f_hands = loadResource(Rez.Fonts.font_hour_40_44);
			    current_hand = loadResource(Rez.JsonData.font_hour_40_44_data);
			    hr_is = hour_is - 40;
			  }
			  if (hour_is>=35 && hour_is<=39) {
			    f_hands = loadResource(Rez.Fonts.font_hour_35_39);
			    current_hand = loadResource(Rez.JsonData.font_hour_35_39_data);
			    hr_is = hour_is - 35;
			  }
			  if (hour_is>=30 && hour_is<=34) {
			    f_hands = loadResource(Rez.Fonts.font_hour_30_34);
			    current_hand = loadResource(Rez.JsonData.font_hour_30_34_data);
			    hr_is = hour_is - 30;
			  }
			  if (hour_is>=25 && hour_is<=29) {
			    f_hands = loadResource(Rez.Fonts.font_hour_25_29);
			    current_hand = loadResource(Rez.JsonData.font_hour_25_29_data);
			    hr_is = hour_is - 25;
			  }
			  if (hour_is>=20 && hour_is<=24) {
			    f_hands = loadResource(Rez.Fonts.font_hour_20_24);
			    current_hand = loadResource(Rez.JsonData.font_hour_20_24_data);
			    hr_is = hour_is - 20;
			  }
			  if (hour_is>=15 && hour_is<=19) {
			    f_hands = loadResource(Rez.Fonts.font_hour_15_19);
			    current_hand = WatchUi.loadResource(Rez.JsonData.font_hour_15_19_data);
			    hr_is = hour_is - 15;
			  }
			 if (hour_is>=10 && hour_is<=14) {
			    f_hands = loadResource(Rez.Fonts.font_hour_10_14);
			    current_hand = WatchUi.loadResource(Rez.JsonData.font_hour_10_14_data);
			    hr_is = hour_is - 10;
			  }
			  if (hour_is>=5 && hour_is<=9) {
			    f_hands = loadResource(Rez.Fonts.font_hour_5_9);
			    current_hand = loadResource(Rez.JsonData.font_hour_5_9_data);
			    hr_is = hour_is - 5;
			  }
			 if (hour_is>=0 && hour_is<=4) {
			    f_hands = loadResource(Rez.Fonts.font_hour_0_4);
			    current_hand = loadResource(Rez.JsonData.font_hour_0_4_data);
			    hr_is = hour_is;
			  }
				

		  // draw the actual hour hand tilemap
		  //---------------------------------
		  //shadow outline
		  targetDc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[hr_is],f_hands,targetDc,this_x,this_y);
		  //outline
		  targetDc.setColor(0x323232, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[hr_is+5],f_hands,targetDc,this_x,this_y);
		  //fill color
		  targetDc.setColor(0xffffff, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[hr_is+10],f_hands,targetDc,this_x,this_y);
		  
		  	  
		  
		  // prepares to draw minute hand
		  // --------------------------
		  var min = minute;
		
		  // load the appropriate tilemaps as
		  // minutes are split across six tilemaps;
		  if (minute>=50 && minute<=59) {
		    f_hands = loadResource(Rez.Fonts.font_min_50_59);
		    current_hand = loadResource(Rez.JsonData.font_min_50_59_data);
		    min = minute - 50;
		  }
		  if (minute>=40 && minute<=49) {
		    f_hands = loadResource(Rez.Fonts.font_min_40_49);
		    current_hand = loadResource(Rez.JsonData.font_min_40_49_data);
		    min = minute - 40;
		  }
		  if (minute>=30 && minute<=39) {
		    f_hands = loadResource(Rez.Fonts.font_min_30_39);
		    current_hand = loadResource(Rez.JsonData.font_min_30_39_data);
		    min = minute - 30;
		  }
		  if (minute>=20 && minute<=29) {
		    f_hands = loadResource(Rez.Fonts.font_min_20_29);
		    current_hand = loadResource(Rez.JsonData.font_min_20_29_data);
		    min = minute - 20;
		  }
		  if (minute>=10 && minute<=19) {
		    f_hands = loadResource(Rez.Fonts.font_min_10_19);
		    current_hand = loadResource(Rez.JsonData.font_min_10_19_data);
		    min = minute - 10;
		  }
		  if (minute>=0 && minute<=9) {
		    f_hands = loadResource(Rez.Fonts.font_min_0_9);
		    current_hand = loadResource(Rez.JsonData.font_min_0_9_data);
		    min = minute;
		  }
		
		  // draw the actual minute hand tilemap
		  //---------------------------------
		  //Shadow color
		  targetDc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[min],f_hands,targetDc,this_x,this_y);
		  //outline 0x323232 3289650 85
		  targetDc.setColor(0x323232, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[min+10],f_hands,targetDc,this_x,this_y);
		 //fill color
		  targetDc.setColor(0xffffff, Graphics.COLOR_TRANSPARENT);
		  drawTiles(current_hand[min+20],f_hands,targetDc,this_x,this_y);

		}    
    

  
		//!DRAW SECOND HAND FUNCTION
	    function drawSecondHand(dc, withBuffer) {
	        
	        if (mSecondHandOn) {
	        
	        var center2 = center;
	        
	        if(dc has :setAntiAlias) {
               dc.setAntiAlias(true);
               center2 = center + 1;
             } 
             	        
	        
	        fx = ax;
	        fy = ay;
	        gx = bx;
	        gy = by;
	        ax = screenW;
	        ay = screenH;
	        bx = 0;
	        by = 0;
	        
	        var pos;
	        pos = Gregorian.info(Time.now(), Time.FORMAT_SHORT).sec * 6;
	        
	        var angle = Math.toRadians(pos);
	          	      	 
		    var sa = Math.sin(angle);
		    var ca = Math.cos(angle);	           
	      
	      	//second hand coordinates
			var tail_x_center = (r0)*sa;  
			var tail_x_offset = 5*ca;
			var tail_y_center = (r0)*ca;  
			var tail_y_offset = 5*sa;
			   
			var middle_x_offset = r1*ca; 
			var middle_y_offset = r1*sa; 	  
			      	        
			var tip_x_center= (r2)*sa;  
			var tip_x_offset = 1*ca;
			var tip_y_center = (r2)*ca;  
			var tip_y_offset = 1*sa; 	        
	       	 
	       	 
	       	 var points =	[	
							[center2+tail_x_center-tail_x_offset,center2-tail_y_center-tail_y_offset],						
			                [center2-middle_x_offset,center2-middle_y_offset],
							[center2+tip_x_center-tip_x_offset,center2-tip_y_center-tip_y_offset],
					        [center2+tip_x_center+tip_x_offset,center2-tip_y_center+tip_y_offset],
					        [center2+middle_x_offset,center2+middle_y_offset],				
							[center2+tail_x_center+tail_x_offset,center2-tail_y_center+tail_y_offset],	  
							];	
						
              
               					
	        //Cicles thru all edges to find the extreme points for the buffer clip
	        //-----------------------------------------------------------------------
		    updateClip(points[0][0], points[0][1]);
		    updateClip(points[5][0], points[5][1]);
		    updateClip(points[2][0], points[2][1]);
		    updateClip(points[3][0], points[3][1]);
		    
        	             
	        //Creates Buffer Clip According to the Extreme Points found on updateClip of the Current Clip (ax,ay,bx,by) and Compares to the Last Clip (fx,fy,gx,gy)
	        //--------------------------------------------------------------------------------------------------------------------------------------------------
	        if (withBuffer) {
	            var mx = (fx < ax)? fx: ax;
	            var my = (fy < ay)? fy: ay;
	            var nx = (gx > bx)? gx: bx;
	            var ny = (gy > by)? gy: by;
	            dc.setClip(mx-1, my-1, Math.ceil(nx - mx + 3), Math.ceil(ny - my + 3));
	            dc.drawBitmap(bufx, bufy, mBuffer);
	        }
	       
    
	  		//Draw the Outline of the Second Hand
	  		dc.setPenWidth(2);
	  		 dc.setColor(Graphics.COLOR_BLACK, cTransparent);
 		     dc.drawLine(points[0][0], points[0][1], points[1][0], points[1][1]);
	         dc.drawLine(points[1][0], points[1][1], points[2][0], points[2][1]);
	  	    //dc.drawLine(points[2][0], points[2][1], points[3][0], points[3][1]);
	  	     dc.drawLine(points[3][0], points[3][1], points[4][0], points[4][1]);
	  	     dc.drawLine(points[4][0], points[4][1], points[5][0], points[5][1]);
             dc.drawLine(points[5][0], points[5][1], points[0][0], points[0][1]);
	  		  		
        
	        
	        //Draw Second Hand Main Polygon
	        dc.setColor(mSecondHandColor, cTransparent);
	        dc.fillPolygon(points);

       	        
	        // Draw second hand cap(s) and center circle;
	        dc.setColor(mSecondHandColor, Graphics.COLOR_BLACK);
           	dc.fillCircle(center, center, 5);
	        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
	        dc.fillCircle(center, center, 2);
	           
	   }
	   
	    }

    


	//!DRAW TILES FUNCTION-----------------
	function drawTiles(current_hand,font,dc,xoff,yoff) {
	
	  for(var i = 0; i < current_hand.size(); i++)
	  {
	    var packed_value = current_hand[i];
	
	    var char = (packed_value&0x00000FFF);
	    var xpos = (packed_value&0x003FF000)>>12;
	    var ypos = (packed_value&0xFFC00000)>>22;
	
	    dc.drawText(xoff+xpos,yoff+ypos,font,(char.toNumber()).toChar(),Graphics.TEXT_JUSTIFY_LEFT);
	  }
	}

   
   //!PARTIAL UPDATE VIEW-----------------
    function onPartialUpdate(dc) {
         drawSecondHand(dc, true); 
    }
    
    

     //!UPDATE VIEW-----------------
     function onUpdate(dc) {
	    

	    
	    
           	          	          
	       var ClockTime = System.getClockTime();
	       var bc = null;
	       hour = ClockTime.hour;
	       minute = ClockTime.min;  
	       var pos, angle;
	 	   mSecondHandOn = Properties.getValue("SecHandEnable");
	 	   if (Properties.getValue("SecondHandColor")!=null) {
            mSecondHandColor = Properties.getValue("SecondHandColor");
	        }

	       
	        
	      mBatteryWarningLevel = Properties.getValue("BatteryWarningLevel");
	      
     
	       
	       	// If we have an offscreen buffer that we are using to draw the background,
	       	// set the draw context of that buffer as our target.
	        if (null != mBuffer) {
	            dc.clearClip();
	            bc = mBuffer.getDc();
	            }  else
	            {
	            dc = bc;
	        }
	
	        //Clears Buffer
	        bc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
	        bc.clear();
	        
	        //draw dial objects to buffer    
            if (Properties.getValue("MoveBarOn")) {
            drawMoveMarkers(bc,-bufx,-bufy);
             			}
 			drawDialMarkers(bc,-bufx,-bufy);
            drawDialNumbers(bc,-bufx,-bufy);
	        
	       ///draw battery warning to buffer
	       if (System.getSystemStats().battery <= mBatteryWarningLevel) {
		            var battery_font = loadResource(Rez.Fonts.battery);
		            bc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		            bc.drawText(screenW/2-bufx, (screenH/2-bufy)/3, battery_font, "!", Graphics.TEXT_JUSTIFY_CENTER);
		                      }
		    
           //Draw Phone Connection Warning to buffer
		   if(Properties.getValue("ConnectionWarningOn")) {
		   if (Toybox.System.getDeviceSettings().phoneConnected ) { }        
           else {		   
		   var icon_set_01 = loadResource(Rez.Fonts.icon_set_01_font);
		   bc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
		   bc.drawText(screenW/4.1, screenH/1.9, icon_set_01, "k", Graphics.TEXT_JUSTIFY_CENTER);   
		   }      
           }

                                     
		    //draw date to buffer
	        var today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
	        var acumin_font = loadResource(Rez.Fonts.acumin_font);
	        var dateStr = today.day_of_week.toUpper() + " " + today.day.format("%.2d");
	        bc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
	       	bc.drawText(208*screenW/240, 89*screenW/240, acumin_font, dateStr, Graphics.TEXT_JUSTIFY_RIGHT);       
	                           
	        //draw time to buffer
	        drawTime(bc,-bufx,-bufy);	                  

      		   
            //draw markers directly to screen
            dc.setColor(0x000000, 0x000000);
            dc.clear();
            
            if (Properties.getValue("MoveBarOn")) {
            drawMoveMarkers(dc,0,0);
            }
	        drawDialMarkers(dc,0,0);
	        
	       	//draw everthing from buffer clipe (before second hand)
	       	dc.drawBitmap(bufx, bufy, mBuffer);
	       
		   

		   	   
	    if (_isAwake) {
	            // System.println("second hand");
	            // Draw second hand to device context;
	            // (only in active/background modes
	         drawSecondHand(dc, false);
	       } else if (_partialUpdatesAllowed)  { onPartialUpdate(dc); }
	  
	    }



    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        //System.println("onShow");

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        //System.println("onHide");
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        //System.println("onExitSleep");
        _isAwake = true;        
       // mState.reset(false);
        
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        //System.println("onEnterSleep");
        _isAwake = false;
       // mState.reset(true);
    }

    function timerCallback() {
        // System.println("RequestUpdate");
        WatchUi.requestUpdate();
    }

    //! Turn off partial updates
    function turnPartialUpdatesOff() as Void {
        _partialUpdatesAllowed = false;
    }



}

//! Receives watch face events
class Aviator_Delegate extends WatchUi.WatchFaceDelegate {
    var _view as Aviator_View;
    
    
    //! Constructor
    //! @param view The analog view
    function initialize(view as Aviator_View)  {
        WatchFaceDelegate.initialize();
        _view = view;
    }



   //! The onPowerBudgetExceeded callback is called by the system if the
    //! onPartialUpdate method exceeds the allowed power budget. If this occurs,
    //! the system will stop invoking onPartialUpdate each second, so we notify the
    //! view here to let the rendering methods know they should not be rendering a
    //! second hand.
    //! @param powerInfo Information about the power budget
    function onPowerBudgetExceeded(powerInfo) {
        System.println("Average execution time: " + powerInfo.executionTimeAverage);
        System.println("Allowed execution time: " + powerInfo.executionTimeLimit);
        _view.turnPartialUpdatesOff();
    }
}



