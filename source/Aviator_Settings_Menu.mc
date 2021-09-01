//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application.Storage;
using Toybox.Application.Properties;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.WatchUi;

//! This is the main view of the application.
//! This view only exists to push the sample menus.
class Aviator_Settings_Menu extends WatchUi.Menu2 {

    var menuView = null;

    //! Constructor
    public function initialize() {
        Menu2.initialize({:title=>"Settings"});
        Menu2.setTitle("Settings");
        var sublabel = "off"; 
        
        var drawable1 = new $.CustomIcon();
        Menu2.addItem(new WatchUi.IconMenuItem("Second Hand Color", drawable1.getString(), "SecondHandColor", drawable1, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));

        //var drawable2 = new $.CustomIcon2();
        //Menu2.addItem(new WatchUi.IconMenuItem("Hands Outline Color", drawable2.getString(), "HandsOutlineColor", drawable2, {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT}));
        
        var boolean = Properties.getValue("SecHandEnable") ? true : false;
        Menu2.addItem(new WatchUi.ToggleMenuItem("Second Hand", {:enabled=>"On", :disabled=>"Off"}, "SecHandEnable", boolean, null));
        
        boolean = Properties.getValue("MoveBarOn") ? true : false;
        Menu2.addItem(new WatchUi.ToggleMenuItem("Move Bar", {:enabled=>"On", :disabled=>"Off"}, "MoveBarOn", boolean, null));

        boolean = Properties.getValue("ConnectionWarningOn") ? true : false;
        Menu2.addItem(new WatchUi.ToggleMenuItem("Disconnected Warning", {:enabled=>"On", :disabled=>"Off"},"ConnectionWarningOn", boolean, null));

        //WatchUi.pushView(Menu2, new $.Aviator_Settings_Menu_Delegate(), WatchUi.SLIDE_IMMEDIATE);
        return true;
            }
}

 
//! Input handler for the app settings menu
class Aviator_Settings_Menu_Delegate extends WatchUi.Menu2InputDelegate {
            var colorCode; 
            var color;

    //! Constructor
    public function initialize() {
        Menu2InputDelegate.initialize();
        

    }
        
    public function onSelect(item as MenuItem) as Void {

        if (item instanceof WatchUi.IconMenuItem) {
			item.setSubLabel((item.getIcon() as CustomIcon).nextState());
			color =  item.getSubLabel();
			    
			
			if (item.getSubLabel().equals("White"))
			{ 
			
			//System.println("Changing to Whie");  
			colorCode = 16777215; 
			}

			if (item.getSubLabel().equals("Red"))
			{ 
			
			//System.println("Changing to Red");  
			colorCode = 16711680; 
			}
			
		    if (item.getSubLabel().equals("Gray"))
			{ 
			
			//System.println("Changing to Gray");  
			colorCode = 3289650; 
			}
			
	        if (item.getSubLabel().equals("Blue"))
			{ 
			
			//System.println("Changing to Blue");  
			colorCode = 85; 
			}
			                        
            Properties.setValue(item.getId() as String, colorCode);
            
            //System.println("id: " + item.getId() + ", value: " + colorCode); 
    
             }
    
    
        if (item instanceof WatchUi.ToggleMenuItem) {
			Properties.setValue(item.getId() as String, item.isEnabled());
			//System.println("id: " + item.getId() + ", value: " + item.isEnabled()); 
			}
       
        WatchUi.requestUpdate();
    }

  	function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		return false;
    }	




}





//! This is the custom Icon drawable. It fills the icon space with a color
//! to demonstrate its extents. It changes color each time the next state is
//! triggered, which is done when the item is selected in this application.
class CustomIcon extends WatchUi.Drawable {
    // This constant data stores the color state list.
    private const _colors = [0xffffff, 0xff0000] as Array<ColorValue>;
    private const _colorStrings = ["White", "Red"] as Array<String>;
    private var _index as Number;
    var flagindex;

    //! Constructor
    public function initialize() {
        Drawable.initialize({});

		if(Properties.getValue("SecondHandColor") == 16711680) 
		{ flagindex = 1;} else {flagindex = 0;} 
		
		_index = flagindex;

    }

    //! Advance to the next color state for the drawable
    //! @return The new color state
    public function nextState() as String {
        _index++;
        if (_index >= _colors.size()) {

		_index = 0;


        }

        return _colorStrings[_index];
    }

    //! Return the color string for the menu to use as its sublabel
    //! @return The current color
    public function getString() as String {
        return _colorStrings[_index];
    }
    
    public function getColorValue() as String {
        return _colors[_index];
    }

    //! Set the color for the current state and use dc.clear() to fill
    //! the drawable area with that color
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var color = _colors[_index];
        dc.setColor(color, color);
         dc.clear();
         dc.setPenWidth(1);
         dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
       
    }
}


class CustomIcon2 extends WatchUi.Drawable {
    // This constant data stores the color state list.
    private const _colors = [3289650, 85] as Array<ColorValue>;
    private const _colorStrings = ["Gray", "Blue"] as Array<String>;
    private var _index as Number;
    var flagindex;

    //! Constructor
    public function initialize() {
        Drawable.initialize({});

		if(Properties.getValue("HandsOutlineColor") == 85) 
		{ flagindex = 1;} else {flagindex = 0;} 
		
		_index = flagindex;

    }

    //! Advance to the next color state for the drawable
    //! @return The new color state
    public function nextState() as String {
        _index++;
        if (_index >= _colors.size()) {

		_index = 0;


        }

        return _colorStrings[_index];
    }

    //! Return the color string for the menu to use as its sublabel
    //! @return The current color
    public function getString() as String {
        return _colorStrings[_index];
    }
    
    public function getColorValue() as String {
        return _colors[_index];
    }

    //! Set the color for the current state and use dc.clear() to fill
    //! the drawable area with that color
    //! @param dc Device Context
    public function draw(dc as Dc) as Void {
        var color = _colors[_index];
        dc.setColor(color, color);
         dc.clear();
         dc.setPenWidth(1);
         dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
       
    }
}


