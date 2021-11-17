package com.nbcuni {
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.nbcuni.assets.firetv.PlayerPausedScreen;
	import com.nbcuni.assets.firetv.RemoteController;
	import com.nbcuni.data.DataModel;
	import com.nbcuni.manager.Controller;
	import com.nbcuni.manager.StyleManager;
	import com.nbcuni.view.GlobalNavPaneView;
	import com.nbcuni.view.HeroPaneView;
	import com.nbcuni.view.ShelvesPaneView;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	[SWF(backgroundColor="#ffffff", frameRate="30", width="1920", height="1080")]
	public class Main extends Sprite {
		
		private static const HERO_VIEW:String = "heroView";
		private static const GLOBAL_NAV_VIEW:String = "globalNavView";
		private static const SHELVES_VIEW:String = "shelvesView";
		private static const SHELVES_THUMB_VIEW:String = "shelvesThumbView";
		private static const SHELVES_THUMB_DETAIL_VIEW:String = "shelvesThumbDetailView";
		private static const SHELVES_BLOOM_VIEW:String = "shelvesBloomView";
		private static const PLAYER_VIEW:String = "playerView";
		
		//-- views	
		private var _globalNavPaneView:GlobalNavPaneView;
		private var _heroPaneView:HeroPaneView;
		private var _shelvesPaneView:ShelvesPaneView;
		
		//-- remoteController
		private var _rController:RemoteController;
		private var _leftBt:SimpleButton;
		private var _upBt:SimpleButton;
		private var _rightBt:SimpleButton;
		private var _downBt:SimpleButton;
		private var _selectBt:SimpleButton;
		private var _backBt:SimpleButton;
		private var _homeBt:SimpleButton;
		private var _menuBt:SimpleButton;
		private var _rewindBt:SimpleButton;
		private var _playPauseBt:SimpleButton;
		private var _forwardBt:SimpleButton;
		
		//-- singletons
		private var _dataModel:DataModel;
		private var _controller:Controller;
//		private var _styleManager:StyleManager;
//		private var _soundController:SoundController;
		
		private var _currentViewName:String = HERO_VIEW;
		
		private var _player:MovieClip;	//temporary		
		
		
		
		public function Main() 
		{
//			TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);
			TweenPlugin.activate([TintPlugin]);
			
			_dataModel = DataModel.getInstance();
			_dataModel.getData(Config.CONFIG_PATH);
			//
			_controller = Controller.getInstance();
			_controller.registerApp(this);
			//
/*			_styleManager = StyleManager.getInstance();
			_styleManager.loadStyle(Config.STYLE_PATH);*/
			//
//			_soundController = SoundController.getInstance();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;	//CHECK!!!! : StageScaleMode.NO_SCALE;	
//			stage.scaleMode = StageScaleMode.EXACT_FIT;	//CHECK!!!! : StageScaleMode.NO_SCALE;	
			stage.showDefaultContextMenu = false;
			
			if (_dataModel.isDataReady) {
				init();
			} else {
				_dataModel.addEventListener(DataModel.DATA_READY, init);
			}
		}
		
		private function init(e:Event = null) : void 
		{
			if (Config.hideCursor) Mouse.hide();
			if (Config.fullScreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
			
			_shelvesPaneView = new ShelvesPaneView();
			addChild(_shelvesPaneView);
			_shelvesPaneView.y = Config.shelvesPaneY;
			
			_heroPaneView = new HeroPaneView();
			addChild(_heroPaneView);
			_heroPaneView.y = Config.heroPaneY;
			
			_globalNavPaneView = new GlobalNavPaneView();
			addChild(_globalNavPaneView);
			_globalNavPaneView.y = Config.globalNavPaneY;
			
			_rController = new RemoteController();
			_rController.x = 875;
			_rController.y = 145;
			addChild(_rController);
			_rController.visible = false;
			
			configRemoteController();
			configStageEvents();
		}
		
		private function configRemoteController():void
		{
			_leftBt = _rController.leftBt;
			_upBt = _rController.upBt;
			_rightBt = _rController.rightBt;
			_downBt = _rController.downBt;
			_selectBt = _rController.selectBt;
			_backBt = _rController.backBt;
			_homeBt = _rController.homeBt;
			_menuBt = _rController.menuBt;
			_rewindBt = _rController.rewindBt;
			_playPauseBt = _rController.playPauseBt;
			_forwardBt = _rController.forwardBt;
			
			_leftBt.addEventListener(MouseEvent.CLICK, doLeft);
			_upBt.addEventListener(MouseEvent.CLICK, doUp);
			_rightBt.addEventListener(MouseEvent.CLICK, doRight);
			_downBt.addEventListener(MouseEvent.CLICK, doDown);
			_selectBt.addEventListener(MouseEvent.CLICK, doSelect);
			_backBt.addEventListener(MouseEvent.CLICK, doBack);
			_homeBt.addEventListener(MouseEvent.CLICK, doHome);
			_menuBt.addEventListener(MouseEvent.CLICK, doMenu);
			_rewindBt.addEventListener(MouseEvent.CLICK, doRewind);
			_playPauseBt.addEventListener(MouseEvent.CLICK, doPlayPause);
			_forwardBt.addEventListener(MouseEvent.CLICK, doForward);
		}
		
		private function configStageEvents() : void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		
		private function toggleRemote():void
		{
			_rController.visible = !_rController.visible;
			if (_rController.visible) {
				Mouse.show();
			} else if (Config.hideCursor) {
				 Mouse.hide();
			}
		}	

		private function moveToGlobalNav():void
		{
			trace("INFO Main :: moveToGlobalNav");
			
			//-- commented out for now
//			_currentViewName = GLOBAL_NAV_VIEW;
		}
		
		private function moveToShelves():void
		{
			trace("INFO Main :: moveToShelves");
			
			_currentViewName = SHELVES_VIEW;
			
			//_shelvesPaneView.bloom();
			_shelvesPaneView.thumbBloom();	//08/07
			
			//-- test
//			_shelvesPaneView.alpha = .5;
			
			TweenLite.killTweensOf(_globalNavPaneView);
			TweenLite.to(_globalNavPaneView, StyleManager.BLOOM_DURATION, {y:Config.globalNavPaneUpY, ease:Quint.easeOut, onComplete:adjustGlobalNavPane});
			//
			TweenLite.killTweensOf(_heroPaneView);
//			TweenLite.to(_heroPaneView, .3, {y:Config.heroPaneUpY, alpha:.75, ease:Quint.easeOut});	//for testing
//			TweenLite.to(_heroPaneView, .25, {y:Config.heroPaneUpY, ease:Quint.easeOut});
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:Config.heroPaneMidUpY, ease:Quint.easeOut});
			//
			TweenLite.killTweensOf(_shelvesPaneView);
//			TweenLite.to(_shelvesPaneView, .3, {y:Config.shelvesPaneUpY, alpha:.25, ease:Quint.easeOut});	//for testing
			TweenLite.to(_shelvesPaneView, StyleManager.BLOOM_DURATION, {y:Config.shelvesPaneMidUpY, alpha:.75, ease:Quint.easeOut});	//for testing
		}
		
		public function moveToBloomShelves():void
		{
			//TODO: should listen to "firstBloom"
			trace("INFO Main :: moveToBloomShelves");
			
			_currentViewName = SHELVES_BLOOM_VIEW;
			
			_shelvesPaneView.bloom();
			
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:Config.heroPaneUpY, ease:Quint.easeOut});
			//
			TweenLite.killTweensOf(_shelvesPaneView);
			TweenLite.to(_shelvesPaneView, StyleManager.BLOOM_DURATION, {y:Config.shelvesPaneUpY, alpha:.75, ease:Quint.easeOut});	//for testing
		}
		
		private function adjustGlobalNavPane():void
		{
			_globalNavPaneView.hideUnselectedNav(GlobalNavPaneView.LOGO_MENU);
			
			TweenLite.killTweensOf(_globalNavPaneView);
			TweenLite.to(_globalNavPaneView, .25, {y:Config.globalNavPaneMidUpY, ease:Quad.easeOut});
		}

		
		////////////////////////////////////////////////////////////////////////////
		// Public Methods
		////////////////////////////////////////////////////////////////////////////
		public function doLeft(e:MouseEvent = null):void
		{
//			trace("INFO Main :: doLeft");
			switch (_currentViewName) {
				case HERO_VIEW:
					_heroPaneView.doLeft();
					break;
				case SHELVES_VIEW:
					_shelvesPaneView.doLeft();
					break;
				default:
					break;
			}
		}
		
		public function doRight(e:MouseEvent = null):void
		{
//			trace("INFO Main :: doRight");	
			switch (_currentViewName) {
				case HERO_VIEW:
					_heroPaneView.doRight();
					break;
				case SHELVES_VIEW:
					_shelvesPaneView.doRight();
					break;
				default:
					break;
			}
		}
		
		public function doUp(e:MouseEvent = null):void
		{
			trace("INFO Main :: doUp - _currentViewName is " + _currentViewName);	
			
			switch (_currentViewName) {
				case HERO_VIEW:
					moveToGlobalNav();
					break;
				case SHELVES_VIEW:
					_shelvesPaneView.doUp();
					break;
				default:
					break;
			}
		}
		
		public function doDown(e:MouseEvent = null):void
		{
//			trace("INFO Main :: doDown");	
			switch (_currentViewName) {
				case HERO_VIEW:
					_heroPaneView.deselectCurrent();
					_shelvesPaneView.selectCurrent();
					moveToShelves();
					//TweenLite.delayedCall(.2, moveToShelves);
					break;
				case SHELVES_VIEW:
					_shelvesPaneView.doDown();
					break;
//				case SHELVES_BLOOM_VIEW:
//					moveToBloomShelves();
//					_shelvesPaneView.doDown();
//					break;
				default:	
					break;
			}
		}
		
		public function doSelect(e:MouseEvent = null):void
		{
			trace("INFO Main :: doSelect");
			switch (_currentViewName) {
				case HERO_VIEW:
//					_heroPaneView.doSelect();
					break;
				case SHELVES_VIEW:
					_shelvesPaneView.doSelect();
					break;
				default:
					
					break;
			}
		}
		
		public function doBack(e:MouseEvent = null):void
		{
			trace("INFO Main :: doBack");
			switch (_currentViewName) {
//				case HERO_VIEW:
//					_heroPaneView.deselectCurrent();
//					_shelvesPaneView.selectCurrent();
//					TweenLite.delayedCall(.2, moveToShelves);
//					break;
//				case SHELVES_VIEW:
//					_shelvesPaneView.doDown();
//					break;
				case PLAYER_VIEW:
					_player.visible = false;
					_currentViewName = SHELVES_VIEW;
//					break;
				default:
					
					break;
			}
		}
		
		public function doHome(e:MouseEvent = null):void
		{
			trace("INFO Main :: doHome");
		}
		
		public function doMenu(e:MouseEvent = null):void
		{
			trace("INFO Main :: doMenu");
		}
		
		public function doRewind(e:MouseEvent = null):void
		{
			trace("INFO Main :: doRewind");
		}
		
		public function doPlayPause(e:MouseEvent = null):void
		{
			trace("INFO Main :: doPlayPause");
		}
		
		public function doForward(e:MouseEvent = null):void
		{
			trace("INFO Main :: doForward");
		}
		
		public function goToPlayer():void
		{
			trace("INFO Main :: goToPlayer");
			
			_currentViewName = PLAYER_VIEW;
			
			if (_player == null) {
				_player = new PlayerPausedScreen();
				addChild(_player);	//--------> done for now -----> TODO: integrate with a player section
			} else {
				_player.visible = true;
			}
		}
		
		public function showHeroPane():void
		{
			trace("INFO Main :: showHeroPane");
			
			//TODO: check y location
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:Config.heroPaneUpY, ease:Quint.easeOut});
		}
		
		public function hideHeroPane():void
		{
			trace("INFO Main :: hideHeroPane");
			
			var targetY:Number = Config.heroPaneUpY - 100;	//temporary
			
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:targetY, ease:Quint.easeOut});
		}
		
		public function moveUpHeroPane():void
		{
			trace("INFO Main :: moveUpHeroPane");
			
			var targetY:Number = Config.heroPaneUpY + 98;	//TODO: update heroPaneUpY
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:targetY, ease:Quint.easeOut});
		}
		
		public function moveDownHeroPane():void
		{
			trace("INFO Main :: moveDownHeroPane");
			
			var targetY:Number = Config.heroPaneMidUpY;
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:targetY, ease:Quint.easeOut});
		}
		
		public function backToHeroPane():void
		{
			trace("INFO Main :: backToHeroPane");
			
			_currentViewName = HERO_VIEW;
			
			_heroPaneView.selectCurrent();
			_globalNavPaneView.showUnselectedNav(GlobalNavPaneView.LOGO_MENU);
			
			TweenLite.killTweensOf(_globalNavPaneView);
			TweenLite.to(_globalNavPaneView, StyleManager.BLOOM_DURATION, {y:Config.globalNavPaneY, ease:Quint.easeOut});
			
			TweenLite.killTweensOf(_heroPaneView);
			TweenLite.to(_heroPaneView, StyleManager.BLOOM_DURATION, {y:Config.heroPaneY, ease:Quint.easeOut});
			
			TweenLite.killTweensOf(_shelvesPaneView);
			TweenLite.to(_shelvesPaneView, StyleManager.BLOOM_DURATION, {y:Config.shelvesPaneY, ease:Quint.easeOut});
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function onKeyboardDown(e:KeyboardEvent):void
		{
//			trace("INFO Main :: onKeyboardDown - e.charCode is " + e.charCode);
//			trace("INFO Main :: onKeyboardDown - e.keyCode is " + e.keyCode);
//			trace("INFO Main :: onKeyboardDown - e.shiftKey is " + e.shiftKey);
			
			switch (e.keyCode) {
				case 37:
					//"left"
					doLeft();
					break;
				case 38:
					//"up"
					doUp();
					break;
				case 39:
					//"right"
					doRight();
					break;
				case 40:
					//"down"
					doDown();
					break;
				case 32:
				case 16:
				case 13:
					doSelect();
					//"space", "shift", "return"
					break;
				case 66:
					//"B", "back"
					doBack();
					break;
				case 72:
					//"H", "home"
					doHome();
					break;
				case 77:
					//"M", "menu"
					doMenu();
					break;
				case 82:
					//"R", "rewind"
					doRewind();
					break;
				case 80:
					//"P", "playPause"
					doPlayPause();
					break;
				case 70:
					//"F", "forward"
					doForward();
					break;
				case 83:
					"s";
					if (e.shiftKey || e.controlKey || e.commandKey) toggleRemote();
					break;
				default:
					break;
			}
		}
	}//c
}//p