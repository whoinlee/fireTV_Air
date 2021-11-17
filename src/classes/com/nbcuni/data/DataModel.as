package com.nbcuni.data {
	import com.nbcuni.Config;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	[Event(name="dataReady", type="flash.events.Event")]
	public class DataModel extends EventDispatcher
	{
		private static var instance				:DataModel;
//		private static var testCaseConstructed	:Boolean = false;
		
		public static const DATA_READY			:String = "dataReady";
		
		private var _dataLoader					:URLLoader;
		private var _isDataReady				:Boolean = false;
		public function get isDataReady():Boolean
		{
			return _isDataReady;
		}
		
		///////////////////////
		//-- constructor
		///////////////////////
		public function DataModel(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function getInstance():DataModel 
		{
			if (DataModel.instance == null) {
				DataModel.instance = new DataModel(new SingletonEnforcer());
			}
			return DataModel.instance;
		}
		
		
		///////////////////////
		//-- public methods
		///////////////////////
		public function getData(path:String):void
		{	
//			trace("INFO DataModel :: getData");	
			
			_dataLoader = new URLLoader();

			var urlReq:URLRequest = new URLRequest(path);
			_dataLoader.addEventListener(Event.COMPLETE, onDataLoaded);
			_dataLoader.load(urlReq);
		}
		
		public function setData(xml:XML):void
		{
//			trace("INFO DataModel :: setData");	
			
			//--appVars
			Config.hideCursor = (xml.appVars.hideCursor.toString().toLowerCase() == "true")? true:false;
			Config.fullScreen = (xml.appVars.fullScreen.toString().toLowerCase() == "true")? true:false;
			
			Config.globalNavPaneY = Number(xml.appVars.globalNavPaneY);
			Config.heroPaneY = Number(xml.appVars.heroPaneY);
			Config.shelvesPaneY = Number(xml.appVars.shelvesPaneY);
			
		}
		
		public function reset():void
		{
			trace("INFO DataModel :: reset");
//			_selectedAnswerArr = [];
		}
	


		

		///////////////////////
		//-- event handlers
		///////////////////////
		private function onDataLoaded(e:Event):void
		{
//			trace("INFO DataModel, onDataLoaded");
			
			_dataLoader.removeEventListener(Event.COMPLETE, onDataLoaded);
			
			var xml:XML = XML(_dataLoader.data);
			setData(xml);
			xml = null;
			_isDataReady = true;
			dispatchEvent(new Event(DATA_READY));
		}
	}//c
}//p

class SingletonEnforcer {}