package com.base.ui {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class PlayPause extends Sprite {
		public static const PAUSE : uint = 0;
		public static const PLAY : uint = 1;
		
		private var _c : uint;
		private var _w : Number;
		private var _h : Number;
		private var _icon : Shape;
		private var _state : uint;

		/**
		 * Simple Play/Pause icons
		 * @param color
		 * @param w
		 * @param h
		 * @param defaultValue	PlayPause.PLAY/PlayPlause.PAUSE
		 */
		public function PlayPause(color : uint = 0xffffff, w : Number = 10, h : Number = 10, defaultValue:uint = PLAY) {
			_c = color;
			_w = w;
			_h = h;
			
			// hit area
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			addChild(_icon = new Shape());
			state = defaultValue;
		}
		
		private function drawPlay():void {
			var g:Graphics = _icon.graphics;
			g.clear();
			g.beginFill(_c);
			g.moveTo(0, 0);
			g.lineTo(_w, _h * .5);
			g.lineTo(0, _h);
		}
		
		private function drawPause():void {
			var g:Graphics = _icon.graphics;
			var t:uint = Math.round(_w / 4) || 1;
			g.clear();
			g.beginFill(_c);
			g.drawRect(0, 0, t, _h);
			g.endFill();
			g.beginFill(_c);
			g.drawRect(_w - t, 0, t, _h);
			g.endFill();
		}
		
		public function get state() : uint {
			return _state;
		}
		
		public function set state(val : uint) : void {
			_state = val == PAUSE ? PAUSE : PLAY;
			if (_state == PLAY) {
				drawPlay();
			} else {
				drawPause();
			}
		}
	}
}
