package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.action.tweentarget.ITweenTarget;
	import org.as3lib.kitchensync.action.tweentarget.TargetProperty;
	
	/**
	 * Provides a convenient interface for creating all types of tweens.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	final public class TweenFactory
	{
		
		public static function newTween(parameters:Object):KSTween {
			var tween:KSTween = new KSTween(null, "", NaN, NaN, 2000, 1000, parseEasingFunction(parameters));
			// parse target
			var i:int, j:int;
			var target:Object = parameters.target;
			var targets:Array = parameters.targets;
			if (target || targets) {
				if (!targets) {
					// convert values to an array of objects
				 	if (target is Array) {
				 		targets = target as Array;
				 	} else {
				 		targets = new Array();
				 		targets.push(target);
				 	}
				}
				
				var property:Object = parameters.property;
				var properties:Array = parameters.properties;
				var startValue:Number = parseStartValue(parameters);
				var endValue:Number = parseEndValue(parameters);
				
				// parse property
				if (property || properties) {
					if (startValue == KSTween.VALUE_AT_START_OF_TWEEN && endValue == KSTween.VALUE_AT_START_OF_TWEEN) {
						throw new ArgumentError("Using 'properties' parameter requires a 'start' and/or 'end' parameter.");
					}
					
					if (!properties) {
						// convert values to an array of strings
						if (property is String) {
							properties = new Array();
							properties.push(property);
						} else if (property is Array) {
							properties = property as Array;
						} else {
							throw new TypeError("The 'property' parameter must be a string or an array of strings.");
						}
					}
					for (i = 0; i < targets.length; i++) {
						for (j = 0; j < properties.length; j++) {
							tween.addTweenTarget(new TargetProperty(targets[i], properties[j], startValue, endValue)); 
						}
					}
				} else {
					var propList:Array = parseProperties(parameters);
					for (i = 0; i < targets.length; i ++) {
						for (j = 0; j < propList.length; j++) {
							var tweenTarget:ITweenTarget = new TargetProperty(targets[i], 
																			  propList[j].property as String,
																			  Number(propList[j].start),
																			  Number(propList[j].end));
													
							tween.addTweenTarget(tweenTarget);
						}
					}
				}
				
			}
			
			return tween;
		}
		
		private static function parseEasingFunction(parameters:Object):Function {
			var easingFunction:Function = getFirstDefinedValue(parameters, "easingFunction", "easing", "ease") as Function;
			if (easingFunction != null) {
				return easingFunction;
			}
			return null;
		}
		
		private static function parseStartValue(parameters:Object):Number {
			var startValue:Number = getFirstDefinedValue(parameters, "startValue", "start", "from") as Number;
			if (!isNaN(startValue)) { return startValue; }
			return KSTween.VALUE_AT_START_OF_TWEEN;
		}
		
		private static function parseEndValue(parameters:Object):Number {
			var endValue:Number = getFirstDefinedValue(parameters, "endValue", "end", "to") as Number;
			if (!isNaN(endValue)) { return endValue; }
			return KSTween.VALUE_AT_START_OF_TWEEN;
		}
		
		private static function parseProperties(paramerters:Object):Array {
			var resultsArray:Array = new Array();
			for (var key:String in paramerters) {
				var results:Object;
				var string:String = paramerters[key].toString();				
				if (string.search("~") >= 0) {
					var values:Array = string.split("~");
					results = {property:key, start: values[0], end: values[1]};
					resultsArray.push(results);
					continue;
				}
				
				var startStringIndex:int = key.search(/(_start|Start)/);
				if (startStringIndex >= 0) {
					var property:String = key.slice(0, startStringIndex);
					var startValue:Number = paramerters[key] as Number; 
					var endValue:Number = getFirstDefinedValue(paramerters, property + "_end", property + "End") as Number;
					
					results = {property: property, start: startValue, end: endValue};
					resultsArray.push(results);
					continue;
				}
			}
			return resultsArray;
		}
		
		/** 
		 * Returns the first defined variable within an object.
		 * Used when you need to access a value that may have multiple aliases.
		 * The values will be checked in order that they are entered.
		 * 
		 * @param object The object to check for values.
		 * @param keys The remaining parameters will be strings of property names to check for valid values.
		 * @return the value of the first defined property or null if all were undefined.
		 */
		private static function getFirstDefinedValue(object:Object, ... keys):* {
			var key:String, value:*, i:int;
			for (i = 0; i < keys.length; i++) {
				key = keys[i];
				value = object[key] as Object;
				if (value != null) { return value; }
			}
			return null;
		}
		
		/**
		 * Creates a tween with a TargetProperty as it's tween target. 
		 * 
		 * @see #newWithTweenTarget()
		 * 
		 * @param target - the object whose property will be changed
		 * @param property - the name of the property to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param startValue - the value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param endValue - the starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param duration - the time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay - the time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public static function newWithTargetProperty(target:Object = null, property:String = "", startValue:Number = 0, endValue:Number = 0, duration:* = 0, delay:* = 0, easingFunction:Function = null):KSTween {
			return new KSTween(target, property, startValue, endValue, duration, delay, easingFunction);
		}


		/**
		 * Creates a new KSTween using an ITweenTarget that you pass into it.
		 * 
		 * @param tweenTarget An explicitly defined tweenTarget object (or an array of tweentargets) that contains the values you want to tween.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param delay - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 * @return A new KSTween object.
		 */
		public static function newWithTweenTarget(tweenTarget:*, duration:* = 0, delay:* = 0, easingFunction:Function = null):KSTween {
			return KSTween.newWithTweenTarget(tweenTarget, duration, delay, easingFunction);
		} 

	}
}
