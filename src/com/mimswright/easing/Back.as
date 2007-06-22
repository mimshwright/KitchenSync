package com.mimswright.easing
{
	/**
	 * Produces values that go beyond the usual bounds of 0.0 to 1.0 by a specified amount (overshoot).
	 * 
 	 * @author modified by Mims H. Wright, 2007
	 * @author (c) 2003 Robert Penner, all rights reserved. - This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html
	 * @see http://www.robertpenner.com/easing_terms_of_use.html">http://www.robertpenner.com/easing_terms_of_use.html
	 * @see http://www.robertpenner.com/easing/
	 */
	public class Back
	{
		private static const DEFAULT_OVERSHOOT:Number = 1.70158; // roughly 10%
		private static const OVERSHOOT_GROWTH:Number = 1.525;
		
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @param overshoot - The ammount to go over past the target value. The higher the number, the farther it will go.
	     *  @return Number percentage complete - between 0.0 and 1.0 but with the overshoot, it may extend below 0.0 or above 1.0
	     */  
		public static function easeIn (timeElapsed:Number, duration:Number, overshoot:Number = DEFAULT_OVERSHOOT):Number 
		{
			return (timeElapsed/=duration)*timeElapsed*((overshoot+1)*timeElapsed - overshoot);
		}	
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @param overshoot - The ammount to go over past the target value. The higher the number, the farther it will go.
	     *  @return Number percentage complete - between 0.0 and 1.0 but with the overshoot, it may extend below 0.0 or above 1.0
	     */  
		public static function easeOut (timeElapsed:Number, duration:Number, overshoot:Number = DEFAULT_OVERSHOOT):Number 
		{
			return ((timeElapsed=timeElapsed/duration-1)*timeElapsed*((overshoot+1)*timeElapsed + overshoot) + 1);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @param overshoot - The ammount to go over past the target value. The higher the number, the farther it will go.
	     *  @return Number percentage complete - between 0.0 and 1.0 but with the overshoot, it may extend below 0.0 or above 1.0
	     */  
		public static function easeInOut (timeElapsed:Number, duration:Number, overshoot:Number = DEFAULT_OVERSHOOT):Number 
		{
			if ((timeElapsed/=duration/2) < 1) {
				return 0.5*(timeElapsed*timeElapsed*(((overshoot*=OVERSHOOT_GROWTH)+1)*timeElapsed - overshoot));
			}
			return 0.5*((timeElapsed-=2)*timeElapsed*(((overshoot*=OVERSHOOT_GROWTH)+1)*timeElapsed + overshoot) + 2);
		}	
	}
}