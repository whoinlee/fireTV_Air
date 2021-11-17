package com.nbcuni.ui {
	import com.nbcuni.assets.KeyboardPaneAsset;
	import com.nbcuni.ui.ScrollBar;
	import com.nbcuni.data.DataModel;
	import com.nbcuni.manager.SoundController;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	/**
	 * @author WhoIN Lee : whoin@hotmail.com
	 */
	public class KeyboardPane extends Sprite {
		
		private static const UNDER_X			:Array = [475, 540, 605];
		
		private var _dataModel					:DataModel;
		private var _soundController			:SoundController;
		
		private var _asset						:KeyboardPaneAsset;
		
		private var _backBt						:MovieClip;
		private var _clearBt					:MovieClip;
		private var _doneBt						:MovieClip;
		
		private var _initialField1				:TextField;
		private var _initialField2				:TextField;
		private var _initialField3				:TextField;
		
		private var _underline					:MovieClip;
		
		private var _key0						:MovieClip;
		private var _key1						:MovieClip;
		private var _key2						:MovieClip;
		private var _key3						:MovieClip;
		private var _key4						:MovieClip;
		private var _key5						:MovieClip;
		private var _key6						:MovieClip;
		private var _key7						:MovieClip;
		private var _key8						:MovieClip;
		private var _key9						:MovieClip;
		private var _key10						:MovieClip;
		private var _key11						:MovieClip;
		private var _key12						:MovieClip;
		private var _key13						:MovieClip;
		private var _key14						:MovieClip;
		private var _key15						:MovieClip;
		private var _key16						:MovieClip;
		private var _key17						:MovieClip;
		private var _key18						:MovieClip;
		private var _key19						:MovieClip;
		private var _key20						:MovieClip;
		private var _key21						:MovieClip;
		private var _key22						:MovieClip;
		private var _key23						:MovieClip;
		private var _key24						:MovieClip;
		private var _key25						:MovieClip;
		
		private var _fieldID					:uint = 1;
		
		
		public function KeyboardPane() {
			addEventListener(Event.ADDED_TO_STAGE, configUI);
			_dataModel = DataModel.getInstance();
			_soundController = SoundController.getInstance();
		}
		
		private function configUI(e : Event) : void 
		{
			trace("INFO KeyboardPane: configUI");
			
			removeEventListener(Event.ADDED_TO_STAGE, configUI);

			_asset = new KeyboardPaneAsset();
			addChild(_asset);
			
			_backBt = _asset.backBt;
			_clearBt = _asset.clearBt;
			_doneBt = _asset.doneBt;
			
			_backBt.buttonMode = _backBt.mouseEnabled = true;
			_clearBt.buttonMode = _clearBt.mouseEnabled = true;
			_doneBt.buttonMode = _doneBt.mouseEnabled = true;
			_backBt.mouseChildren = _clearBt.mouseChildren = _doneBt.mouseChildren = false;
			
			_backBt.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPressed);
			_clearBt.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPressed);
			_doneBt.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPressed);
			
			_backBt.addEventListener(MouseEvent.MOUSE_OUT, onBackRequested);
			_clearBt.addEventListener(MouseEvent.MOUSE_OUT, onClearRequested);
			_doneBt.addEventListener(MouseEvent.MOUSE_OUT, onDone);
			
			_backBt.addEventListener(MouseEvent.MOUSE_UP, onBackRequested);
			_clearBt.addEventListener(MouseEvent.MOUSE_UP, onClearRequested);
			_doneBt.addEventListener(MouseEvent.MOUSE_UP, onDone);
			
			_initialField1 = _asset.initialField1;
			_initialField2 = _asset.initialField2;
			_initialField3 = _asset.initialField3;
			
			if (_dataModel.currentUser.acro != "") {
				_initialField1.text = _dataModel.currentUser.acro.substr(0,1).toUpperCase();
				_initialField2.text = _dataModel.currentUser.acro.substr(1,1).toUpperCase();
				_initialField3.text = _dataModel.currentUser.acro.substr(2,1).toUpperCase();
			}
			
			_underline = _asset.underline;
			
			for (var i=0; i<= 25; i++) {
				this["_key" + i] = _asset["key" + i];
				var thisKey:MovieClip = this["_key" + i];
//				trace("INFO KeyboardPane: configUI, thisKey is " + thisKey);
				thisKey.buttonMode = true;
				thisKey.mouseEnabled = true;
				thisKey.mouseChildren = false;
				thisKey.addEventListener(MouseEvent.MOUSE_DOWN, onButtonPressed);
				thisKey.addEventListener(MouseEvent.MOUSE_UP, onKeyPressed);
				thisKey.addEventListener(MouseEvent.MOUSE_OUT, onKeyPressed);
			}
