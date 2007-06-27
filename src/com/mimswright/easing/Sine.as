package com.mimswright.easing
{
	public class Sine
	{	
		private static const HALF_PI:Number = Math.PI/2;
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number):Number
		{
			return -1 * Math.cos(timeElapsed/duration * HALF_PI) + 1;
		}
				
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number):Number
		{
			return Math.sin(timeElapsed/duration * HALF_PI);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number):Number
		{
			return -0.5 * (Math.cos(Math.PI*timeElapsed/duration) - 1);
		}	
	}
}