package com.nbcuni {

	public class Config  {

		public static const STAGE_W			:Number = 1920;
		public static const STAGE_H			:Number = 1080;
		public static const CONFIG_PATH		:String = "config/config.xml";
		
		public static var hideCursor 		:Boolean = true;
		public static var fullScreen 		:Boolean = true;
		
		public static var globalNavPaneY	:Number = 0;
		public static var heroPaneY			:Number = 128;
		public static var shelvesPaneY		:Number = 868;
		
		//-- TODO: from config?
		public static var globalNavPaneUpY	:Number = -80;		//-(72+8)
		public static var globalNavPaneMidUpY	:Number = -8;
		public static var heroPaneUpY		:Number = -521;
		public static var heroPaneMidUpY	:Number = -218;	//-212
		public static var shelvesPaneUpY	:Number = 482;
		public static var shelvesPaneMidUpY	:Number = 540;	//523
	}//c
}//p