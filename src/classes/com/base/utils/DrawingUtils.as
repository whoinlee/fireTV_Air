package com.base.utils {
	import flash.display.Graphics;

	public class DrawingUtils {

		/**
		 * draws an n-Sided polygon inscribed in a circle with the given radius and center
		 * @param	mc - target movie clip
		 * @param	n - number of sides
		 * @param	x - center x
		 * @param	y - center y
		 * @param	r - radius of circle in which polygon is inscribed
		 */

		public static function nPoly(g : Graphics, n : Number, x : Number, y : Number, r : Number) : void {
			var PI : Number = Math.PI;
			var theta : Number = 2 * PI / n;
			var p : Array = new Array();
			p[0] = {x:r, y:0};
			g.moveTo(r + x, y);
			for(var i : int = 1;i < n;i++) {
				p[i] = {x:r * Math.cos(theta * i), y:r * Math.sin(theta * i)};
				g.lineTo(p[i].x + x, p[i].y + y);
			}
			g.lineTo(p[0].x + x, p[0].y + y);
		}

		/**
		 * draws an n-Sided star inscribed in a circle with the given radius and center
		 * @param	mc - target movie clip
		 * @param	n - number of points
		 * @param	x - center x
		 * @param	y - center y
		 * @param	r - radius of circle in which star is inscribed
		 * @param	pSize - (optional number between 0 and 1) distance from the center at which each point begins as a percent of the radius (0.4 is the default)
		 */

		public static function nStar(g : Graphics, n : Number, x : Number, y : Number, r : Number, pSize : Number = .4) : void {
			var ratio : Number = pSize;
			var PI : Number = Math.PI;
			var theta : Number = 2 * PI / n;
			var p : Array = new Array();
			var t : Array = new Array();
			p[0] = {x:r * ratio, y:0};
			t[0] = {x:r * Math.cos(theta / 2), y:r * Math.sin(theta / 2)};
			g.moveTo(p[0].x + x, p[0].y + y);
			g.lineTo(t[0].x + x, t[0].y + y);
			for(var i : int = 1;i < n;i++) {
				p[i] = {x:r * ratio * Math.cos(theta * i), y:r * ratio * Math.sin(theta * i)};
				t[i] = {x:r * Math.cos(theta * i + theta / 2), y:r * Math.sin(theta * i + theta / 2)};
				g.lineTo(p[i].x + x, p[i].y + y);
				g.lineTo(t[i].x + x, t[i].y + y);
			}
			g.lineTo(p[0].x + x, p[0].y + y);
		}

		/**
		 * Draws an ARC, 0 degrees is at 3 o'clock
		 */
		public static function arc(g : Graphics, x : Number, y : Number, r : Number, s : Number, e : Number, nomove : Boolean = false) : void {
			var PI : Number = Math.PI;
			if(e < s) e += PI * 2;
			var steps : Number = Math.ceil((e - s) / (PI / 4));
			var theta : Number = (e - s) / steps;
			var rc : Number = r / Math.cos(theta / 2);
			var i : Number = 0;
			if(!nomove) {
				g.moveTo(x + Math.cos(s) * r, y + Math.sin(s) * r);
			}
			while(++i <= steps) {
				var angle : Number = s + theta * i;
				var cX : Number = x + rc * Math.cos(angle - theta / 2);
				var cY : Number = y + rc * Math.sin(angle - theta / 2);
				var aX : Number = x + r * Math.cos(angle);
				var aY : Number = y + r * Math.sin(angle);
				g.curveTo(cX, cY, aX, aY);
			}
		}
		/**
		 * Draws an ARC, 0 degrees is at 6 o'clock
		 */
		public static function arc2(g : Graphics, x : Number, y : Number, r : Number, s : Number, e : Number, nomove : Boolean = false) : void {
			var PI : Number = Math.PI;
			if(e < s) e += PI * 2;
			var steps : Number = Math.ceil((e - s) / (PI / 4));
			var theta : Number = (e - s) / steps;
			var rc : Number = r / Math.cos(theta / 2);
			var i : Number = 0;
			i = steps;
			if(!nomove) {
				g.moveTo(Math.cos(x + s + theta * i) * r, y + Math.sin(s + theta * i) * r);
			}
			while(--i >= 0) {
				var angle : Number = s + theta * i;
				var cX : Number = x + rc * Math.cos(angle + theta / 2);
				var cY : Number = y + rc * Math.sin(angle + theta / 2);
				var aX : Number = x + r * Math.cos(angle);
				var aY : Number = y + r * Math.sin(angle);
				g.curveTo(cX, cY, aX, aY);
			}
		}

		/**
		 * 
		 * @param	mc
		 * @param	startx
		 * @param	starty
		 * @param	endx
		 * @param	endy
		 * @param	len			length of dash
		 * @param	gap			length of gap
		 */
		public static function dashedLine(g : Graphics, startx : Number, starty : Number, endx : Number, endy : Number, len : Number, gap : Number) : void {
			var seglength : Number;
			var delta : Number;
			var deltax : Number;
			var deltay : Number;
			var segs : Number;
			var cx : Number;
			var cy : Number;
			var radians : Number;
			var cos : Number;
			var sin : Number;
			seglength = len + gap;
			deltax = endx - startx;
			deltay = endy - starty;
			delta = Math.sqrt((deltax * deltax) + (deltay * deltay));
			segs = Math.floor(Math.abs(delta / seglength));
			radians = Math.atan2(deltay, deltax);
			cos = Math.cos(radians);
			sin = Math.sin(radians);
			cx = startx;
			cy = starty;
			deltax = Math.cos(radians) * seglength;
			deltay = Math.sin(radians) * seglength;
			for (var n : int = 0;n < segs;n++) {
				g.moveTo(cx, cy);
				g.lineTo(cx + cos * len, cy + sin * len);
				cx += deltax;
				cy += deltay;
			}
			g.moveTo(cx, cy);
			delta = Math.sqrt((endx - cx) * (endx - cx) + (endy - cy) * (endy - cy));
			if(delta > len) {
				g.lineTo(cx + cos * len, cy + sin * len);
			} else if(delta > 0) {
				g.lineTo(cx + cos * delta, cy + sin * delta);
			}
			g.moveTo(endx, endy);
		};
	}
}
