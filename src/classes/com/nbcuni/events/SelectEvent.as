package com.nbcuni.events  {
	import flash.events.*;

	/**
	 * @author WhoIN Lee : whoin@hotmail.com
	 */
	public class SelectEvent extends Event
	{
		public static const SELECT	:String = "select";
		
		public var selectedIndex:uint;
		
		public function SelectEvent(type : String, pSelectedIndex:uint, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		    this.selectedIndex = pSelectedIndex;
		}

        public override function clone():Event {
            return new SelectEvent(type, selectedIndex);
        }
		
	}//class
}//package