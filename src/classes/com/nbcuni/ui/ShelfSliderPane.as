package com.nbcuni.ui {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.nbcuni.assets.firetv.ShelfSliderPaneAsset;
	import com.nbcuni.manager.StyleManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	[Event(name="goToPlayer", type="flash.events.Event")]
	[Event(name="goToNextBloomShelf", type="flash.events.Event")]
	[Event(name="goToNextThumbShelf", type="flash.events.Event")]
	[Event(name="goToNextThumbDetailShelf", type="flash.events.Event")]
	[Event(name="goToPrevBloomShelf", type="flash.events.Event")]
	[Event(name="goToPrevThumbShelf", type="flash.events.Event")]
	[Event(name="goToPrevThumbDetailShelf", type="flash.events.Event")]
	public class ShelfSliderPane extends Sprite {
		
		private static const SLIDE_INIT_X		:Number = 272;
		private static const SLIDE_OFFSET_X		:Number = 272;	//272?
		private static const BLOOM_OFFSET_X		:Number = 951;	//1056/2 (half of currentBloom slide width) + 32 (gap between slides) + 782/2 (half of the current/nextBloom slide width)th
		
		private static const THUMB_SHELF		:String = "thumb";
		private static const THUMB_DETAIL_SHELF	:String = "thumbDetail";
		private static const BLOOMED_SHELF		:String = "bloomed";

		private var _asset						:ShelfSliderPaneAsset;
		private var _shelfTitle					:MovieClip;
		private var _shelfSlideHolder			:Sprite;
		
		private var _slideArr					:Array;
		private var _totalSlides				:uint = 12;				//TODO: temporary
		private var _title						:String = "CATEGORY 0";	//TODO: temporary
		
		private var _currentSlide				:ShelfSlide;
		private var _prevSlide					:ShelfSlide;
		private var _nextSlide					:ShelfSlide;
		
		private var _prevX						:Number;
		private var _currentX					:Number;
		private var _nextX						:Number;
		
		private var _prevPrevBloomX				:Number;
		private var _prevBloomX					:Number;
		private var _currentBloomX				:Number;
		private var _nextBloomX					:Number;
		private var _nextNextBloomX				:Number;
		
		private var _shelfTitleOrgY				:Number;
		
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

		private var _index						:uint = 0;
		public function set index(n:uint):void
		{
			if (_index != n) {
				_index = n;	
				updateTitle();
			}
		}
		public function get index():uint
		{
			return _index;
		}
		
		public var isTweening					:Boolean = false;
		public var isBloomedShelf				:Boolean = false;	//for the big detail bloomed shelf
		
		private var _shelfKind					:String = THUMB_SHELF;
		
		
		
		public function ShelfSliderPane(i:uint = 0) {
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
			_asset = new ShelfSliderPaneAsset();
			addChild(_asset);
			
			_shelfTitle = _asset.shelfTitle;
			_shelfSlideHolder = new Sprite();
			_shelfSlideHolder.x = -112;
			_shelfSlideHolder.y = 98;	//102, 100
			_asset.addChild(_shelfSlideHolder);
			
			_shelfTitleOrgY = _shelfTitle.y;
			
			//-- temporary TODO: do with config.xml
			_slideArr = new Array();
			for (var i:uint=0; i<_totalSlides; i++) {
				var slide:ShelfSlide = new ShelfSlide(i);
				slide.x = SLIDE_INIT_X + SLIDE_OFFSET_X * i;
				_shelfSlideHolder.addChild(slide);
				_slideArr.push(slide);
				slide.cacheAsBitmap = true;
			}
			//-- the last slide
			ShelfSlide(_slideArr[_totalSlides - 1]).x = SLIDE_INIT_X - SLIDE_OFFSET_X;
			
			_currentX = SLIDE_INIT_X;
			_prevX = SLIDE_INIT_X - SLIDE_OFFSET_X;
			_nextX = SLIDE_INIT_X + SLIDE_OFFSET_X;
			
			updateTitle();
			reset();
		}
		
		private function updateTitle():void
		{
			_title = "CATEGORY " + (_index + 1);
			if (_shelfTitle)
			_shelfTitle.titleField.text = _title;
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function reset():void
		{
			_shelfTitle.gotoAndStop(1);
			_shelfTitle.y = _shelfTitleOrgY;
			
			_selectedIndex = 0;
//			
			_currentSlide = _slideArr[_selectedIndex];
			_nextSlide = _slideArr[_selectedIndex + 1];
			_prevSlide = _slideArr[_totalSlides - 1];
			
			_currentSlide.selected = false;	//CHECK
			_prevSlide.selected = false;	//CHECK

			_currentSlide.x = _currentX;
			_nextSlide.x = _nextX;
			_prevSlide.x = _prevX;		
			
			for (var i:uint=1; i<_totalSlides-1; i++) {
				var slide:ShelfSlide = _slideArr[i];
				slide.asset.gotoAndStop(1);
				slide.x = SLIDE_INIT_X + SLIDE_OFFSET_X * i;
				slide.selected = false;
			}
		}
		
		public function selectCurrent():void
		{
			_currentSlide.select();
		}
		
		public function thumbBloom():void
		{
			trace("INFO ShelfSliderPane :: thumbBloom");
			
			_shelfKind = THUMB_SHELF;
						
//			isTweening = true;
//			_currentSlide.addEventListener("ready", onCurrentSlideReady);

			TweenLite.killTweensOf(_shelfTitle);
			TweenLite.to(_shelfTitle, StyleManager.BLOOM_DURATION, {y:-18, ease:Quint.easeOut});	//-12 ---> -14 ---> -16 ---> -18

			
//			_shelfTitle.gotoAndStop(2);
//			TweenLite.killTweensOf(_shelfTitle);
//			TweenLite.to(_shelfTitle, .25, {y:-234, ease:Quint.easeOut});
//			updateTitle();
//			
//			_currentBloomX = _currentX;
//			_prevBloomX = _currentX - (782 + 32);
//			_nextBloomX = _currentX + (1056 + 32);
//			 
//			_currentSlide.x = _currentBloomX;
//			TweenLite.killTweensOf(_prevSlide);
//			TweenLite.to(_prevSlide, .2, {x:_prevBloomX, ease:Quint.easeOut});
//			TweenLite.killTweensOf(_nextSlide);
//			TweenLite.to(_nextSlide, .2, {x:_nextBloomX, ease:Quint.easeOut});
//			
			_currentSlide.currentThumbBloom();	//TODO tmrw
//			_nextSlide.prevNextBloom();
//			_prevSlide.prevNextBloom();
//			
			var initX:Number = SLIDE_INIT_X + SLIDE_OFFSET_X + 67;	//45********
			var count:uint = 0;
			for (var i:uint=_selectedIndex + 1; i<_totalSlides-1; i++) {
				var slide:ShelfSlide = _slideArr[i];
				//slide.x = _nextBloomX + (782 + 32);	//TODO tmrw
				var slideTargetX:Number = initX + (SLIDE_OFFSET_X)*count;
				//slide.x = initX + (SLIDE_OFFSET_X)*count;
				TweenLite.killTweensOf(slide);
				TweenLite.to(slide, StyleManager.BLOOM_DURATION, {delay:.2, x:slideTargetX, ease:Quint.easeOut});
				count++;
			}
			
			//TODO
//			for (var i:uint=0; i<)
		}
		
		public function thumbDetailBloom():void
		{
			_shelfKind = THUMB_DETAIL_SHELF;
			
			//TODO
		}
		
		public function bloom():void
		{
//			trace("INFO ShelfSliderPane :: bloom");

			_shelfKind = BLOOMED_SHELF;

			isTweening = true;
			_currentSlide.addEventListener("ready", onCurrentSlideReady);
			
			_shelfTitle.gotoAndStop(2);
			TweenLite.killTweensOf(_shelfTitle);
			TweenLite.to(_shelfTitle, .25, {y:-234, ease:Quint.easeOut});
			updateTitle();
			
			_currentBloomX = _currentX;
			_prevBloomX = _currentX - (782 + 32);
			_nextBloomX = _currentX + (1056 + 32);
			 
			_currentSlide.x = _currentBloomX;
			TweenLite.killTweensOf(_prevSlide);
			TweenLite.to(_prevSlide, .2, {x:_prevBloomX, ease:Quint.easeOut});
			TweenLite.killTweensOf(_nextSlide);
			TweenLite.to(_nextSlide, .2, {x:_nextBloomX, ease:Quint.easeOut});
			
			_currentSlide.currentBloom();
			_nextSlide.prevNextBloom();
			_prevSlide.prevNextBloom();
			
			for (var i:uint=_selectedIndex + 2; i<_totalSlides-1; i++) {
				var slide:ShelfSlide = _slideArr[i];
				slide.x = _nextBloomX + (782 + 32);
			}
		}
		
		public function backTo():void
		{
			trace("INFO ShelfSliderPane :: backTo, _selectedIndex is " + _selectedIndex);
			//TODO: check the case that there's no previous and next slide
			
			_shelfTitle.y = _shelfTitleOrgY;
			
			_currentSlide.backTo();
			_nextSlide.backTo();
			_prevSlide.backTo();
			
			_nextSlide.x = _currentSlide.x + SLIDE_OFFSET_X;
			_prevSlide.x = _currentSlide.x - SLIDE_OFFSET_X;
			
			
			var nextIndex:int = _nextSlide.index + 1;
			if (nextIndex >= _totalSlides) nextIndex = 0;
			var lastIndex:int = _prevSlide.index - 1; 
			if (lastIndex<0) lastIndex = _totalSlides - 1;
			
			if (lastIndex>nextIndex) {
				var count1:uint = 0;
				for (var i:uint = nextIndex; i<=lastIndex; i++) {
					count1++;
					var slide1:ShelfSlide = _slideArr[i];
					slide1.backTo();
					slide1.x = _nextSlide.x + SLIDE_OFFSET_X*count1;
				}
			} else {
				var count2:uint = 0;
				for (var j:uint = nextIndex; j<_totalSlides; j++) {
					count2++;
					var slide2:ShelfSlide = _slideArr[j];
					slide2.backTo();
					slide2.x = _nextSlide.x + SLIDE_OFFSET_X*count2;
				}
				var initX:Number = slide2.x;
				var count3:uint = 0;
				for (var k:uint = 0; k<=lastIndex; k++) {
					count3++;
					var slide3:ShelfSlide = _slideArr[k];
					slide3.backTo();
					slide3.x = initX + SLIDE_OFFSET_X*count3;
				}
			}
		}

		public function doRight():void
		{
//			//-- doRight
			//-- move to the left
			if ((_currentSlide.isWatchNowActive || _currentSlide.isSubMenuActive) && !_currentSlide.isLastSubMenuActive) {
				_currentSlide.moveToTheSubMenu();
				return;
			}
			
			isTweening = true;
			_nextSlide.addEventListener("ready", onCurrentSlideReady);
			
			_currentSlide.bloomDown();
			_nextSlide.bloomUp();
			
			var prevPrevSlide:ShelfSlide = _prevSlide;
			_prevSlide = _currentSlide;
			_currentSlide = _nextSlide;
			_selectedIndex = _currentSlide.index;
			var nextIndex:int = _selectedIndex + 1;
			if (nextIndex >= _totalSlides) {
				nextIndex = 0;
			}
			_nextSlide = _slideArr[nextIndex];
			_nextSlide.setPrevNextBloom();
			_nextSlide.x =  _currentSlide.x + BLOOM_OFFSET_X;
			
			_currentBloomX = _currentX;
			_prevBloomX = _currentX - (782 + 32);
			_nextBloomX = _currentX + (1056 + 32);
			_prevPrevBloomX = _prevBloomX - (782 + 32);
			
			//-- change the depth of the currentSlide, to bring it to the front
			_shelfSlideHolder.setChildIndex(_currentSlide, _totalSlides-1);
			
			//-- tween
			TweenLite.killTweensOf(prevPrevSlide);
			TweenLite.to(prevPrevSlide, .5, {delay:0, x:_prevPrevBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_prevSlide);
			TweenLite.to(_prevSlide, .5, {delay:0, x:_prevBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_currentSlide);
			TweenLite.to(_currentSlide, .5, {delay:0, x:_currentBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_nextSlide);
			TweenLite.to(_nextSlide, .5, {delay:0, x:_nextBloomX, ease:Quad.easeOut});
		}
		
		public function doLeft():void
		{
			//-- doLeft
			//-- move to the right
			
			if (_currentSlide.isSubMenuActive) {
				_currentSlide.moveToThePrevMenu();
				return;
			}
			
			isTweening = true;
			_prevSlide.addEventListener("ready", onCurrentSlideReady);
			
			_currentSlide.bloomDown();
			_prevSlide.bloomUp();
			
			var nextNextSlide:ShelfSlide = _nextSlide;
			_nextSlide = _currentSlide;
			_currentSlide = _prevSlide;
			_selectedIndex = _currentSlide.index;
			var prevIndex:int = _selectedIndex - 1;
			if (prevIndex < 0) {
				prevIndex = _totalSlides - 1;
			}
			_prevSlide = _slideArr[prevIndex];
			_prevSlide.setPrevNextBloom();
			_prevSlide.x = _currentSlide.x - BLOOM_OFFSET_X;
			
			_currentBloomX = _currentX;
			_prevBloomX = _currentX - (782 + 32);
			_nextBloomX = _currentX + (1056 + 32);
			_nextNextBloomX = _nextBloomX + (782 + 32);
			
			//-- change the depth of the currentSlide, to bring it to the front
			_shelfSlideHolder.setChildIndex(_currentSlide, _totalSlides-1);
			
			//-- tween
			TweenLite.killTweensOf(_prevSlide);
			TweenLite.to(_prevSlide, .5, {delay:0, x:_prevBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_currentSlide);
			TweenLite.to(_currentSlide, .5, {delay:0, x:_currentBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(_nextSlide);
			TweenLite.to(_nextSlide, .5, {delay:0, x:_nextBloomX, ease:Quad.easeOut});
			//
			TweenLite.killTweensOf(nextNextSlide);
			TweenLite.to(nextNextSlide, .5, {delay:0, x:_nextNextBloomX, ease:Quad.easeOut});
		}
		
		public function doDown():void
		{
			trace("INFO ShelfSliderPane :: doDown");
			
			//-- previous version
			if (isBloomedShelf) {
//				if (isTweening || _currentSlide.isWatchNowActive) {
//					//move to the next shelf in shelf rows
//					//!!!!!!!!byTODAY
//					//-- bring up the next row
//					//-- reset the current shelfSlider and moves up
//					//TODO
//					dispatchEvent(new Event("goToNextBloomShelf"));
//				} else {
//					if (!_currentSlide.isSubMenuActive) {
//						_currentSlide.activateWatchNow();
//					} else {
//						//TODO: ???????
//					}
//				}
			} else {
				//dispatchEvent(new Event("goToNextThumbShelf"));
			}
			
			switch (_shelfKind) {
				case THUMB_SHELF:
					dispatchEvent(new Event("goToNextThumbShelf"));
					break;
				case THUMB_DETAIL_SHELF:
					dispatchEvent(new Event("goToNextThumbDetailShelf"));
					break;
				case BLOOMED_SHELF:
					dispatchEvent(new Event("goToNextBloomShelf"));
					break;
					
			}
		}
		
		public function doUp():void
		{
			//!!!!!!!!byTODAY
			//-- bring down the top pane 
			//-- bring down the either heroPane (when the current selected shelfslider is the first one), or bring down the previous slider
			
			switch (_shelfKind) {
				case THUMB_SHELF:
					dispatchEvent(new Event("goToPrevThumbShelf"));
					break;
				case THUMB_DETAIL_SHELF:
					dispatchEvent(new Event("goToPrevThumbDetailShelf"));
					break;
				case BLOOMED_SHELF:
					dispatchEvent(new Event("goToPrevBloomShelf"));
					break;
					
			}
		}
		
		public function doSelect():void
		{
			//if (_currentSlide.isWatchNowActive) {
				trace("ShelfSliderPane :: doSelect -- Yay, play the video!!!!!!!!!!!!!!!!");
				
				if (_currentSlide.canPlayVideo) {
					trace("canPlayVideo -- Yay, play the video!!!!!!!!!!!!!!!!");
					dispatchEvent(new Event("goToPlayer"));
				} else {
					//TODO: select deep dive button in the currentShelfSlide
				}
			//}
			//
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function onCurrentSlideReady(e:Event):void
		{
//			trace("onCurrentSlideReady, isTweening ");
			isTweening = false;
		}
	}//c
}//p