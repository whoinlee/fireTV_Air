package com.base.ui {
	import com.base.utils.DrawingUtils;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	/**
	 * A Circular buffering wheel with a counter clockwise gradient from 1 to 0
	 */
	public class BufferingGradientWheel extends Sprite {
		
		public var radiusInner:Number;
		public var radiusOutter:Number;
		public var color:uint;
		
		private var _speed:Number;
		
		public function BufferingGradientWheel(radiusInner:Number, radiusOutter:Number, color:uint) {
			this.radiusInner = radiusInner;
			this.radiusOutter = radiusOutter;
			this.color = color;
			mouseChildren = false;
			mouseEnabled = false;
			update();
		}
		
		// redraw the wheel
		public function update():void {
			var piHalf:Number = Math.PI * .5;
			var m:Matrix = new Matrix();
			graphics.clear();
			// 0 x
			// 0 0
			m.createGradientBox(radiusOutter, radiusOutter, Math.PI * 1.25, 0, -radiusOutter);
			graphics.beginGradientFill(GradientType.LINEAR, [color, color], [1, .75], [25, 225], m);
			graphics.moveTo(0, -radiusOutter);
			DrawingUtils.arc(graphics, 0, 0, radiusOutter, piHalf * 3, piHalf * 4, true);
			graphics.lineTo(radiusInner, 0);
			DrawingUtils.arc2(graphics, 0, 0, radiusInner, piHalf * 3, piHalf * 4, true);
			graphics.lineTo(0, -radiusOutter);
			// x 0
			// 0 0
			m.createGradientBox(radiusOutter, radiusOutter, Math.PI * .75, -radiusOutter, -radiusOutter);
			graphics.beginGradientFill(GradientType.LINEAR, [color, color], [.75, .5], [25, 225], m);
			graphics.moveTo(-radiusOutter, 0);
			DrawingUtils.arc(graphics, 0, 0, radiusOutter, piHalf * 2, piHalf * 3, true);
			graphics.lineTo(0, -radiusInner);
			DrawingUtils.arc2(graphics, 0, 0, radiusInner, piHalf * 2, piHalf * 3, true);
			graphics.lineTo(-radiusOutter, 0);
			// 0 0
			// x 0
			m.createGradientBox(radiusOutter, radiusOutter, Math.PI * .25, -radiusOutter, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [color, color], [.5, .25], [25, 225], m);
			graphics.moveTo(0, radiusOutter);
			DrawingUtils.arc(graphics, 0, 0, radiusOutter, piHalf, piHalf * 2, true);
			graphics.lineTo(-radiusInner, 0);
			DrawingUtils.arc2(graphics, 0, 0, radiusInner, piHalf, piHalf * 2, true);
			graphics.lineTo(0, radiusOutter);
			// 0 0
			// 0 x
			m.createGradientBox(radiusOutter, radiusOutter, Math.PI * 1.75, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR, [color, color], [.25, 0], [25, 225], m);
			graphics.moveTo(radiusOutter, 0);
			DrawingUtils.arc(graphics, 0, 0, radiusOutter, 0, piHalf, true);
			graphics.lineTo(0, radiusInner);
			DrawingUtils.arc2(graphics, 0, 0, radiusInner, 0, piHalf, true);
			graphics.lineTo(radiusOutter, 0);
			
//			for (var i:int = 0; i < 4; i++) {
//				var radians:Number = i * piHalf;
//				var alpha:Number = (4 - i) * .25;
//				var section:Number = 3 - i;
//				var cos:Number = Math.cos(radians);
//				var sin:Number = Math.sin(radians);
//				
//				m.createGradientBox(radiusOutter, radiusOutter, Math.PI * 1.25, -sin * radiusOutter, -cos * radiusOutter);
//				graphics.beginGradientFill(GradientType.LINEAR, [color, color], [alpha, alpha - .25], [0, 0xff], m);
//				graphics.moveTo(-sin * radiusOutter, -cos * radiusOutter);
//				DrawingUtils.arc(graphics, 0, 0, radiusOutter, piHalf * section, piHalf * (section + 1), true);
//				graphics.lineTo(cos * radiusInner, -sin * radiusInner);
//				DrawingUtils.arc2(graphics, 0, 0, radiusInner, piHalf * section, piHalf * (section + 1), true);
//				graphics.lineTo(-sin * radiusOutter, -cos * radiusOutter);
//			}
		}
		
		public function play(speed:Number = 2):void {
			_speed = speed;
			addEventListener(Event.ENTER_FRAME, onFrame);
		}

		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(event : Event) : void {
			rotation += _speed;
		}
	}
}
