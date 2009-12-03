package org.as3lib.kitchensync.action.tween
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	
	/**
	 * Provides a convenient interface for creating all types of tweens.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	final public class TweenFactory
	{
		
		/** 
		 * An instance of the object parser to use when parsing objects.
		 * @see #newTweenFromObject() 
		 */
		public static var objectParser:ITweenObjectParser = KitchenSyncDefaults.tweenObjectParser;
		
		
		/** 
		 * Uses a generic object to define parameters for a new tween. See ITweenParser and KitchenSyncObjectParser for more details.
		 *
		 * @see ITweenObjectParser
		 * @see KitchenSyncObjectParser
		 * 
		 * @param parameters An object that contains properties that define the new tween
		 * @return A new tween.
		 */ 
		public static function newTweenFromObject(parameters:Object):ITween {
			return objectParser.parseObject(parameters);
		}
		
		/**
		 * Creates a property tween with one or more targets. 
		 * 
		 * @see #newWithTweenTarget()
		 * 
		 * @param target - the object whose property will be changed
		 * @param property - the name of the property to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param startValue - the starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param endValue The value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param duration - the time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay - the time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 * @return A new ITween instance
		 */
		public static function newTween(target:Object = null, property:String = "", startValue:Number = 0, endValue:Number = 0, duration:* = 0, delay:* = 0, easingFunction:Function = null):ITween {
			return new KSTween(target, property, startValue, endValue, duration, delay, easingFunction);
		}

		/**
		 * Creates a tint tween.
		 * 
		 * @see org.as3lib.kitchensync.action.tween.TintTweenTarget
		 * 
		 * @param target The displayObject whose property will be changed
		 * @param startValue The starting color of the tint. By default, this is the value of the property before the tween begins.
		 * @param endValue The value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @return A new KSTween instance
		 * 
		 * @since 2.0
		 */
		public static function newTintTween(target:DisplayObject, 
											startColor:* = "currentTint", 
											endColor:* = "noTint", 
											tintOpacity:Number = 1.0,
											duration:* = 0, delay:* = 0, 
											easingFunction:Function = null):ITween {
			return newTweenWithTargets(
				new TintTweenTarget(target, startColor, endColor, tintOpacity), 
				duration, delay, easingFunction);
		}

		
		/**
		 * Creates a tween that moves a display object between two points.
		 * 
		 * @param target - the display object whose property will be changed
		 * @param startValue - the starting point of the target.
		 * @param endValue - the ending point of the target.
		 * @param duration - the time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay - the time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 * @return A new KSTween Instance
		 * 
		 * @since 2.0
		 */
		public static function newPositionTween(target:DisplayObject, startValue:Point, endValue:Point, duration:* = 0, delay:* = 0, easingFunciton:Function = null):KSTween {
			var x:ITweenTarget = new TargetProperty(target, "x", startValue.x, endValue.x);
			var y:ITweenTarget = new TargetProperty(target, "y", startValue.y, endValue.y);
			return newTweenWithTargets([x,y], duration, delay, easingFunciton);
		} 
		
//		public static function newPositionTween3D(target:Object, startValue:Array, endValue:Array, duration:* = 0, delay:* = 0, easingFunciton:Function = null):KSTween {
//			var x:ITweenTarget = new TargetProperty(target, "x", Number(startValue[0]), Number(endValue[0]));
//			var y:ITweenTarget = new TargetProperty(target, "y", Number(startValue[1]), Number(endValue[1]));
//			var z:ITweenTarget = new TargetProperty(target, "z", Number(startValue[2]), Number(endValue[2]));
//			return newWithTargets([x,y,z], duration, delay, easingFunciton);
//		} 

		/**
		 * Creates a tween that scales x and y simultaneously.
		 * 
		 * @param target The display object whose property will be changed
		 * @param startValue The starting scale of the target.
		 * @param endValue The ending scale of the target.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @return A new KSTween instance.
		 * 
		 * @since 2.0
		 */
		public static function newScaleTween(target:DisplayObject, startValue:Number, endValue:Number, duration:* = 0, delay:* = 0, easingFunciton:Function = null):KSTween {
			var x:ITweenTarget = new TargetProperty(target, "scaleX", startValue, endValue);
			var y:ITweenTarget = new TargetProperty(target, "scaleY", startValue, endValue);
			return newTweenWithTargets([x,y], duration, delay, easingFunciton);
		} 

		/**
		 * Creates a new KSTween using an ITweenTarget that you pass into it.
		 * 
		 * @param tweenTarget A tweenTarget object (or an array of tweenTargets) that contains the values you want to tween.
		 * @param duration The time in frames that this tween will take to execute.
		 * @param delay The time to wait before starting the tween.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * 
		 * @return A new KSTween object.
		 */
		public static function newTweenWithTargets(tweenTargets:*, duration:* = 0, delay:* = 0, easingFunction:Function = null):KSTween {
			return KSTween.newWithTweenTarget(tweenTargets, duration, delay, easingFunction);
		} 

		
		/**
		 * Creates a tween to control a filter property.
		 * 
		 * @see FilterTweenTarget
		 * 
		 * @param target The target object of the tween. 
		 * @param filter The filter of the target to tween.
		 * @param targetProperty The property of the filter to tween.
		 * @param startValue The starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param endValue The value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * 
		 * @return A new KSTween object.
		 */
		public static function newFilterTween(target:DisplayObject, filter:Class, filterProperty:String, startValue:Number, endValue:Number, duration:*, delay:* = 0, easingFunction:Function = null):KSTween {
			return KSTween.newWithTweenTarget(new FilterTargetProperty(target, filter, filterProperty, startValue, endValue), duration, delay, easingFunction);
		}
	}
}