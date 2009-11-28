package org.as3lib.kitchensync.action.tween
{
	
	/**
	 * An enumeration of valid properties for the sound transform object. 
	 *
	 * @author Mims H. Wright
	 * @since 2.0
	 */
	final public class SoundTransformProperty
	{
		/** Volume property. */
		public static const VOLUME:SoundTransformProperty = new SoundTransformProperty("volume");
		/** Pan property. */
		public static const PAN:SoundTransformProperty = new SoundTransformProperty("pan");
		/** Right to Left mixing property. */
		public static const RIGHT_TO_LEFT:SoundTransformProperty = new SoundTransformProperty("rightToLeft");
		/** Left to Right Mixing property. */
		public static const LEFT_TO_RIGHT:SoundTransformProperty = new SoundTransformProperty("leftToRight");
		
		private var _string:String;
		
		/**
		 * Constructor. This should not be used outside of this class.
		 * 
		 * @param string The string representation of the property. 
		 */
		public function SoundTransformProperty(string:String = "") {
			_string = string;
		}
		
		/** Returns the value of the property string */
		public function toString():String {
			if (!_string) { return super.toString(); }
			return _string;
		}
	}
}