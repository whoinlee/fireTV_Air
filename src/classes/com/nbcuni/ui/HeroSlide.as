package com.nbcuni.ui {
	import com.nbcuni.assets.firetv.HeroSlideAsset;
	import flash.display.MovieClip;
	import flash.events.Event;
//	import flash.utils.getDefinitionByName;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class HeroSlide extends MovieClip {
		
		private var _asset						:HeroSlideAsset;
		
		private var _selected					:Boolean = false;
		public function set selected(b:Boolean):void
		{
			if (_selected != b) {
				_selected = b;
			}
			update();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private var _index						:uint = 0;
		public function set index(i:uint):void
		{
			if (_index != i) {
				_index = i;
				updateSeriesName();
			}
		}
		public function get index():uint
		{
			return _index;
		}
		
		
		
		public function HeroSlide(i:uint = 0) {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_index = i;
		}
		
		private function onAddedToStage(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			configUI();
		}
		
		private function configUI() : void
		{
			_asset = new HeroSlideAsset();
			addChild(_asset);
			
			update();
			updateSeriesName();
		}
		
		private function update():void
		{
			if (_selected) {
				_asset.outline.visible = true;
				_asset.bkg.gotoAndStop(1);
			} else {
				_asset.outline.visible = false;
				_asset.bkg.gotoAndStop(2);
			}
		}
		
		private function updateSeriesName():void
		{
			if (_asset)
			_asset.seriesNameField.text = "Item Name " + (_index + 1);
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function deselect():void
		{
			_asset.outline.visible = false;
			_selected = false;
			//bkg?
		}
		
		public function select():void
		{
			_asset.outline.visible = true;
			_selected = true;
			//bkg?
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
//		private function onScroll(e:Event):void
//		{
////			trace("onScroll, _scrollBar.value is " + _scrollBar.value);
//			
//
//		}
	}//c
}//p