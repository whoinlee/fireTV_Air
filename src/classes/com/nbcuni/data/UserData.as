package com.nbcuni.data {

	/**
	 * @author WhoIN Lee: whoin@hotmail.com
	 */
	public class UserData  {
		
		public var ranking						:uint = 0;
		
		public var name							:String = "";
		public var acro							:String = "";
		public var score						:int = 0;
		
		public function UserData(pName:String = "")
		{
			name = pName;
			acro = "";
			score = 0;
		}
	}//c
}//p