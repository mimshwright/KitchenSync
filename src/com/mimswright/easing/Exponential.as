package com.mimswright.easing
{
	public class Exponential
	{	
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number):Number
		{
			return (timeElapsed==0) ? 0 : Math.pow(2, 10 * (timeElapsed/duration - 1));
		}
				
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number):Number
		{
			return (timeElapsed==duration) ? 1 : (-Math.pow(2, -10 * timeElapsed/duration) + 1);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number):Number
		{
			if (timeElapsed<=0) {
				return 0;
			}
			if (timeElapsed>=duration) {
				return 1;
			}
			if ((timeElapsed/=duration/2) < 1) {
				return 0.5 * Math.pow(2, 10 * (timeElapsed - 1));
			}
			return 0.5 * (-Math.pow(2, -10 * --timeElapsed) + 2);
		}		
	}
}