package com.mimswright.easing
{
	/**
	 * A package of handy methods for working with Easing functions and classes.
	 * 
	 * @author Mims Wright
	 */
	public class EasingUtil
	{
		/**
		 * Provides a way to call an easing function with code-hinting and type checking (sorta).
		 *
		 * @throws ArgumentError - If the easing function is passed modifiers that it can't handle. (Don't use them unless they're handled by the function)
		 * @throws Error - You may get unexpected results if you use a function that isn't an easing function.
		 * 
		 * @param func - The function to call - Must be an Easing function.
		 * @param timeElapsed - The time since the tween began in milliseconds or frames.
	     * @param duration - The duration of the tween, in milliseconds or frames.
	     * @param mod1 - An optional modifier for the function. Used for tweens such as Back and Elastic.
	     * @param mod2 - An optional modifier for the function. Used for tweens such as Elastic.
	     * @return Number - the result of the easing function.
	     */
		public static function call(func:Function, timeElapsed:Number, duration:Number, mod1:Number = NaN, mod2:Number = NaN):Number {
			var result:Number;
			try {
				if (!isNaN(mod1)) {
					if (!isNaN(mod2)) {
						result = func.apply(func, [timeElapsed, duration, mod1, mod2]);			
					} else {
						result = func.apply(func, [timeElapsed, duration, mod1]);
					}
				} else {
					result = func.apply(func, [timeElapsed, duration]);
				}
			} catch (e:ArgumentError) {
				e.message = "You most likely tried to add modifier parameters (e.g. aplitude, overshoot) to an easing function that couldn't handle them or you are using an invalid function. " + e.message;
				throw e;
			} catch (e:Error) {
				e.message = "Make sure you are using a valid easing function with the signature funcitonName(timeElapsed:Number, duration:Number):Number. " + e.message;
			}
			return result;
		}
		
		/**
		 * Uses one of the easing functions to generate an array of results for as many steps as are specified.
		 * If steps is 10, you will have an array with length 10.
		 * 
		 * @see #call()
		 * 
		 * @param func - The function to call - Must be an Easing function.
		 * @param steps - The number of results desired for the array.
		 * @return Array - An array with the results from the easing function over 'steps' iterations.
		 */ 
		public static function generateArray(func:Function, steps:int):Array {
			var results:Array = new Array();
			for (var i:int = 0; i < steps; i++) {
				results.push(call(func,i, steps-1));
			}
			return results;
		}
	}
}