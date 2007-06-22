package com.mimswright.easing
{
	public class Linear
	{
		/**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function ease(timeElapsed:Number, duration:Number):Number{
			return timeElapsed / duration;
		}
		public static function easeIn	(timeElapsed:Number, duration:Number):Number{ return ease(timeElapsed,duration); }
		public static function easeOut	(timeElapsed:Number, duration:Number):Number{ return ease(timeElapsed,duration); }
		public static function easeInOut(timeElapsed:Number, duration:Number):Number{ return ease(timeElapsed,duration); }
	}
}