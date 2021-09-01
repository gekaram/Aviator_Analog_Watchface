using Toybox.Application;


class Aviator_App extends Application.AppBase {

    var mView = null;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    /** Return the initial view of your application here
    function getInitialView() {
        mView = new Aviator_View();
        return [ mView ];
    }
    */
    
    
     //! Return the initial view for the app
    //! @return Array Pair [View, Delegate] or Array [View]
    function getInitialView() as Array<Views or InputDelegates>? {
        if (WatchUi has :WatchFaceDelegate) {
            var view = new $.Aviator_View();
            var delegate = new $.Aviator_Delegate(view);
            return [view, delegate] as Array<Views or InputDelegates>;
        } else {
            return [new $.Aviator_View()] as Array<Views>;
        }
    }
    
    

    function onSettingsChanged() {
         WatchUi.requestUpdate();
    }

    //! Return the settings view and delegate
    //! @return Array Pair [View, Delegate]
    public function getSettingsView() as Array<Views or InputDelegates>? {
     return [new $.Aviator_Settings_Menu(), new $.Aviator_Settings_Menu_Delegate()];
     
    }

}