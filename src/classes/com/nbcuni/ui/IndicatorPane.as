package com.nbcuni.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class IndicatorPane extends Sprite {
		
		private var _indicatorArr				:Array;
		private var _totalIndicators			:uint = 3;	//TODO: temporary
		
		private var _selectedIndicator			:Indicator;
		private var _selectedIndex				:int = 0;
		public function set selectedIndex(n:int):void
		{
			if (_selectedIndex != n) {
				_selectedIndex = n;	
			}
			update();
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		
		
		public function IndicatorPane() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			configUI();
		}
		
		private function configUI() : void
		{
			//--temporary TODO: do with config.xml
			_totalIndicators = 3;
			_indicatorArr = new Array();
			var initX:Number = 0;
			var offsetX:Number= 40;
			for (var i:uint=0; i<_totalIndicators; i++) {
				var indicator:Indicator = new Indicator();
				indicator.x = initX + offsetX*i;
				indicator.index = i;
				addChild(indicator);
				_indicatorArr.push(indicator);
			}
			
			reset();
		}
		
		private function update():void
		{
			if (_selectedIndicator) {
				if (_selectedIndicator.index != _selectedIndex)
				_selectedIndicator.selected = false;
			} 
			
			_selectedIndicator = _indicatorArr[_selectedIndex];
			_selectedIndicator.selected = true;
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function reset():void
		{
			_selectedIndex = 0;
			_selectedIndicator = _indicatorArr[0];
			_selectedIndicator.selected = true;
			for (var i:uint=1; i<_totalIndicators; i++) {
				var indicator:Indicator = _indicatorArr[i];
				indicator.selected = false;;
			}
		}
		
		public function toNext():void
		{
//			trace("INFO IndicatorPane :: toNext");
			
			_selectedIndex += 1;
			if (_selectedIndex >= _totalIndicators) _selectedIndex = 0;
			update();
//			
//			trace("INFO IndicatorPane :: _selectedIndex is " + _selectedIndex);
		}
		
		public function toPrev():void
		{
//			trace("INFO IndicatorPane :: toPrev");
			
			_selectedIndex -= 1;
			if (_selectedIndex < 0) _selectedIndex = _totalIndicators - 1;
			update();
			
//			trace("INFO IndicatorPane :: _selectedIndex is " + _selectedIndex);
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
	}//c
}//p