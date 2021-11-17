package com.nbcuni.ui {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.nbcuni.assets.firetv.ShelfSlideAsset;
	import com.nbcuni.manager.StyleManager;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	[Event(name="ready", type="flash.events.Event")]
	public class ShelfSlide extends MovieClip {
		
		public var asset						:ShelfSlideAsset;	//TODO: temporarily set to public
		
		private var _content					:MovieClip;
		
		//-- intervalIDs
		private var _onIdleTimeOutID			:Number;
		
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
				updateHeadText();
			}
		}
		public function get index():uint
		{
			return _index;
		}
		
		private var _headText					:String = "00";
		private var _watchNowBt					:MovieClip;
		private var _selectedSubMenuIndex		:int = -1;
		private var _totalMenu					:uint = 3;	//TODO: temporary
		
		public var isWatchNowActive				:Boolean = false;
		public var canPlayVideo					:Boolean = true;
		public var isSubMenuActive				:Boolean = false;
		public var isLastSubMenuActive			:Boolean = false;
		public var isPlayed						:Boolean = false;
		
		
		
		public function ShelfSlide(i:uint = 0) 
		{
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
			asset = new ShelfSlideAsset();
			addChild(asset);
			
			_content = asset.content;
			
			update();
			updateHeadText();
		}
		
		private function update():void
		{
			//-- bloom
			//TODO
//			if (_selected) {
//				asset.outline.visible = true;
//				asset.bkg.gotoAndStop(1);
//			} else {
//				asset.outline.visible = false;
//				asset.bkg.gotoAndStop(2);
//			}
		}
		
		private function updateHeadText():void
		{
			if (_index > 98) {
				_headText = "";
			} else if (_index > 8) {
				_headText = "0";
			}
		}
		
		private function onCurrentBloomComplete():void
		{
			isWatchNowActive = false;
			canPlayVideo = true;
			isSubMenuActive = false;
			isLastSubMenuActive = false;
			_selectedSubMenuIndex = -1;
			
			//-- when a small thumbnail finishes blooming up to a currentBloom slide, or a current/NextBloom slide blooms up to a currentBloom slide
			asset.content.visible = false;	//at frame1 w. scaleX=scaleY=4.4, or at frame2 w. scaleX=scaleY=1.35
			
			//-- at frame3
			asset.gotoAndStop(3);
			asset.content.scaleX = 1;
			asset.content.scaleY = 1;
			asset.content.visible = true;
			
			//-- show the content
			asset.selectedContent.alpha = 0;
			asset.selectedContent.visible = true;
			asset.selectedContent.headline.y = 246;
			asset.selectedContent.headline.itemNameField.text = "Item Name " + _headText + (index+1);
			asset.selectedContent.watchNowBt.gotoAndStop(1);	//reset to inactive state

			TweenLite.killTweensOf(asset.selectedContent);
			TweenLite.to(asset.selectedContent, .25, {alpha:1, ease:Quad.easeOut, onComplete:setCurrentSlideToReady});
			
			
			asset.selectedContent.desc.alpha = 0;
			asset.selectedContent.menu0.gotoAndStop(1);
			asset.selectedContent.menu1.gotoAndStop(1);
			asset.selectedContent.menu2.gotoAndStop(1);
			asset.selectedContent.menu0.alpha = 0;
			asset.selectedContent.menu1.alpha = 0;
			asset.selectedContent.menu2.alpha = 0;
			_onIdleTimeOutID = setTimeout(showTheRest, 2500);	//3000 -> 2500
		}
		
		private function setCurrentSlideToReady():void
		{
			if (asset.currentFrame == 3) {
				dispatchEvent(new Event("ready"));
				_watchNowBt = asset.selectedContent.watchNowBt;
				isWatchNowActive = false;
			}
		}
		
		private function showTheRest():void
		{
			clearTimeout(_onIdleTimeOutID);
			
			//-- show the rest of the content of currentBloom slide
			if (asset.currentFrame == 3) {
				var desc:MovieClip = asset.selectedContent.desc;
				var menu0:MovieClip = asset.selectedContent.menu0;
				var menu1:MovieClip = asset.selectedContent.menu1;
				var menu2:MovieClip = asset.selectedContent.menu2;
				var headline:MovieClip = asset.selectedContent.headline;
				
				desc.alpha = 0;
				menu0.alpha = 0;
				menu1.alpha = 0;
				menu2.alpha = 0;
				menu0.gotoAndStop(1);
				menu1.gotoAndStop(1);
				menu2.gotoAndStop(1);
				
				TweenLite.killTweensOf(headline);
				TweenLite.killTweensOf(desc);
				TweenLite.killTweensOf(menu0);
				TweenLite.killTweensOf(menu1);
				TweenLite.killTweensOf(menu2);
				
				TweenLite.to(headline, .5, {y:118, ease:Quad.easeOut});
				TweenLite.to(desc, .75, {delay:.2, alpha:1, ease:Quad.easeOut});
				TweenLite.to(menu0, .5, {delay:.6, alpha:1, ease:Quad.easeOut});
				TweenLite.to(menu1, .5, {delay:.6, alpha:1, ease:Quad.easeOut});
				TweenLite.to(menu2, .5, {delay:.6, alpha:1, ease:Quad.easeOut});
			}
			
//			if (_watchNowBt.currentFrame == 1)
//			activateWatchNow();
		}
		
		private function onPrevNextBloomComplete():void
		{
			//-- when a small thumbnail finishes blooming up to a prevNextBloom slide
			asset.content.visible = false;	//at frame1 w. scaleX=scaleY=3.26    //or at frame3 w.scaleX=scaleY=0.74
			
			//-- at frame2
			asset.gotoAndStop(2);			//now, at frame2
			asset.content.scaleX = 1;
			asset.content.scaleY = 1;
			asset.content.visible = true;
			
			//-- shows item index in the current/nextBloom slide
//			asset.selectedContent.alpha = 0;
//			asset.selectedContent.itemNameField.text = "Item Name " + _headText + (index+1);
//			TweenLite.killTweensOf(asset.selectedContent);
//			TweenLite.to(asset.selectedContent, .1, {alpha:1, ease:Quad.easeOut});
		}

		private function hideCurrentBloomContent():void
		{
			//-- at frame3
			if (asset.currentFrame == 3) {
				asset.content.outline.visible = false;
				asset.selectedContent.visible = false;
				
				//-- reset asset.selectedContent
				asset.selectedContent.headline.y = 246;
				asset.selectedContent.desc.alpha = 0;
				asset.selectedContent.menu0.alpha = 0;
				asset.selectedContent.menu1.alpha = 0;
				asset.selectedContent.menu2.alpha = 0;
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Functions
		////////////////////////////////////////////////////////////////////////////
		public function select():void
		{
			//-- when down button is pressed from heroPane
//			TweenLite.killTweensOf(asset.content);
//			TweenLite.to(asset.content, .1, {tint: StyleManager.RED});
		}
		
		public function currentThumbBloom():void
		{
			//TODO tmrw
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, StyleManager.BLOOM_DURATION, {delay:.1, scaleX:1.28, scaleY:1.28, ease:Quint.easeOut, onComplete:onThumbBloomComplete});
		}
		
		private function onThumbBloomComplete():void
		{
			asset.gotoAndStop(4);
		}
		
		public function currentThumbDetailBloom():void
		{
			//TODO tmrw
		}
		
		///////////////////// -- when slides in the selected shelf bloom to currentBloom or prev/nextBloom, or set to prev/nextBloom
		
		public function backTo():void
		{
			//TODO

			asset.gotoAndStop(1);
			asset.content.scaleX = 1;
			asset.content.scaleY = 1;
			asset.content.alpha = 1;
			asset.content.visible = true;
			
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, 0, {tint: null});
		}
		
		public function currentBloom():void
		{
			isWatchNowActive = false;
			canPlayVideo = true;
			isSubMenuActive = false;
			isLastSubMenuActive = false;
			_selectedSubMenuIndex = -1;
			
			//-- when the selectedSlide (1st in top row) blooms up to a currentBloom
			asset.content.scaleX = 1;
			asset.content.scaleY = 1;
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, 0, {tint: StyleManager.DARK_GREY});
			TweenLite.to(asset.content, .25, {scaleX:4.4, scaleY:4.4, ease:Quint.easeOut, onComplete:onCurrentBloomComplete});
		}
		
		public function prevNextBloom():void
		{
			//-- when the next/prev of selectedSlide blooms up to a next/prevBloom
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, .25, {scaleX:3.26, scaleY:3.26, ease:Quint.easeOut, onComplete:onPrevNextBloomComplete});
		}
		
		public function setPrevNextBloom():void
		{
			//-- the rest of the slides in the selected row set to next/prevBloom condition slides w/o transition
			asset.content.scaleX = 3.26;
			asset.content.scaleY = 3.26;
			onPrevNextBloomComplete();
		}
		
		
		
		///////////////////// -- when slides in the bloomed shelf moves to left/right
		
		public function bloomUp():void
		{
			clearTimeout(_onIdleTimeOutID);
			isWatchNowActive = false;
			canPlayVideo = true;
			isSubMenuActive = false;
			isLastSubMenuActive = false;
			_selectedSubMenuIndex = -1;
			
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, .25, {tint: StyleManager.DARK_GREY});
			TweenLite.to(asset.content, .25, {scaleX:1.35, scaleY:1.35, ease:Quint.easeOut, onComplete:onCurrentBloomComplete});
		}
		
		public function bloomDown():void
		{
			clearTimeout(_onIdleTimeOutID);
			isWatchNowActive = false;
			
			hideCurrentBloomContent();
			TweenLite.killTweensOf(asset.content);
			TweenLite.to(asset.content, .25, {tint: StyleManager.MED_GREY});
			TweenLite.to(asset.content, .25, {scaleX:0.74, scaleY:0.74, ease:Quint.easeOut, onComplete:onPrevNextBloomComplete});
		}
		
		public function activateWatchNow():void
		{
			if (asset.currentFrame == 3) {
				_watchNowBt.gotoAndStop(2);
				isWatchNowActive = true;
				isSubMenuActive = false;
				asset.content.outline.visible = false;
				canPlayVideo = true;	//false when a deep dive button is active
				
//				showTheRest();
			}
		}
		
		public function deactivateWatchNow():void
		{
			if (asset.currentFrame == 3) {
				_watchNowBt.gotoAndStop(1);
				isWatchNowActive = false;
				canPlayVideo = false;	//false when a deep dive button is active
			}
		}
		
		public function moveToTheSubMenu():void
		{
			isSubMenuActive = true;
			if (_selectedSubMenuIndex < 0) {
				deactivateWatchNow();
			} else {
				asset.selectedContent["menu" + _selectedSubMenuIndex].gotoAndStop(1);
			}
			_selectedSubMenuIndex += 1;
			if (_selectedSubMenuIndex == (_totalMenu - 1)) isLastSubMenuActive = true;
			asset.selectedContent["menu" + _selectedSubMenuIndex].gotoAndStop(2);
		}
		
		public function moveToThePrevMenu():void
		{
			isLastSubMenuActive = false;
			asset.selectedContent["menu" + _selectedSubMenuIndex].gotoAndStop(1);
			_selectedSubMenuIndex -= 1;
			if (_selectedSubMenuIndex < 0) {
				isSubMenuActive = false;
				activateWatchNow();
			} else {
				isSubMenuActive = true;
				asset.selectedContent["menu" + _selectedSubMenuIndex].gotoAndStop(2);
			}
		}
				
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
	}//c
}//p