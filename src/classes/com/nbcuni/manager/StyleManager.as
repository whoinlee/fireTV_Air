package com.nbcuni.manager {
	import com.base.utils.TextUtils;

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;

	/*******************************************************************************
	* @author: WhoIN Lee
	* whoin.lee@nbcuni.com
	*******************************************************************************/
	public class StyleManager extends EventDispatcher {
		
		//-- colors
		public static const RED						:Number = 0xff7f7f;
		public static const BLUE					:Number = 0x75abea;
		public static const LIGHT_GREY				:Number = 0xececec;
		public static const MED_GREY				:Number = 0xd8d8d8;
		public static const DARK_GREY				:Number = 0x464646;
		
		//-- transition timing
		public static const BLOOM_DURATION			:Number = .3;	//in seconds
		
		
		private static var instance					:StyleManager;
		
		public static const CSS_READY				:String = "cssReady";

		private static var _styleLoader				:URLLoader;
		
		private var __cssReady						:Boolean = false;
		public function get cssReady()				:Boolean	{ return (__cssReady); }
		
		private var __styleSheet					:StyleSheet;
		public function get styleSheet()			:StyleSheet	{ return (__styleSheet); }
		

		///////////////////////
		//-- constructor
		///////////////////////
		public function StyleManager(enforcer:SingletonEnforcer) 
		{
			trace("INFO StyleManager:: dummy " + enforcer);
			
			//initSuperscript
//			TextUtils.initSuperscript();
			TextUtils.traceFonts();
		}
		
		public static function getInstance():StyleManager
		{
			if (instance == null) {
				instance = new StyleManager(new SingletonEnforcer());
			}
			return instance;	
		}
		
		
		///////////////////////
		//-- public methods
		///////////////////////
		public function loadStyle(path:String):void
		{
			if (!__cssReady) {
//				trace("INFO StyleManager :: loadStyle, path is " + path);	
				__styleSheet = new StyleSheet();
				_styleLoader = new URLLoader();
				var req:URLRequest = new URLRequest(path);
				_styleLoader.load(req);
				_styleLoader.addEventListener(Event.COMPLETE, styleLoadedHandler);
			}
		}


		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function styleLoadedHandler(event:Event):void 
		{
//			trace("\nINFO StyleManager :: styleLoadedHandler, _styleLoader.data is \n" + _styleLoader.data);
			
        	__styleSheet.parseCSS(_styleLoader.data);
			__cssReady = true;	
           	dispatchEvent(new Event(CSS_READY)); 
        }	
	}//c
}//p

class SingletonEnforcer {}