//			trace("INFO KeyboardPane: configUI, after for");	
				
			_key0.char = "A";
			_key1.char = "B";
			_key2.char = "C";
			_key3.char = "D";
			_key4.char = "E";
			_key5.char = "F";
			_key6.char = "G";
			_key7.char = "H";
			_key8.char = "I";
			_key9.char = "J";
			_key10.char = "K";
			_key11.char = "L";
			_key12.char = "M";
			_key13.char = "N";
			_key14.char = "O";
			_key15.char = "P";
			_key16.char = "Q";
			_key17.char = "R";
			_key18.char = "S";
			_key19.char = "T";
			_key20.char = "U";
			_key21.char = "V";
			_key22.char = "W";
			_key23.char = "X";
			_key24.char = "Y";
			_key25.char = "Z";
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Event Handlers
		////////////////////////////////////////////////////////////////////////////
		private function onButtonPressed(e:MouseEvent):void
		{
//			trace("INFO KeyboardPane :: onButtonPressed");
			
			_soundController.playKeypad();
			
			var target:MovieClip = e.target as MovieClip;
			TweenLite.killTweensOf(target);
			TweenLite.to(target, .1, {colorTransform:{exposure:.85}}); 
			
			target.isDown = true;
		}

		private function onKeyPressed(e:MouseEvent):void
		{
//			trace("INFO KeyboardPane :: onKeyPressed, e.target.char is " + e.target.char);

			var target:MovieClip = e.target as MovieClip;
			if (target.isDown) {
				target.isDown = false;
				TweenLite.killTweensOf(target);
				TweenLite.to(target, .1, {colorTransform:{exposure:1}});
			
				var char:String = e.target.char;
				var currentField:TextField = this["_initialField" + _fieldID];
				
				if (_fieldID <= 3) {
					currentField.text = char;
					_underline.x = UNDER_X[_fieldID - 1];
				}
				
				_fieldID++;
				if (_fieldID <= 3) {
					var nextUnderlineX = UNDER_X[_fieldID - 1];
					TweenLite.to(_underline, .2, {x:nextUnderlineX, ease:Quad.easeOut});
				} else {
					_fieldID = 3;
				}
			}
		}
		
//		private function onKeyReleased(e:MouseEvent):void
//		{
////			trace("INFO KeyboardPane :: onKeyReleased, e.target.char is " + e.target.char);
//		}
		
		private function onBackRequested(e:MouseEvent):void
		{
			trace("INFO KeyboardPane :: onBackRequested");
			
			var target:MovieClip = e.target as MovieClip;
			if (target.isDown) {
				target.isDown = false;
				TweenLite.killTweensOf(target);
				TweenLite.to(target, .1, {colorTransform:{exposure:1}});
			
				_fieldID--;
				if (_fieldID >= 1) {
					var nextUnderlineX = UNDER_X[_fieldID - 1];
					TweenLite.to(_underline, .2, {x:nextUnderlineX, ease:Quad.easeOut});
				} else {
					_fieldID = 1;
				}
			}
		}
		
		private function onClearRequested(e:MouseEvent):void
		{
			trace("INFO KeyboardPane :: onClearRequested");
			
			var target:MovieClip = e.target as MovieClip;
			if (target.isDown) {
				target.isDown = false;
				TweenLite.killTweensOf(target);
				TweenLite.to(target, .1, {colorTransform:{exposure:1}});
			
				_initialField1.text = "";
				_initialField2.text = "";
				_initialField3.text = "";
				
				_underline.x = UNDER_X[0];
				
				_fieldID = 1;
			}
		}
		
		private function onDone(e:MouseEvent):void
		{
			trace("INFO KeyboardPane :: onDone");
			
			var target:MovieClip = e.target as MovieClip;
			if (target.isDown) {
				target.isDown = false;
				TweenLite.killTweensOf(target);
				TweenLite.to(target, .1, {colorTransform:{exposure:1}});
			
				var acro:String = _initialField1.text + _initialField2.text + _initialField3.text;
				_dataModel.currentUser.acro = acro;
				
				dispatchEvent(new Event("done"));
			}
		}
	}//c
}//p