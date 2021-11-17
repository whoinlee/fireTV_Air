package com.base.events {
	import flash.events.Event;

	/**
	 * Video Events
	 */
	public class MediaEvent extends Event {
		public static const BUFFERING					:String = "buffering";
		public static const PLAYING						:String = "playing";
		public static const PAUSED						:String = "paused";
		public static const STOPPED						:String = "stopped";
		public static const SCRUBBING					:String = "scrubbing";
		public static const CLOSE						:String = "close";
		public static const CONNECTION_ERROR			:String = "connectionError";
		public static const PLAYHEAD_UPDATE				:String = "playheadUpdate";
		public static const PROGRESS					:String = "progress";
		public static const STATE_CHANGE				:String = "stateChange";
		public static const READY						:String = "ready";
		public static const SEEK_COMPLETE				:String = "seekComplete";
		public static const METADATA_RECEIVED			:String = "metadataReceived";
		public static const ON_STATUS					:String = "onStatus";
		public static const SEEK						:String = "seek";
		public static const SCRUB_FINISH				:String = "scrubFinish";
		public static const SCRUB_START					:String = "scrubStart";
		public static const COMPLETE					:String = "complete";
		public static const ON_CUEPOINT					:String = CuePointEvent.ON_CUEPOINT;
		
		public function MediaEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
