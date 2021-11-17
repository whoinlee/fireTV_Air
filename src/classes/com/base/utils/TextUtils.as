package com.base.utils {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextUtils {
		/**
		 * If true, TextUtils will trace the missing characters along with their ascii code if setting the text fails.
		 */
		public static var debug : Boolean = false;
		/**
		 * initialize SuperScript support.
		 * 
		 * If you're using simpleapp, this is called automatically for you, but if you're using this class without simpleapp, you'll
		 * need to initialize superscript support manually.  That's because it takes a short time for the glyphs to be installed and
		 * this provides a callback method that tells you when that has happened.
		 * 
		 * Only the folloing glpyhs are embedded: ®©℗°℠™SMTM
		 * 
		 * @param callback	
		 */
		public static function initSuperscript(callback:Function = null):void {
			if (_superscriptInit) {
				if (callback is Function) {
					callback();
				}
				return;
			}
			_superscriptInit = true;
			
			// characters included are, ®©℗°℠™SMTM
			var GG_SUPERSCRIPT : String =
			"RldTCs8JAAB4AAVfAAAPoAAAHwEARBEZAAAAfxPLAQAAPHJkZjpSREYgeG1sbnM6cmRmPSdodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1ze"+
			"W50YXgtbnMjJz48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJyB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMSc+PGRjOm"+
			"Zvcm1hdD5hcHBsaWNhdGlvbi94LXNob2Nrd2F2ZS1mbGFzaDwvZGM6Zm9ybWF0PjxkYzp0aXRsZT5BZG9iZSBGbGV4IDMgQXBwbGljYXRpb248L2RjOnR"+
			"pdGxlPjxkYzpkZXNjcmlwdGlvbj5odHRwOi8vd3d3LmFkb2JlLmNvbS9wcm9kdWN0cy9mbGV4PC9kYzpkZXNjcmlwdGlvbj48ZGM6cHVibGlzaGVyPnVu"+
			"a25vd248L2RjOnB1Ymxpc2hlcj48ZGM6Y3JlYXRvcj51bmtub3duPC9kYzpjcmVhdG9yPjxkYzpsYW5ndWFnZT5FTjwvZGM6bGFuZ3VhZ2U+PGRjOmRhd"+
			"GU+Tm92IDEzLCAyMDEwPC9kYzpkYXRlPjwvcmRmOkRlc2NyaXB0aW9uPjwvcmRmOlJERj4AHxB1GSQxJDdBJDJidWhoeXVLRUlnSVhUY0N6OENKRi8A0A"+
			"/kN9TYPfMoehPNEGzcZWqyRBDoAzwAQwL///9aCgMAAAAGAAAAAwP0EgAAAAAAACIik0csAQAAxQpNYWluAP8SUQQAAAEAhAEPR0cgU3VwZXJzY3JpcHQ"+
			"ACgAWABgAVgD1ABIB9QHvAl4DhAOqA/cDIAAgDcNIReDyRA8YvDoXm8jPikFSL5OweDXUiMxoQSmHkb0r9uhWTxdEOSIHjPked5pg45JNed8ydk8WJzBA"+
			"ACAN4Hgsvjzcx7CoHhEI44ZCk9Q0k7AAqSIAAG42ooNK3gAqykAFTpXasq62+Iv68Qpk1zjH3EKr+t5AAL8KgALKEzuAqUscGW0ACpq4AAp4+ikpR9APJ"+
			"i5xoCNV7VU5NsABVMIAAAAiFSABEybCWUkEDw0gWlSSQhw3AZFSZxGAACXVQAChVdhJ1NiiMT0ABVCwABn9ctToS437KYYIACANxwhF4PJEDxmEOy1Byz"+
			"g8FoDlZB2WoPFnwwQAIA3jrCLwNL6AAN6PpS3A/x6mpUn0cIAB5VIAHvYCbhTgJs0pDwUx8PVCwAFMDgASQwZTIbBmFpIU4Wk0ACIFIAIHH+khSgiSDes"+
			"QUt6xA7YAGCAvHWEhgqjkAAyaYEpykuQADKqgAHEmLDXKVtGQZUACpyYAA2afKk0lJgATqpABLjKVJqcpUmphnqmhGcJ6AAwQF5OIrW3NLAtKutlRqQgA"+
			"KYvAAvdainBlsgARUqAAqwO24MpOZwZJwAKlMgABXkiOdxhGU7Ao5PQAFVewAAADFlQADAiZwAFLygADwhtggAAgDeOsIvA0voAA3o+lLcD/HqalSfRwg"+
			"AHlUgAe9gJuFOAmzSkPBTHw9ULAAUwOABJDBlMhsGYWkhThaTQAIgUgAgcf6SFKCJIN6xBS3rEDtgAYIC8dYSGCqOQADJpgSnKS5AAMqqAAcSYsNcpW0Z"+
			"BlQAKnJgADZp8qTSUmABOqkAEuMpUmpylSamGeqaEZwnoADBAXivC5YclgPG/A6FbqkpgABXiCKC+SIAFAoAB9KiUCiolAhYKKTNC0Qk1zmfRlXJOrnpi"+
			"u1OZqEby5dRoW6WAAHBPXS3BggLxXhOoOlQDkYtS8oAAALAUABM1CbBRq3dRUAHJRzBAAIA3goCWYNIALjGaz1SZrOCRAAUpEAAZoyFJmjDAAR1SABHWZ"+
			"jDU5cMhcYAFNvAAZmzhTmbPQALjYIC8JYSzqgAFKPo5qDwOZXgAoV4AD6xqg8MaACtqAAqzEMaowbEKiACiogAxA8KMGOYAFUwQAIA3owAAAPhEAfNvAe"+
			"DwB8pEBggMAoAvID1fQHgoAesGA8LADBAAgDejAAAA+EQB828B4PAHykQGCAwCgC8gPV9AeCgB6wYDwsAMEACAN4zQq6DyUw7ZSHRVhy2A7GuHKoDoqw7"+
			"WuGCAvK8FXQ5LAdsBDkf53H5Mnu48CadzfkBTtf4clgO2WZ34MNNOddgFd96UprtauYIAAIABNAFMAVACpAK4AsAAXISAhIiFsSPQQqAIsC1whuBp0GIg"+
			"dXA1cDQAoACjYDggACAAIAAgACAAIAAgACAAIAAgAAAB/EmcAAAABAEACAAAAAAAAAAAAAk0yAABePulCAwJFMgAAAADpQgMCEToAAAAA6UIDAuI2AAAA"+
			"AOlCAwJoNwAAAADpQgMCRTIAAAAA6UIDAkUyAAAAAOlCAwJFMgAAAADpQgMCRTIAAAAA6UIDPxZFAAAAAQBHRyBTdXBlcnNjcmlwdABDb3B5cmlnaHQgK"+
			"EMpIDIwMDcgR0dTSE9XLk5FVC4gQWxsIHJpZ2h0cyByZXNlcnZlZC4AvxRKAgAAAQAAAGZyYW1lMQAQAC4AAAAAEgAJTWFpbi9NYWluI0dHU3VwZXJTY3"+
			"JpcHRGb250L0dHU3VwZXJTY3JpcHRGb250BE1haW4NZmxhc2guZGlzcGxheQZTcHJpdGURR0dTdXBlclNjcmlwdEZvbnQKZmxhc2gudGV4dARGb250Mi9"+
			"MaWJyYXJ5L1dlYlNlcnZlci9Eb2N1bWVudHMvdGVzdEZvbnQvc3JjOztNYWluLmFzBk9iamVjdAxmbGFzaC5ldmVudHMPRXZlbnREaXNwYXRjaGVyDURp"+
			"c3BsYXlPYmplY3QRSW50ZXJhY3RpdmVPYmplY3QWRGlzcGxheU9iamVjdENvbnRhaW5lcj8vTGlicmFyeS9XZWJTZXJ2ZXIvRG9jdW1lbnRzL3Rlc3RGb"+
			"250L3NyYzs7R0dTdXBlclNjcmlwdEZvbnQuYXMHFgEWBRgEFggYBxYMAgEBCwcBBAcCBgcBBwcECQcBCwcGDQcCDgcCDwcCEAkHAQYAAAEAAAACAAAAAQ"+
			"AAAAEAAAADAAAAAQAAAgECCQMAAQADBAkFAAQAAAADAAICAQEEAQAFAQMEAAEGAAEBCAkD0DBHAAABAQEJCgzxCvAI0DDQSQDwCkcAAAICAQEIK9Aw8Qr"+
			"wB2UAYAUwYAYwYAcwYAgwYAkwYAIwYAJYAB0dHR0dHWgB8QrwAkcAAAMBAQQFA9AwRwAABAEBBQYM8RHwCtAw0EkA8AtHAAAFAgEBBBvQMPER8AldCmAF"+
			"MGAEMGAEWAEdHWgD8RHwCEcAAB0TAgABAEdHU3VwZXJTY3JpcHRGb250AAAATWFpbgBAAAAA";
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				event.target.removeEventListener(event.type, arguments.callee);
				try {
					Font.registerFont(Class(loader.contentLoaderInfo.applicationDomain.getDefinition("GGSuperScriptFont")));
				} catch (err:Error) {}
				if (callback is Function) {
					callback();
				}
			});
			loader.loadBytes(Base64.decode(GG_SUPERSCRIPT), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		private static var _superscriptInit : Boolean;
		private static var _fonts : Object = [];
		

		/**
		 * Helper class for creating textfields. This class will automatically
		 * change the TextFormat to use the default system font if the provided
		 * TextFormat does not contain the required glyphs to display the text.
		 * @param text
		 * @param html	Boolean	If true, the following "®|©|℗|°|℠|™|TM|SM" will be set to use GG Superscript
		 * @param multiLine
		 * @param wordWrap
		 * @param autoSize
		 * @param selectable
		 * @param cssOrTextFormat	String/StyleStheet/TextFormat
		 * @param defaultCSS	the CSS tag to use as the default textformat (only used if cssOrTextFormat is String or StyleSheet)
		 * @return TextField
		 */
		public static function createTextField(text : String, html : Boolean = false, multiLine : Boolean = false, wordWrap : Boolean = false, autoSize : String = null, selectable : Boolean = false, cssOrTextFormat : * = null, defaultCSS:String = "p") : TextField {
			var tf : TextField = new TextField();
			if ( text == null ) {
				text = "";
			}
			if ( autoSize ) {
				tf.autoSize = autoSize;
			}
			tf.selectable = selectable;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.multiline = multiLine;
			tf.wordWrap = wordWrap;
			tf.condenseWhite = true;
			setText(tf, text, html, cssOrTextFormat, defaultCSS);
			return tf;
		}

		/**
		 * Sets the text of a TextField and change the embedFonts property to true or false depending if we have the glyphs to display the text
		 * @param tf	TextField
		 * @param text	String
		 * @param cssOrTextFormat	String/StyleStheet/TextFormat
		 * @param defaultCSS	the CSS tag to use as the default textformat (only used if cssOrTextFormat is String or StyleSheet)
		 * @param html	Boolean	If true, the following "®|©|℗|°|℠|™|TM|SM" will be set to use GG Superscript
		 */
		public static function setText(tf : TextField, text : String, html : Boolean, cssOrTextFormat : *, defaultCSS:String = "p") : void {			
			var i : int;
			var baseFormat : TextFormat;
			var originalFont : String;
			var hasGlyphs : Boolean;
			var fmt : TextFormat;
			var css : StyleSheet;
			var missingObj : Object;			var missingArr : Array;
			var char : String;
			var font : Font;
			var tmpText:String;
			if (text == null) {
				text = "";
			}
			tmpText = text;
			if (html && text != "" && getFont('GG Superscript').fontName != null) {
				text = text.replace(/(<sup>[ ]*){0,1}(®|©|℗|°|℠|™)([ ]*<\/sup>){0,1}/gi, "<font face='GG Superscript'>$2</font>").replace(/(<sup>[ ]*)(TM|SM)([ ]*<\/sup>)/gi, "<font face='GG Superscript'>$2</font>");
			}
			
			if (cssOrTextFormat is String || cssOrTextFormat is StyleSheet) {
				if (cssOrTextFormat is String) {
					css = new StyleSheet();
					css.parseCSS(String(cssOrTextFormat));
				} else {
					css = StyleSheet(cssOrTextFormat);
				}
				if (defaultCSS != "p") {
					baseFormat = css.transform(css.getStyle("p"));
				}
				fmt = css.transform(css.getStyle(defaultCSS));
			} else if (cssOrTextFormat is TextFormat) {
				fmt = TextFormat(cssOrTextFormat);
			}
			// copy defaults
			if (baseFormat && fmt) {
				fmt.font		||= baseFormat.font;
				fmt.size		||= baseFormat.size;				fmt.color		||= baseFormat.color;				fmt.bold		||= baseFormat.bold;				fmt.italic		||= baseFormat.italic;				fmt.underline	||= baseFormat.underline;				fmt.indent		||= baseFormat.indent;
				fmt.blockIndent	||= baseFormat.blockIndent;				fmt.align		||= baseFormat.align;				fmt.kerning		||= baseFormat.kerning;				fmt.leading		||= baseFormat.leading;				fmt.letterSpacing ||= baseFormat.letterSpacing;				fmt.leftMargin	||= baseFormat.leftMargin;				fmt.rightMargin	||= baseFormat.rightMargin;				fmt.tabStops	||= baseFormat.tabStops;			}
			
			// if there's no new incoming css, but we have an old one, store the old one
			// we'll re-apply the style once we've set the defaultTextFormat
			if ( css == null && tf.styleSheet ) {
				css = tf.styleSheet;
			}
			tf.styleSheet = null;
			
			// set textformat, style and text. in that order
			tf.defaultTextFormat = fmt;
			tf.styleSheet = css;
			
			if ( html ) {
				tf.htmlText = text;
			} else {
				tf.text = text;
			}
			
			// check for glyphs and set emebedFonts if we have 'em
			if (debug) {
				missingObj = {};
				missingArr = [];
			}
			hasGlyphs = true;
			i = tf.length;
			while ( --i > -1 ) {
				font = getFont(tf.getTextFormat(i).font);
				char = tf.text.charAt(i);
				if (!font.hasGlyphs(char) && char.search(/\s/) == -1) {
					hasGlyphs = false;
					if (debug) {
						missingObj[char] = (char + "[" + char.charCodeAt(0) + "]");
					} else {
						break;
					}
				}
			}
			tf.embedFonts = hasGlyphs;
			
			// There wasn't enough embedded glyphs to display the entire text
			// Let's reset the default font to _sans
			if ( !hasGlyphs && fmt ) {
				tf.styleSheet = null;
				originalFont = fmt.font;
				fmt.font = "_sans";
				tf.defaultTextFormat = fmt;
				fmt.font = originalFont;
				tf.styleSheet = css;
				if ( html ) {
					tf.htmlText = text;
				} else {
					tf.text = text;
				}
				trace("Missing glyphs for text : ", text);
				if (debug) {
					for each(char in missingObj) {
						missingArr.push(char);
					}
					trace("Missing glyphs:", missingArr.join("|"));
				}
			}
		}

		/**
		 * Add ellipsis to the last visible line of text if the text exceeds the height of the TextField.
		 * This is to be only used for TextField with autoSize set to NONE
		 * 
		 * @param tf	TextField
		 */
		public static function addEllipsis(tf : TextField) : void {
			if (!tf.getRect(tf).containsRect((tf.getCharBoundaries(tf.text.length - 1)))) {
				var lineNum : int = tf.bottomScrollV - 1;
				var lineText : String = tf.getLineText(lineNum);
				var offset : int = tf.getLineOffset(lineNum) + lineText.lastIndexOf(" ", lineText.length - 2);
				tf.replaceText(offset, tf.text.length, "...");
			}
		} 

		/**
		 * Convert CSS to TextFormat
		 * @param css	the css in text format in String or StyleSheet format
		 * @param tag	the css element to convet to a TextFormat
		 * @return	TextFormat
		 */
		public static function parseCSS(css : *, tag : String = "p") : TextFormat {
			var style : StyleSheet;
			if (css is String) {
				style = new StyleSheet();
				style.parseCSS(css);
			} else if (css is StyleSheet) {
				style = StyleSheet(css);
			}
			return style ? style.transform(style.getStyle(tag)) : null;
		}

		/**
		 * Given a font name, return a <code>Font</code> object. Returns an empty Font object is the font does not exist
		 * @return Font
		 */
		public static function getFont(name : String) : Font {
			if ( _fonts[name] ) {
				return _fonts[name];
			}
			var fonts : Array = Font.enumerateFonts();
			var i : int = fonts.length;
			while ( --i > -1 ) {
				if ( fonts[i].fontName == name ) {
					_fonts[name] = fonts[i];
					return _fonts[name];
				}
			}
			return new Font();
		}

		/**
		 * Output the list of embedded fonts to the output screen
		 */
		public static function traceFonts() : void {
			trace("Tracing fonts:");
			var fonts : Array = Font.enumerateFonts();
			var i : int = fonts.length;
			while ( --i > -1 ) {
				trace(i + ":" + Font(fonts[i]).fontName + ":" + Font(fonts[i]).fontStyle);
			}
			trace(".................................");
		}
		
	}
}
