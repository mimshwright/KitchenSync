package com.mimswright.easing
{
	public class Elastic
	{	
		private static const TWICE_PI:Number = Math.PI * 2;
		private static const DEFAULT_PERIOD:Number = 0.3;
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @param amplitude - The aplitude of the sine wave. Low numbers are less extreme than high numbers.
	     *  @param period - The period of the sine wave. Low numbers are wobbly, high numbers are smooth.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number, amplitude:Number = 0, period:Number = 0):Number
		{
			if (timeElapsed <= 0) {
				return 0;
			} 
			if ((timeElapsed /= duration) >= 1) {
				return 1;
			}
			if (period == 0) {
				period = duration * DEFAULT_PERIOD;
			} 
			var decay:Number;
			if (amplitude < 1) { 
				amplitude = 1; 
				decay = period / 4; 
			} else {
				decay= period / TWICE_PI * Math.asin (1/amplitude);
			}
			return -(amplitude*Math.pow(2,10*(timeElapsed-=1)) * Math.sin( (timeElapsed*duration-decay)*TWICE_PI/period )); 
		}
	
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @param amplitude - The aplitude of the sine wave. Low numbers are less extreme than high numbers.
	     *  @param period - The period of the sine wave. Low numbers are wobbly, high numbers are smooth.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number, amplitude:Number = 0, period:Number = 0):Number
		{
			if (timeElapsed <= 0) {
				return 0;  
			}
			if ((timeElapsed /= duration) >= 1) {
				return 1;
			}
			if (!period) {
				period = duration * DEFAULT_PERIOD;
			}
			var decay:Number;
			if (amplitude < 1) { 
				amplitude = 1; 
				decay = period / 4; 
			} else {
			   decay= period / TWICE_PI * Math.asin (1/amplitude);
			} 
			return (amplitude*Math.pow(2,-10*timeElapsed) * Math.sin( (timeElapsed*duration-decay)*TWICE_PI/period ) + 1);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @param amplitude - The aplitude of the sine wave. Low numbers are less extreme than high numbers.
	     *  @param period - The period of the sine wave. Low numbers are wobbly, high numbers are smooth.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number, amplitude:Number = 0, period:Number = 0):Number
		{
			if (timeElapsed <= 0) {
				return 0;
			}  
			if ((timeElapsed /= duration/2) >= 2) {
				return 1;
			}  
			if (!period) {
				period = duration * (DEFAULT_PERIOD * 1.5);
			}
			var decay:Number;
			if (amplitude < 1) { 
				amplitude = 1; 
				decay = period / 4; 
			} else {
				decay = period / TWICE_PI * Math.asin (1/amplitude);
			}
			if (timeElapsed < 1) {
				return -0.5*(amplitude*Math.pow(2,10*(timeElapsed-=1)) * Math.sin((timeElapsed*duration-decay)*TWICE_PI/period ));
			}
			return 0.5*(amplitude*Math.pow(2,-10*(timeElapsed-=1)) * Math.sin((timeElapsed*duration-decay)*TWICE_PI/period )) + 1;
		}
	
	}
}