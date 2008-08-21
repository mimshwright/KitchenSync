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
			// set up initial tween.
			var tween:KSTween = new KSTween(null, "", NaN, NaN, parseDuration(parameters), parseDelay(parameters), parseEasingFunction(parameters));
			
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
				
			} // else require target?
			
			var mod1:* = parseMod1(parameters);
			var mod2:* = parseMod2(parameters);

			if (mod1) { tween.easingMod1 = mod1; }
			if (mod2) { tween.easingMod2 = mod2; }
			
			return tween;
		}
		
		private static function parseEasingFunction(parameters:Object):Function {
			var easingFunction:Function = getFirstDefinedValue(parameters, "easingFunction", "easing", "ease") as Function;
			if (easingFunction != null) {
				return easingFunction;
			}
			return null;
		}
		
		private static function parseDuration(parameters:Object):* {
			var duration:* = getFirstDefinedValue(parameters, "duration");
			if (isNaN(duration)) {
				if (duration == null) {
					// default to 1 second
					return 1000;
				}
			} 
			return duration;
		}

		private static function parseDelay(parameters:Object):* {
			var delay:* = getFirstDefinedValue(parameters, "delay", "offset");
			return delay;
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
			var results:Object;
			var property:String;
			var startValue:Number;
			var endValue:Number;
			
			for (var key:String in paramerters) {
				
				// check for ~ notation 
				var string:String = paramerters[key].toString();				
				if (string.search("~") >= 0) {
					var values:Array = string.split("~");
					property = key;
					startValue = values[0];
					endValue = values[1];
				} else {
					// check for _start / _end notation.
					var startStringIndex:int = key.search(/(_start|Start)/);
					if (startStringIndex >= 0) {
						property = key.slice(0, startStringIndex);
						startValue = paramerters[key] as Number; 
						endValue = getFirstDefinedValue(paramerters, property + "_end", property + "End") as Number;
						
						results = {property: property, start: startValue, end: endValue};
						resultsArray.push(results);
						continue;
					} else {
						// ignore it.
					}
				} 
				
				results = {start: startValue, end: endValue};
				// check results for keywords.
				switch (property) {
					case "scale":
						resultsArray.push({property:"scaleX", start:startValue, end:endValue});
						resultsArray.push({property:"scaleY", start:startValue, end:endValue});
					break;
					
					default:
						// push results onto array to later be converted into tween targets.
						results.property = property;
						resultsArray.push(results);
				}
				
			}
			return resultsArray;
		}
		
		private static function parsePropertiesString(string:String):Array {
			var resultsArray:Array = [];
			var results:Object;
			var property:String;
			var values:String;
			var startValue:Number;
			var endValue:Number;
			
			var props:Array = string.split(",");
			var prop:String;
			for each (prop in props) {
				property = prop.split(":")[0];
				values = prop.split(":")[1]; 
				if (values.search("~") >=0) {
					startValue = Number(values.split("~")[0]);
					endValue = Number(values.split("~")[1]);
				} else {
					startValue = KSTween.VALUE_AT_START_OF_TWEEN;
					endValue = Number(values);
				}
				results = {property: property, start: startValue, end: endValue};
				resultsArray.push(results);
			}
			return resultsArray;
		}
		
		private static function parseMod1(parameters:Object):Number {
			var mod1:Number = getFirstDefinedValue(parameters, "easingMod1", "mod1") as Number;
			 return mod1;
		}
		private static function parseMod2(parameters:Object):Number {
			var mod2:Number = getFirstDefinedValue(parameters, "easingMod2", "mod2") as Number;
			 return mod2;
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
