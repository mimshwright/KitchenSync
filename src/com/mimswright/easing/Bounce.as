package com.mimswright.easing
{
	public class Bounce
	{
		private static const BOUNCE_CONST:Number   = 7.5625;
		private static const THRESHOLDx1:Number    = 0.363636;
		private static const THRESHOLDx15:Number   = 0.545454;
		private static const THRESHOLDx2:Number    = 0.727272;
		private static const THRESHOLDx225:Number  = 0.818181;
		private static const THRESHOLDx25:Number   = 0.909090;
		private static const THRESHOLDx2625:Number = 0.954545;
		
		private static const BOUNCE1:Number = 0.75;
		private static const BOUNCE2:Number = 0.9375;
		private static const BOUNCE3:Number = 0.984375;
		
	    /**
	     *  @param timeElapsed - The time since the tween began in milliseconds or frames.
	     *  @param duration - The duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeIn(timeElapsed:Number, duration:Number):Number
		{
			return 1 - easeOut(duration-timeElapsed, duration);
		}
	
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeOut(timeElapsed:Number, duration:Number):Number
		{
			if ((timeElapsed/=duration) < THRESHOLDx1) {
				return (BOUNCE_CONST*timeElapsed*timeElapsed);
			} else if (timeElapsed < THRESHOLDx2) {
				return (BOUNCE_CONST*(timeElapsed-=THRESHOLDx15)*timeElapsed + BOUNCE1);
			} else if (timeElapsed < THRESHOLDx25) {
				return (BOUNCE_CONST*(timeElapsed-=THRESHOLDx225)*timeElapsed + BOUNCE2);
			}
			return (BOUNCE_CONST*(timeElapsed-=THRESHOLDx2625)*timeElapsed + BOUNCE3);
		}
	
	    /**
	     *  @param timeElapsed - Specifies the time since the tween began in milliseconds or frames.
	     *  @param duration - Specifies the duration of the tween, in milliseconds or frames.
	     *  @return Number percentage complete - between 0.0 and 1.0
	     */  
		public static function easeInOut(timeElapsed:Number, duration:Number):Number
		{
			if (timeElapsed < duration/2) {
				return easeIn (timeElapsed*2, duration)/2;
			}
			return easeOut (timeElapsed*2-duration, duration)/2 + 0.5;
		}
	
	}
}