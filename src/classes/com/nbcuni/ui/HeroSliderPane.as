package com.nbcuni.ui {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	import flash.display.Sprite;
	import flash.events.Event;
//	import flash.utils.getDefinitionByName;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class HeroSliderPane extends Sprite {
		
		private static const SLIDE_W			:Number = 1688;
		private static const SLIDE_INIT_X		:Number = 116;

		private var _slideHolder				:Sprite;
		private var _slideArr					:Array;
		
		private var _currentSlide				:HeroSlide;
		private var _prevSlide					:HeroSlide;
		private var _nextSlide					:HeroSlide;
		private var _totalSlides				:uint = 3;	//temporary
		
		private var _prevX						:Number;
		private var _currentX					:Number;
		private var _nextX						:Number;
		
		private var _selectedIndex				:int = 0;
//		public function set selectedIndex(n:int):void
//		{
//			if (_selectedIndex != n) {
//				_selectedIndex = n;	
//			}
////			update();
//		}
//		public function get selectedIndex():int
//		{
//			return _selectedIndex;
//		}
		
		
		
		public function HeroSliderPane() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			configUI();
		}
		
		private function configUI() : void
		{
			_slideHolder = new Sprite();
			addChild(_slideHolder);
			
			//-- temporary TODO: do with config.xml
			_slideArr = new Array();
			for (var i:uint=0; i<_totalSlides; i++) {
				var slide:HeroSlide = new HeroSlide();
				slide.index = i;
				_slideHolder.addChild(slide);
				_slideArr.push(slide);
			}
			
			_currentX = SLIDE_INIT_X;
			_prevX = SLIDE_INIT_X - SLIDE_W;
			_nextX = SLIDE_INIT_X + SLIDE_W;
			
			reset();
		}
		
//		private function update():void
//		{
//			//TODO
//		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function reset():void
		{
			_slideHolder.x = 0;
			_selectedIndex = 0;
			
			_currentSlide = _slideArr[_selectedIndex];
			_nextSlide = _slideArr[_selectedIndex + 1];
			_prevSlide = _slideArr[_totalSlides - 1];
			//
			_currentSlide.x = _currentX;
			_nextSlide.x = _nextX;
			_prevSlide.x = _prevX;
			
			_currentSlide.selected = true;
			for (var i:uint=1; i<_totalSlides-1; i++) {
				var slide:HeroSlide = _slideArr[i];
				slide.x = SLIDE_INIT_X + SLIDE_W*i;
				slide.selected = false;
			}
		}
		
		public function toNext():void
		{
			//-- doRight
			_currentSlide.selected = false;
			_nextSlide.selected = true;
			
			_prevSlide = _currentSlide;
			_currentSlide = _nextSlide;
			_selectedIndex = _currentSlide.index;
			var nextIndex:int = _selectedIndex + 1;
			if (nextIndex >= _totalSlides) {
				nextIndex = 0;
			}
			_nextSlide = _slideArr[nextIndex];
			_nextSlide.x =  _currentSlide.x + SLIDE_W;
			
			//-- tween
			TweenLite.killTweensOf(_prevSlide);
			TweenLite.to(_prevSlide, 1, {delay:0, x:_prevX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_currentSlide);
			TweenLite.to(_currentSlide, 1, {delay:0, x:_currentX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_nextSlide);
			TweenLite.to(_nextSlide, 1, {delay:0, x:_nextX, ease:Quad.easeOut});
		}
		
		public function toPrev():void
		{
			//-- doLeft
			_currentSlide.selected = false;
			_prevSlide.selected = true;
			
			_nextSlide = _currentSlide;
			_currentSlide = _prevSlide;
			_selectedIndex = _currentSlide.index;
			var prevIndex:int = _selectedIndex - 1;
			if (prevIndex < 0) {
				prevIndex = _totalSlides - 1;
			}
			_prevSlide = _slideArr[prevIndex];
			_prevSlide.x = _currentSlide.x - SLIDE_W;
			
			//-- tween
			TweenLite.killTweensOf(_prevSlide);
			TweenLite.to(_prevSlide, 1, {delay:0, x:_prevX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_currentSlide);
			TweenLite.to(_currentSlide, 1, {delay:0, x:_currentX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_nextSlide);
			TweenLite.to(_nextSlide, 1, {delay:0, x:_nextX, ease:Quad.easeOut});
		}
		
		public function deselectCurrent():void
		{
			_currentSlide.deselect();
		}
		
		public function selectCurrent():void
		{
			_currentSlide.select();
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
//		private function onScroll(e:Event):void
//		{
////			trace("onScroll, _scrollBar.value is " + _scrollBar.value);
//		}
	}//c
}//p