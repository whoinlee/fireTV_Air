package com.nbcuni.view {
	import com.nbcuni.data.DataModel;
	import com.nbcuni.manager.Controller;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author WhoIN Lee : whoin@hotmail.com
	 */
	public class BaseView extends Sprite {
		
		public var viewName:String = "";
		
		protected var _dataModel:DataModel;
		protected var _controller:Controller;
/*		protected var _styleManager:StyleManager;
		protected var _soundController:SoundController;*/
		
		
		public function BaseView() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_dataModel = DataModel.getInstance();
			_controller = Controller.getInstance();
/*			_styleManager = StyleManager.getInstance();
			_soundController = SoundController.getInstance();*/
		}
		
		private function onAddedToStage(e : Event) : void 
		{
//			trace("INFO BaseView :: onAddedToStage, viewName is " + viewName);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			configUI();
		}
		
		protected function configUI():void {}

		public function build():void {}
		
		public function destroy():void {}
		
		public function show():void {}
		
		public function hide():void {}
	}
}