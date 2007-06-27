package com.mimswright.easing
{
	/**
	 * @todo Add sawtooth wave
	 * @todo Add square wave
	 * @todo Add pulse wave
	 */
	public class Oscillate
	{
		private static const TWICE_PI:Number = Math.PI*2;
		private static const DEFAULT_FREQUENCY:Number = 0.1; // oscillations per unit, that's 1 cycle every 10 frames / milliseconds
		
		/**
	    * Oscillates between 0 and 1.0 (starting with 0 and ending with 1.0) for as long as the duration lasts. 
	    * (actually, this is more of a cosine) The position will be based on the timeElapsed and frequency.
	    * @author Mims H Wright
	    *
	    * @todo duration isn't used. use it or clean that up somehow.
	    *  
	    * @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	    * @param duration - Specifies the duration of the tween, in milliseconds or frames.
  	    * @param frequency - The frequency of the sine wave in oscillations per unit (ms or frames). Higher is faster. 1/frequency = wavelength
	    * @return Number - between 0.0 and 1.0 based on the time and frequency. Returns 1.0 if duration is elapsed.
	    */  
		public static function sine(timeElapsed:Number, duration:Number, frequency:Number=DEFAULT_FREQUENCY):Number {
			return 0.5 * (1 - Math.cos( TWICE_PI * timeElapsed * frequency));
		}	
	}
}