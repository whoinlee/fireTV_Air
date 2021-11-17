package com.nbcuni.view {
	import com.nbcuni.manager.Controller;
	import com.nbcuni.ui.HeroSliderPane;
	import com.nbcuni.ui.IndicatorPane;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class HeroPaneView extends BaseView {
		
//		private var _dataModel					:DataModel;
//		private var _soundController			:SoundController;
		
		private var _heroSliderPane				:HeroSliderPane;
		private var _indicatorPane				:IndicatorPane;
		
		private var _selectedIndex				:int = 0;
		public function set selected(n:uint):void
		{
			if (_selectedIndex != n) {
				_selectedIndex = n;	
			}
			update();
		}
		public function get selectedIndex():uint
		{
			return _selectedIndex;
		}
		
	
		
		public function HeroPaneView() {
			super();
			viewName = Controller.HERO_PANE_VIEW;
		}
		
		override protected function configUI():void
		{		
			_controller.registerView(Controller.HERO_PANE_VIEW, this);
			build();
		}
		
		override public function build():void
		{
			_heroSliderPane = new HeroSliderPane();
			_heroSliderPane.x = 0;
			_heroSliderPane.y = 0;
			addChild(_heroSliderPane);
			
			_indicatorPane = new IndicatorPane();
			//TODO: update based on config.xml data
			_indicatorPane.x = 910;
			_indicatorPane.y = 628;
			addChild(_indicatorPane);
			
			reset();
		}
		
		private function update():void
		{
			
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function reset():void
		{
			_heroSliderPane.reset();
			_indicatorPane.reset();
		}
		
		public function doRight():void
		{
			//-- doRight
			_heroSliderPane.toNext();
			_indicatorPane.toNext();
		}
		
		public function doLeft():void
		{
			//-- doLeft
			_heroSliderPane.toPrev();
			_indicatorPane.toPrev();
		}
		
		public function deselectCurrent():void
		{
			_heroSliderPane.deselectCurrent();
		}
		
		public function selectCurrent():void
		{
			_heroSliderPane.selectCurrent();
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
//		private function onButtonPressed(e:MouseEvent):void
//		{
////			trace("INFO HeroPaneView :: onButtonPressed");
//		}
		
//		private function onKeyReleased(e:MouseEvent):void
//		{
////			trace("INFO HeroPaneView :: onKeyReleased, e.target.char is " + e.target.char);
//		}
		
	}//c
}//p