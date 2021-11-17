package com.nbcuni.ui {
	import com.nbcuni.assets.firetv.IndicatorAsset;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class Indicator extends MovieClip {

		private var _asset						:IndicatorAsset;
		
		private var _selected					:Boolean = false;
		public function set selected(b:Boolean):void
		{
			if (_selected != b) {
				_selected = b;	
				update();
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public var index						:uint = 0;
		
		
		
		public function Indicator() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			configUI();
		}
		
		private function configUI() : void
		{
			_asset = new IndicatorAsset();
			addChild(_asset);
		}
		
		private function update():void
		{
//			trace("INFO Indicator :: update, index is " + index);
			
			if (_selected) {
//				trace("INFO Indicator :: update, indicator " + index + " is selected");
				_asset.gotoAndStop(2);
			} else {
//				trace("INFO Indicator :: update, indicator " + index + " is un-selected");
				_asset.gotoAndStop(1);
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
	}//c
}//p