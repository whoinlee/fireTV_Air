package com.base.events {
	import flash.events.Event;

	/**
	 * Media cue points events
	 */
	public class CuePointEvent extends Event {
		static public const ON_CUEPOINT:String = "onCuePoint";

		public function CuePointEvent(type:String, info:Object) {
			super(type);
			this.info = info;
		}

		public var info:Object;

		override public function clone():Event {
			return new CuePointEvent(type, info);
		}
	}
}