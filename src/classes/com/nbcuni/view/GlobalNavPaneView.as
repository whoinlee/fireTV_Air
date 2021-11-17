package com.nbcuni.view {
	import com.nbcuni.assets.firetv.GlobalNavPaneAsset;
	import com.nbcuni.manager.Controller;
	import flash.display.MovieClip;
	
	
	/**
	 * @author WhoIN Lee : whoin.lee@nbcuni.com
	 */
	public class GlobalNavPaneView extends BaseView {
		
//		private var _dataModel					:DataModel;
//		private var _soundController			:SoundController;
		public static const SEARCH_MENU			:int = -2;
		public static const LOGO_MENU			:int = -1;
		public static const ALLSHOW_MENU		:int = 0;
		public static const MOVIES_MENU			:int = 1;
		public static const WATCHLIST_MENU		:int = 2;
		public static const SETTINGS_MENU		:int = 3;
		public static const INFO_MENU			:int = 4;
		public static const SIGNIN_MENU			:int = 5;
		
		private var _asset						:GlobalNavPaneAsset;
		private var _searchIcon					:MovieClip;
		private var _logoIcon					:MovieClip;
		
		private var _searchIconOrgY				:Number;
		private var _logoIconOrgY				:Number;
		private var _menuOrgY					:Number;
		
		private var _menuArr					:Array;
		private var _menu0						:MovieClip;	//ALL SHOWS
		private var _menu1						:MovieClip;	//MOVIES
		private var _menu2						:MovieClip;	//WATCHLIST
		private var _menu3						:MovieClip;	//SETTINGS
		private var _menu4						:MovieClip;	//INFO
		private var _menu5						:MovieClip;	//SIGN IN
			
		private var _selectedIndex				:int = -2;	//nothing selected, -1:logoIcon, 0~5:menu0~menu5
		private var _selectedMenu				:MovieClip;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(i:int):void
		{
			if (i != _selectedIndex) {
				_selectedIndex = i;
				update();
			}
		}
		
		
		
		public function GlobalNavPaneView() {
			super();
			viewName = Controller.GLOBAL_NAV_PANE_VIEW;
		}
		
		override protected function configUI():void
		{
			_controller.registerView(Controller.GLOBAL_NAV_PANE_VIEW, this);
	
			_asset = new GlobalNavPaneAsset();
			addChild(_asset);
			
			_searchIcon = _asset.searchIcon;
			_logoIcon = _asset.logoIcon;

			_menu0 = _asset.menu0;
			_menu1 = _asset.menu1;
			_menu2 = _asset.menu2;
			_menu3 = _asset.menu3;
			_menu4 = _asset.menu4;
			_menu5 = _asset.menu5;
			_menuArr = new Array();
			for (var i:uint = 0; i<6; i++) {
				_menuArr.push(this["_menu"+i]);
			}
			
			_searchIconOrgY = _searchIcon.y;
			_logoIconOrgY = _logoIcon.y;
			_menuOrgY = _menu0.y;
			
			_selectedMenu = _logoIcon;
		}
		
		private function update():void
		{
			if (_selectedIndex == -1) {
				_selectedMenu = _logoIcon;
//				_selectedMenu.gotoAndStop(2);
			} else if (_selectedIndex >= 0) {
				if (_selectedMenu) _selectedMenu.gotoAndStop(1);
				_selectedMenu = _menuArr[_selectedIndex];
//				_selectedMenu.gotoAndStop(2);
			}
			_selectedMenu.gotoAndStop(2);
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Methods
		////////////////////////////////////////////////////////////////////////////
		public function hideUnselectedNav(selectedNavIndex:int):void
		{
			if (selectedNavIndex != _selectedIndex) {
				_selectedIndex = selectedNavIndex;
				update();
			}
			
			for (var i:uint = 0; i<6; i++) {
				var menu:MovieClip = _menuArr[i];
				if (i != _selectedIndex) {
					menu.visible = false;
					//menu.gotoAndStop(1);
				} else {
					menu.visible = true;
					//menu.gotoAndStop(2);
				}
			}
			
			_searchIcon.y = _searchIconOrgY + 3;
			_logoIcon.y = _logoIconOrgY + 3;
            if (selectedNavIndex >= 0) _selectedMenu.y = _menuOrgY + 3;
		}
		
		public function showUnselectedNav(selectedNavIndex:int):void
		{
			if (selectedNavIndex != _selectedIndex) {
				_selectedIndex = selectedNavIndex;
				update();
			}
			
			for (var i:uint = 0; i<6; i++) {
				var menu:MovieClip = _menuArr[i];
				menu.visible = true;
			}
			
			_searchIcon.y = _searchIconOrgY;
			_logoIcon.y = _logoIconOrgY;
            if (selectedNavIndex >= 0) _selectedMenu.y = _menuOrgY;
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
//		private function onButtonPressed(e:MouseEvent):void
//		{
//			trace("INFO GlobalNavPaneView :: onButtonPressed");
//			
//			_soundController.playKeypad();
//			
//			var target:MovieClip = e.target as MovieClip;
//			TweenLite.killTweensOf(target);
//			TweenLite.to(target, .1, {colorTransform:{exposure:.85}}); 
//			
//			target.isDown = true;
//		}
	}//c
}//p