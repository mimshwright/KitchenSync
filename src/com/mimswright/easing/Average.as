package com.mimswright.easing
{
	 /**
	 * <p>Takes two functions and creates a new easing function from them usually producing interesting results.</p>
	 * <p>The easing classes provide static methods for interpolating the change between two values over time.
	 * Each class handles the interpolation, or easing, differently. Each class typically contains three methods
	 *  - <code>easeIn()</code>, <code>easeOut()</code> and <code>easeInOut()</code> - which vary the rate of change
	 *  of the values. Most of the easing functions produce values as a percentage - a number between 0.0 and 1.0</p>
	 * 
 	 * @author Mims H. Wright
	 */
	public class Average
	{
		
		/**
		 * Creates a new easing function based on two other easing functions.
		 * 
		 * @example Combine cubic in/out easing with a sine wave oscillator.
		 * 			<listing version="3.0">
		 * 				myTween.easingFunction = Average.getAveragedFunction(Cubic.easeInOut, Oscillate.sine);	
		 * 			</listing>
		 * 
		 * @param easingFunciton1 One of the two easing functions that will be averaged by the new function.
		 * @param easingFunciton2 The second of the two easing functions that will be averaged by the new function.
	     * @return A new easing function that produces values averaged from the two easing functions.
	     */
		public static function getAveragedFunction(easingFunction1:Function, easingFunction2:Function):Function {
			var func:Function;
			var results:Number;
			func = function (timeElapsed:Number, duration:Number, mod1:Number = NaN, mod2:Number = NaN):Number {
				var value1:Number = EasingUtil.call(easingFunction1, timeElapsed, duration, mod1, mod2);
				var value2:Number = EasingUtil.call(easingFunction2, timeElapsed, duration, mod1, mod2);
				return (value1 + value2)/2;
			}
			return func;
		}
	}
}