package com.nbcuni.manager {
	import com.nbcuni.data.DataModel;

	import flash.display.Sprite;
	import flash.events.*;

	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class Controller extends EventDispatcher
	{
		private static var instance				:Controller;
		
		//-- view name list
		public static const APP					:String = "Main";
		//
		public static const GLOBAL_NAV_PANE_VIEW:String = "GlobalNavPaneView";
		public static const HERO_PANE_VIEW		:String = "HeroPaneView";
		public static const SHELVES_PANE_VIEW	:String = "ShelvesPaneView";
		
		private var _app						:*; 			//-- reference to the application instance
		private var _views						:Object; 		//-- holds named list of view instances
		private var _dataModel					:DataModel;
		
		
		public function Controller(enforcer:SingletonEnforcer) 
		{
//			trace("INFO Controller :: dummy param enforcer is " + enforcer);
			
			_views = new Object();
			_dataModel = DataModel.getInstance();
		}
		
		public static function getInstance():Controller
		{
			if (instance == null) {
				instance = new Controller(new SingletonEnforcer());
			}
			return instance;	
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Methods
		////////////////////////////////////////////////////////////////////////////
		public function registerApp ( app:* ):void
		{
			_app = app;
		}
		
		public function registerView ( viewName:String, view:Sprite ):void
		{
			//trace ("INFO Controller :: registerView - viewName is " + viewName + ", view is " + view);
			_views [ viewName ] = view;
			switch (viewName) {
				case GLOBAL_NAV_PANE_VIEW:
//					view.addEventListener(GameEvent.START, onStartGameRequested);
					break;
				case HERO_PANE_VIEW:
					//
					break;
				case SHELVES_PANE_VIEW:
					view.addEventListener("goToPlayer", onGoToPlayerRequested);
					view.addEventListener("firstBloomShelfSelected", onFirstBloomShelfSelected);
					view.addEventListener("secondBloomShelfSelected", onSecondBloomShelfSelected);
					view.addEventListener("firstThumbShelfSelected", onFirstThumbShelfSelected);
					view.addEventListener("secondThumbShelfSelected", onSecondThumbShelfSelected);
					view.addEventListener("thirdThumbShelfSelected", onThirdThumbShelfSelected);
					view.addEventListener("firstThumbDetailShelfSelected", onFirstThumbDetailShelfSelected);
					view.addEventListener("secondThumbDetailShelfSelected", onSecondThumbDetailShelfSelected);
					view.addEventListener("thirdThumbDetailShelfSelected", onThirdThumbDetailShelfSelected);
					view.addEventListener("backToHeroPane", onBackToHeroPaneRequested);
					break;
			}
		}
	
		public function getView ( viewName:String ) : Object
		{
			return (_views [ viewName ]);
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function onGoToPlayerRequested(e:Event):void
		{
//			trace("INFO Controller :: onGoToPlayerRequested");
			_app.goToPlayer();
		}
		
		private function onFirstBloomShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onFirstShelfSelected");
			_app.showHeroPane;
		}
		
		private function onSecondBloomShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onSecondBloomShelfSelected");
			_app.hideHeroPane();
		}
		
		private function onFirstThumbShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onSecondBloomShelfSelected");
			_app.moveDownHeroPane();
		}
		
		private function onSecondThumbShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onSecondBloomShelfSelected");
			_app.moveUpHeroPane();
		}
		
		private function onThirdThumbShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onSecondBloomShelfSelected");
			_app.hideHeroPane();
		}
		
		private function onFirstThumbDetailShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onFirstThumbDetailShelfSelected");
			//_app.moveDownHeroPane();
		}
		
		private function onSecondThumbDetailShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onSecondThumbDetailShelfSelected");
			//_app.moveUpHeroPane();
		}
		
		private function onThirdThumbDetailShelfSelected(e:Event):void
		{
			trace("INFO Controller :: onThirdThumbDetailShelfSelected");
			//_app.hideHeroPane();
		}
		
		private function onBackToHeroPaneRequested(e:Event):void
		{
			trace("INFO Controller :: onBackToHeroPaneRequested");
			_app.backToHeroPane();
		}
		
	}//c
}//p

class SingletonEnforcer {}