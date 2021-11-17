package com.nbcuni.manager {
	import com.reintroducing.sound.SoundManager;

	import flash.utils.getDefinitionByName;

	/**
	 * @author WhoIN Lee : whoin@hotmail.com
	 */
	public class SoundController
	{
		private static var instance				:SoundController;
		
		private var _sm							:SoundManager;
			
		
		public function SoundController(enforcer:SingletonEnforcer) 
		{
			trace("INFO SoundController :: dummy param enforcer is " + enforcer);
//			var dummySoundClassArr:Array = [ClickSound, CorrectSound, InCorrectSound, GameEndSound, KeypadSound];
//			dummySoundClassArr = null;
		}
		
		public static function getInstance():SoundController
		{
			if (instance == null) {
				instance = new SoundController(new SingletonEnforcer());
				instance.init();
			}
			return instance;	
		}

		private function init():void
		{
//			trace ("INFO SoundController :: init");
			
			_sm = SoundManager.getInstance();
			
			var clickSoundClassName:String = "com.nbcuni.assets.ClickSound";
			var clickSoundClassRef:Class = getDefinitionByName(clickSoundClassName) as Class;
			_sm.addLibrarySound(clickSoundClassRef, "CLICK");
			
			var correctSoundClassName:String = "com.nbcuni.assets.CorrectSound";
			var correctSoundClassRef:Class = getDefinitionByName(correctSoundClassName) as Class;
			_sm.addLibrarySound(correctSoundClassRef, "CORRECT");
			
			var inCorrectSoundClassName:String = "com.nbcuni.assets.InCorrectSound";
			var inCorrectSoundClassRef:Class = getDefinitionByName(inCorrectSoundClassName) as Class;
			_sm.addLibrarySound(inCorrectSoundClassRef, "INCORRECT");
			
			var gameEndSoundClassName:String = "com.nbcuni.assets.GameEndSound";
			var gameEndSoundClassRef:Class = getDefinitionByName(gameEndSoundClassName) as Class;
			_sm.addLibrarySound(gameEndSoundClassRef, "END");
			
			var keypadSoundClassName:String = "com.nbcuni.assets.KeypadSound";
			var keypadSoundClassRef:Class = getDefinitionByName(keypadSoundClassName) as Class;
			_sm.addLibrarySound(keypadSoundClassRef, "KEYPAD");
		}
		
		
		////////////////////////////////////////////////////////////////////////////
		// Public Methods
		////////////////////////////////////////////////////////////////////////////
		public function playClick(volume:Number = 1):void
		{	
			_sm.playSound("CLICK", volume, 0, 0, false);
		}
		
		public function stopClick():void
		{
			_sm.stopSound("CLICK");
		}
		
		public function playKeypad(volume:Number = 2):void
		{	
//			trace("INFO SoundController :: playKeypad ?????");
			
			playClick(.2);
//			_sm.playSound("KEYPAD", volume, 0, 0, false);	//this sound doesn't play, for some reason, after it's imported into Flash library
		}
		
		public function stopKeypad():void
		{
			stopClick();
//			_sm.stopSound("KEYPAD");
		}
		
		public function playCorrect(volume:Number = 1):void
		{
			_sm.playSound("CORRECT", volume, 0, 0, false);
		}
		
		public function stopCorrect():void
		{
			_sm.stopSound("CORRECT");
		}
		
		public function playInCorrect(volume:Number = 1):void
		{
//			trace("INFO SoundController :: playInCorrect?????");
			
			_sm.playSound("INCORRECT", volume, 0, 0, false);
		}
		
		public function stopInCorrect():void
		{
			_sm.stopSound("INCORRECT");
		}
		
		public function playGameEnd(volume:Number = 1):void
		{
//			trace("INFO SoundController :: playGameEnd");
			
			_sm.playSound("END", volume, 0, 0, false);
		}
		
		public function stopGameEnd():void
		{
			_sm.stopSound("END");
		}

		public function setMute():void
		{
			_sm.muteAllSounds();
		}
		
		public function setUnmute():void
		{
			_sm.unmuteAllSounds();
		}
	}//c
}//p

class SingletonEnforcer {}