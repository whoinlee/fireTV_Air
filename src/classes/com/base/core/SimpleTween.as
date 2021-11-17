package com.base.core {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * Very basic tweening class intented to be used with simpleapp animations
	 * This avoids locking the user to a particular tweening engine.
	 * For ease of use it shares a similar API as TweenLite but for file size,
	 * it does not implement all of its features
	 * 
	 * SimpleTween only supports the following:
	 * 		delay, ease, autoAlpha, onComplete and onCompleteParams
	 */
	public class SimpleTween {

		public static const FRAME : Sprite = new Sprite();
		private static var _tweenTargets : Dictionary = new Dictionary(true);

		public static function to(target : Object, time : Number, props : Object) : SimpleTween {
			return new SimpleTween(target, time, props); 
		}

		public static function killTweenOf(target : Object) : void {
			if (_tweenTargets[target]) {
				FRAME.removeEventListener(Event.ENTER_FRAME, _tweenTargets[target].onFrame);
				_tweenTargets[target] = null;
			}
		}

		public static function easeNone(t : Number, b : Number, c : Number, d : Number) : Number {
			return c * t / d + b;
		}

		public static function easeIn(t : Number, b : Number, c : Number, d : Number) : Number {
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
		}

		public static function easeOut(t : Number, b : Number, c : Number, d : Number) : Number {
			return (t == d) ? b + c : c * (-Math.pow(2, -10 * t / d) + 1) + b;
		}

		private var _target : Object;
		private var _time : Number;
		private var _props : Object;
		private var _propsFrom : Object;
		private var _startTime : uint;
		private var _onComplete : Function;
		private var _onCompleteParams : Array;
		private var _delay : Number;
		private var _ease : Function;
		private var _useAutoAlpha : Boolean;

		public function SimpleTween(target : Object, time : Number, props : Object) {
			killTweenOf(target);
			_target = target;
			_time = time;
			_props = props;
			_propsFrom = new Object();
			
			// init and remove reserved properties
			_delay = props.hasOwnProperty("delay") ? Number(_props.delay) : 0;
			delete _props.delay;
			_ease = props.hasOwnProperty("ease") ? _props.ease : SimpleTween.easeNone;
			delete _props.ease;
			_onComplete = props.hasOwnProperty("onComplete") ? _props.onComplete : null;
			delete _props.onComplete;
			_onCompleteParams = props.hasOwnProperty("onCompleteParams") ? _props.onCompleteParams : null;
			delete _props.onCompleteParams;
			if (props.hasOwnProperty("autoAlpha")) {
				_useAutoAlpha = true;
				_props.alpha = _props.autoAlpha;				_propsFrom.alpha = _props.autoAlpha;
				delete _props.autoAlpha;
			}
			
			
			// store initial values;
			for (var prop:String in _props) {
				_propsFrom[prop] = target[prop];					
			}
			
			_startTime = getTimer();
			_tweenTargets[_target] = this;
			FRAME.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private function onFrame(event : Event) : void {
			var time : Number = (getTimer() - _startTime) / 1000 - _delay;
			if (time > _time) {
				time = _time;
			}
			if (time >= 0) {
				var percent : Number = _ease(time, 0, 1, _time);
				for (var prop:String in _props) {
					_target[prop] = percent * (_props[prop] - _propsFrom[prop]) + _propsFrom[prop];
					if (_useAutoAlpha) {
						_target.visible = _target.alpha > 0;
					}			
				}
				if (time == _time) {
					killTweenOf(_target);
					if (_onComplete is Function) {
						_onComplete.apply(null, _onCompleteParams);
					}
				}
			}
		}
	}
}
