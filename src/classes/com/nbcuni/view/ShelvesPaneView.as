package com.nbcuni.view {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.nbcuni.manager.Controller;
	import com.nbcuni.manager.StyleManager;
	import com.nbcuni.ui.ShelfSliderPane;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	[Event(name="firstBloomShelfSelected", type="flash.events.Event")]
	[Event(name="secondBloomShelfSelected", type="flash.events.Event")]
	[Event(name="firstThumbShelfSelected", type="flash.events.Event")]
	[Event(name="secondThumbShelfSelected", type="flash.events.Event")]
	[Event(name="thirdThumbShelfSelected", type="flash.events.Event")]
	[Event(name="firstThumbDetailShelfSelected", type="flash.events.Event")]
	[Event(name="secondThumbDetailShelfSelected", type="flash.events.Event")]
	[Event(name="thirdThumbDetailShelfSelected", type="flash.events.Event")]
	[Event(name="backToHeroPane", type="flash.events.Event")]
	public class ShelvesPaneView extends BaseView {
		
		private static const SHELF_INIT_Y		:Number = 0;
		private static const SHELF_OFFSET_Y		:Number = 222;	//distance between unselected shelves
//		private static const SHELF_OFFSET_Y		:Number = 232;	//distance between unselected shelves
		private static const BLOOM_OFFSET_Y		:Number = 482;	//distance between the selected shelf and the first unselected shelf
		
		private var _shelfHolder				:Sprite;
		private var _shelfHolderMask			:Shape;
		private var _shelfArr					:Array;
		private var _totalShelves				:uint = 4;		//TODO: temporary
		
		private var _selectedShelf				:ShelfSliderPane;
		private var _selectedIndex				:int = 0;		//selectedShelfIndex
		private var _selectedShelfY				:Number;		//the first thumbShelf y location
		
		private var _isFirstBloom				:Boolean = false;
			
//		private var _dataModel					:DataModel;
//		private var _soundController			:SoundController;


		
		public function ShelvesPaneView() {
			super();
			viewName = Controller.SHELVES_PANE_VIEW;
		}
		
		override protected function configUI():void
		{
			_controller.registerView(Controller.SHELVES_PANE_VIEW, this);
			
			_shelfHolder = new Sprite();
			addChild(_shelfHolder);
			
			build();
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Methods
		////////////////////////////////////////////////////////////////////////////
		override public function build():void
		{
			trace("\nINFO ShelvesPaneView :: build");
			
			_shelfArr = new Array();
			for (var i:uint=0; i<_totalShelves; i++) {
				var shelf:ShelfSliderPane = new ShelfSliderPane();
				shelf.index = i;
				shelf.y = SHELF_INIT_Y + SHELF_OFFSET_Y*i;
				_shelfHolder.addChild(shelf);
				_shelfArr.push(shelf);
				shelf.addEventListener("goToNextThumbShelf", onGoToNextThumbShelfRequested);
				shelf.addEventListener("goToNextThumbDetailShelf", onGoToNextThumbDetailShelfRequested);
				shelf.addEventListener("goToNextBloomShelf", onGoToNextBloomShelfRequested);
				shelf.addEventListener("goToPrevThumbShelf", onGoToPrevThumbShelfRequested);
				shelf.addEventListener("goToPrevThumbDetailShelf", onGoToPrevThumbDetailShelfRequested);
				shelf.addEventListener("goToPrevBloomShelf", onGoToPrevBloomShelfRequested);
			}
				
			//-- commented out on 08/07	
//			_shelfHolderMask = new Shape();
//			var bg:Graphics = _shelfHolderMask.graphics;
//			bg.beginFill(0xff00e7, 1);	//--->>1
//			bg.drawRect(-5, 0, Config.STAGE_W + 10, _shelfHolder.height + BLOOM_OFFSET_Y*2);
//			bg.endFill();
//			addChild(_shelfHolderMask);
//			_shelfHolderMask.y = -331;
//			_shelfHolder.mask = _shelfHolderMask;
			
			_selectedIndex = 0;
			_selectedShelf = _shelfArr[_selectedIndex];
			_selectedShelf.addEventListener("goToPlayer", onGoToPlayerRequested);
			_selectedShelfY = _selectedShelf.y;
		}
				
//		public function reset():void
//		{
//			//
//		}
		
		public function selectCurrent():void
		{
			_selectedShelf.selectCurrent();
		}
		
		public function thumbBloom():void
		{
			trace("\nINFO ShelvesPaneView :: thumbBloom");
			
			_selectedShelf.thumbBloom();
		}
		
		public function bloom():void
		{
			trace("\nINFO ShelvesPaneView :: bloom");
			
			_selectedShelf.bloom();
			
			//-- move the rest of the ShelfSliderPanes to their new positions
			var initY:Number = _selectedShelfY + BLOOM_OFFSET_Y;	//482: distance from the center of bloomed shelf to the next
			trace("_selectedShelfY:" + _selectedShelfY);
			
			var count:uint = 0;
			for (var i:uint=(_selectedIndex + 1); i<_totalShelves; i++) {
				var shelf:ShelfSliderPane = _shelfArr[i];
				var targetY:Number = initY + (SHELF_OFFSET_Y)*count;
				
//				trace("shelf.y of " + i + " shelf:" + count + ", is " + shelf.y);
				if (count <= 3) {
					//tween
					TweenLite.killTweensOf(shelf);
					TweenLite.to(shelf, .25,  {y:targetY, ease:Quad.easeOut} );
				} else {
					shelf.y = targetY;
				}
				count++;
			}
			
			//if (_isFirstBloom) 
		}
		
/*		public function backTo():void
		{
			_selectedShelf.backTo();
		}*/

		public function doRight():void
		{
			_selectedShelf.doRight();
		}
		
		public function doLeft():void
		{
			_selectedShelf.doLeft();
		}
		
		public function doDown():void
		{
			_selectedShelf.doDown();
		}
		
		public function doUp():void
		{
			_selectedShelf.doUp();
		}
		
		public function doSelect():void
		{
			_selectedShelf.doSelect();
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function onGoToPlayerRequested(e:Event):void
		{
//			trace("INFO ShelvesPaneView :: onGoToPlayerRequested");
			dispatchEvent(new Event("goToPlayer"));
		}
		
		private function onGoToNextThumbShelfRequested(e:Event):void
		{
			trace("INFO ShelvesPaneView :: onGoToNextThumbShelfRequested");

			if ((_selectedIndex+1) >= _totalShelves) return;
			
			_selectedIndex += 1;
//			trace("INFO ShelvesPaneView :: _selectedIndex, " + _selectedIndex);
			
			if (_selectedIndex == 1) {
				dispatchEvent(new Event("secondThumbShelfSelected"));
			} else if (_selectedIndex == 2) {
				dispatchEvent(new Event("thirdThumbShelfSelected"));
			}

			//-- reset previous selectedShelf
			_selectedShelf.backTo();
			//-- TODO: remove eventlister?
			
			//-- move up previous shelves of the selected shelf by SHELF_OFFSET_Y
			var count1:uint = 0;
			var prevThumbIndex:int = _selectedIndex - 1;
			while (prevThumbIndex >=0) {
				count1++;
				var shelfP:ShelfSliderPane = _shelfArr[prevThumbIndex];
				var shelfP_Y:Number = _selectedShelfY - SHELF_OFFSET_Y*count1;
				TweenLite.killTweensOf(shelfP);
				TweenLite.to(shelfP, StyleManager.BLOOM_DURATION, {y:shelfP_Y, ease:Quad.easeOut});
				prevThumbIndex--;
			}
			
			//-- set new selected shelf
			_selectedShelf = _shelfArr[_selectedIndex];
			
			//-- move up the newly selected shelf
			TweenLite.killTweensOf(_selectedShelf);
			TweenLite.to(_selectedShelf, StyleManager.BLOOM_DURATION, {y:_selectedShelfY, ease:Quad.easeOut});
			thumbBloom();
			
			//-- move the rest of shelves
			var count2:uint = 0;
			for (var j:uint=(_selectedIndex + 1); j<_totalShelves; j++) {
				count2++;
				var shelfN:ShelfSliderPane = _shelfArr[j];
				var shelfN_Y:Number = _selectedShelfY + SHELF_OFFSET_Y*count2;
				TweenLite.killTweensOf(shelfN);
				TweenLite.to(shelfN, StyleManager.BLOOM_DURATION, {y:shelfN_Y, ease:Quad.easeOut});
			}
		}
		
		private function onGoToNextThumbDetailShelfRequested(e:Event):void
		{
			
		}
		
		private function onGoToNextBloomShelfRequested(e:Event):void
		{
			trace("INFO ShelvesPaneView :: onGoToNextBloomShelfRequested");
			
//			_selectedIndex += 1;
//			trace("INFO ShelvesPaneView :: _selectedIndex, " + _selectedIndex);
//			if (_selectedIndex == (_totalShelves - 1)) return;
//			if (_selectedIndex == 1) {
////				trace("INFO ShelvesPaneView :: onGoToNextShelfRequested, dispatching secondShelfSelected");
//				dispatchEvent(new Event("secondBloomShelfSelected"));
//			}
//			
//			//-- previous selectedShelf moves up by 386
//			var targetY:Number = _selectedShelfY - (BLOOM_OFFSET_Y + 20);	//CHECK
//			TweenLite.killTweensOf(_selectedShelf);
//			TweenLite.to(_selectedShelf, .2, {y:targetY, ease:Quad.easeOut});
//			_selectedShelf.backTo();
//			_selectedShelf = _shelfArr[_selectedIndex];
//			_selectedShelf.addEventListener("goToPlayer", onGoToPlayerRequested);
//			
//			//-- move up the newly selected shelf
//			TweenLite.killTweensOf(_selectedShelf);
//			TweenLite.to(_selectedShelf, .2, {y:_selectedShelfY, ease:Quad.easeOut});
//			bloom();
			
		}
		
		private function onGoToPrevThumbShelfRequested(e:Event):void
		{
			trace("INFO ShelvesPaneView :: onGoToPrevThumbShelfRequested");

			if ((_selectedIndex-1) == -1) {
				dispatchEvent(new Event("backToHeroPane"));
				_selectedShelf.backTo();
				return;
			}
			
			_selectedIndex -= 1;
//			trace("INFO ShelvesPaneView :: _selectedIndex, " + _selectedIndex);
			
			if (_selectedIndex == 0) {
				dispatchEvent(new Event("firstThumbShelfSelected"));
			} else if (_selectedIndex == 1) {
				dispatchEvent(new Event("secondThumbShelfSelected"));
			}

			//-- reset previous selectedShelf
			_selectedShelf.backTo();
			//-- TODO: remove eventlister?
			
			//-- move down previous shelves of the selected shelf by SHELF_OFFSET_Y
			var count1:uint = 0;
			var prevThumbIndex:int = _selectedIndex - 1;
			while (prevThumbIndex >=0) {
				count1++;
				var shelfP:ShelfSliderPane = _shelfArr[prevThumbIndex];
				var shelfP_Y:Number = _selectedShelfY - SHELF_OFFSET_Y*count1;
				TweenLite.killTweensOf(shelfP);
				TweenLite.to(shelfP, StyleManager.BLOOM_DURATION, {y:shelfP_Y, ease:Quad.easeOut});
				prevThumbIndex--;
			}
			
			//-- set new selected shelf
			_selectedShelf = _shelfArr[_selectedIndex];
			
			//-- move up the newly selected shelf
			TweenLite.killTweensOf(_selectedShelf);
			TweenLite.to(_selectedShelf, StyleManager.BLOOM_DURATION, {y:_selectedShelfY, ease:Quad.easeOut});
			thumbBloom();
			
			//-- move the rest of shelves
			var count2:uint = 0;
			for (var j:uint=(_selectedIndex + 1); j<_totalShelves; j++) {
				count2++;
				var shelfN:ShelfSliderPane = _shelfArr[j];
				var shelfN_Y:Number = _selectedShelfY + SHELF_OFFSET_Y*count2;
				TweenLite.killTweensOf(shelfN);
				TweenLite.to(shelfN, StyleManager.BLOOM_DURATION, {y:shelfN_Y, ease:Quad.easeOut});
			}
		}
		
		private function onGoToPrevThumbDetailShelfRequested(e:Event):void
		{
			trace("INFO ShelvesPaneView :: onGoToPrevThumbDetailShelfRequested");
			if (_selectedIndex == 0) {
				dispatchEvent(new Event("firstThumbDetailShelfSelected"));
			}
		}
		
		private function onGoToPrevBloomShelfRequested(e:Event):void
		{
			trace("INFO ShelvesPaneView :: onGoToPrevBloomShelfRequested");
			if (_selectedIndex == 0) {
				dispatchEvent(new Event("firstBloomShelfSelected"));
			}
		}
	}//c
}//p