package org.as3lib.kitchensync.action.tween
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import mx.effects.IAbstractEffect;
	
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	import org.as3lib.kitchensync.action.IAction;
	import org.as3lib.kitchensync.action.KSSetProperty;
	import org.as3lib.kitchensync.action.group.KSSequenceGroup;
	import org.as3lib.kitchensync.easing.Linear;
	
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
		public static function newTweenFromObject(parameters:Object):KSTween {
			return KSTween(objectParser.parseObject(parameters));
		}
		
		/**
		 * Creates a property tween with one or more targets. 
		 * 
		 * @see #newTweenWithTargets()
		 * 
		 * @param targets The object whose property will be changed or an array of targets.
		 * @param properties The name of the property to change or an array of properties to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param startValue The starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param endValue The value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new ITween instance
		 */
		public static function newTween(targets:*, properties:*, 
										startValue:Number = NaN, endValue:Number = NaN, 
										duration:* = 0, delay:* = 0, 
										easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			var targetsArray:Array, propertiesArray:Array;
			
			if ( targets == null) { throw new ArgumentError("'targets' cannot be null"); }
			if ( targets is Array) { targetsArray = targets; } 
			else { targetsArray = [targets]; }
			
			if (properties == null && properties == "") { throw new ArgumentError("'properties' cannot be null"); }
			else if (properties is Array) { propertiesArray = properties; }
			else if (properties is String) { propertiesArray = [String(properties)] }
			else { throw new TypeError("'properties' must be either a String or an Array of strings"); }
			
			var tweenTargets:Array = [];
			for each (var target:Object in targetsArray) {
				for each (var property:String in propertiesArray) {
					tweenTargets.push(new TargetProperty(target, property, startValue, endValue));
				}
			}
				
			return new KSTween(tweenTargets, duration, delay, easingFunction, easingMod1, easingMod2);
		}
		
		/**
		 * Creates an alpha tween that fades out.
		 * The list of parameters are simplified to keep this function short and practical.
		 *
		 * @see #newTween()
		 * @see #newFadeInTween()
		 * 
		 * @param target Tween's target must be a display object.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param setVisibility If true, this sets the visibility to false after the fade out is complete.
		 */
		public static function newFadeOutTween(target:DisplayObject, duration:* = 0, setVisibility:Boolean = true, startFromFullAlpha:Boolean = false):IAction {
			var startAlpha:Number = startFromFullAlpha ? 1.0 : AUTO_TWEEN_VALUE;
			var t:KSTween = newTween(target, "alpha", startAlpha , 0, duration, 0, Linear.ease);
			if (setVisibility) {
				return new KSSequenceGroup( t, new KSSetProperty(target, "visible", false));
			}
			return t;
		}
		
		/**
		 * Creates an alpha tween that fades in.
		 * The list of parameters are simplified to keep this function short and practical.
		 *
		 * @see #newTween()
		 * @see #newFadeOutTween()
		 * 
		 * @param target Tween's target must be a display object.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param setVisibility If true, this sets the visibility to true before the fade in is complete.
		 */
		public static function newFadeInTween(target:DisplayObject, duration:* = 0, setVisibility:Boolean = true, startFromZeroAlpha:Boolean = false):IAction {
			var startAlpha:Number = startFromZeroAlpha ? 0.0 : AUTO_TWEEN_VALUE;
			var t:KSTween = newTween(target, "alpha", startAlpha, 1, duration, 0, Linear.ease); 
			if (setVisibility) {
				return new KSSequenceGroup ( new KSSetProperty(target, "visible", true), t);
			}
			return t;
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
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new KSTween instance
		 * 
		 * @since 2.0
		 */
		public static function newTintTween(target:DisplayObject, 
											startColor:* = "currentTint", 
											endColor:* = "noTint", 
											tintOpacity:Number = 1.0,
											duration:* = 0, delay:* = 0, 
											easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			return newTweenWithTargets(
										new TintTweenTarget(target, startColor, endColor, tintOpacity), 
										duration, delay, 
										easingFunction, easingMod1, easingMod2
									  );
		}

		
		/**
		 * Creates a timeline tween.
		 * 
		 * @see org.as3lib.kitchensync.action.tween.TimelineController
		 * 
		 * @param target The movieClip that will be animated
		 * @param startFrame The starting frame. Can be a frame label or integer. Default is 1.
		 * @param endFrame The ending frame. Can be a frame label or integer. Default is the last frame in the clip.
		 * @param duration The time in milliseconds that this tween will take to execute. Default is the natural duration on the timeline.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue. Default is linear.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new KSTween instance
		 * 
		 * @since 2.0
		 */
		public static function newTimelineTween(target:MovieClip,
												startFrame:Object = null,
												endFrame:Object = null,
												duration:* = -1,
												easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			
			var timelineController:TimelineController = new TimelineController(target, startFrame, endFrame);
			if (duration == TimelineController.AUTO) {
				duration = timelineController.getNaturalDuration(TimelineController.AUTO);
			}
			if (easingFunction == null) {
				easingFunction = Linear.ease;
			}
			return newTweenWithTargets(timelineController, duration, 0, easingFunction, easingMod1, easingMod2);
		}
												
		
		/**
		 * Creates a tween that moves a display object between two points.
		 * 
		 * @param target the display object whose property will be changed
		 * @param xFrom starting x of the tween
		 * @param yFrom starting y of the tween
		 * @param xTo ending x of the tween
		 * @param yTo ending y of the tween
		 * @param endValue - the ending point of the target.
		 * @param duration - the time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay - the time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new KSTween Instance
		 * 
		 * @since 2.0
		 */
		public static function newPositionTween(target:DisplayObject, 
												xFrom:Number = AUTO_TWEEN_VALUE, yFrom:Number = AUTO_TWEEN_VALUE, 
												xTo:Number = AUTO_TWEEN_VALUE, yTo:Number = AUTO_TWEEN_VALUE,
												duration:* = 0, delay:* = 0, 
												easingFunciton:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			var x:ITweenTarget = new TargetProperty(target, "x", xFrom, xTo);
			var y:ITweenTarget = new TargetProperty(target, "y", yFrom, yTo);
			return newTweenWithTargets([x,y], duration, delay, easingFunciton, easingMod1, easingMod2);
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
		 * @param startValue The starting scale of the target. Default is AUTO_TWEEN_VALUE
		 * @param endValue The ending scale of the target. Default is AUTO_TWEEN_VALUE
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too. 
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new KSTween instance.
		 * 
		 * @since 2.0
		 */
		public static function newScaleTween(target:DisplayObject, 
											 startValue:Number = NaN, endValue:Number = NaN, 
											 duration:* = 0, delay:* = 0, 
											 easingFunciton:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			
			
			var xScale:ITweenTarget = new TargetProperty(target, "scaleX", startValue, endValue);
			var yScale:ITweenTarget = new TargetProperty(target, "scaleY", startValue, endValue);
			return newTweenWithTargets([xScale,yScale], duration, delay, easingFunciton, easingMod1, easingMod2);
		} 

		/**
		 * Creates a tween that scales x and y but with more options than newScaleTween().
		 * Note that AUTO_TWEEN_VALUE won't work correctly with this tween because it determines the x and y positioning at
		 * the time that it is created.
		 * 
		 * @example
		 * <listing version="3.0">
		 * // scale sprite from 0 to 100% from the centre of the sprite over 1 second, no delay, with Cubic ease-in-out. 
		 * TweenFactory.newScaleTweenAdvanced(
		 *		sprite, 
		 *		0, 1, 
		 *		0, 1,  
		 *		0.5, 0.5, 
		 *		1000, 0, Cubic.easeInOut)
		 * </listing>
		 * 
		 * @param target The display object whose property will be changed
		 * @param startValueX The starting scaleX of the target. 
		 * @param endValueX The ending scaleX of the target. 
		 * @param startValueY The starting scaleY of the target.
		 * @param endValueY The ending scaleY of the target. 
		 * @param centerPointX The point in the displayObject's space that will be the centerpoint of the scale. Use a percentage rather than a pixel number. Default is 0, or left.
		 * @param centerPointY The point in the displayObject's space that will be the centerpoint of the scale. Use a percentage rather than a pixel number. Default is 0, or top.
		 * @param duration The time in milliseconds that this tween will take to execute. String values are acceptable too. 
		 * @param delay The time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * @return A new KSTween instance.
		 * 
		 * @since 2.0.1
		 */
		public static function newScaleTweenAdvanced(target:DisplayObject, 
											 startValueX:Number, endValueX:Number, 
											 startValueY:Number, endValueY:Number, 
											 centerPointX:Number = 0, centerPointY:Number = 0, 
											 duration:* = 0, delay:* = 0, 
											 easingFunciton:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			
			var xScale:ITweenTarget = new TargetProperty(target, "scaleX", startValueX, endValueX);
			var yScale:ITweenTarget = new TargetProperty(target, "scaleY", startValueY, endValueY);
			
			// get natural width and height of DO.
			var w:Number = target.width / target.scaleX;
			var h:Number = target.height / target.scaleY;
			
			// get actual point in pixels.
			var centerPointPx:Point = new Point(
				(centerPointX * w),
				(centerPointY * h)
			);
			
			// FIXME: THIS IS CAUSING ERRORS beause target.x and y are being calculated at the time that the tween
			// gets created rather than when it runs. This is fine if you only ever do the scaling in a sequence of 
			// tweens but it will screw up if you tween the same object twice without creating both tweens at the same
			// time.
			var xFrom:Number = centerPointPx.x * (1 - startValueX) + target.x;// - (w * (1 - startValueX) * centerPointX);
			var xTo:Number = centerPointPx.x * (1 - endValueX)  + target.x;// - (w * (1 - startValueX) * centerPointX);
			var yFrom:Number = centerPointPx.y * (1 - startValueY)  + target.y;// - (h * (1 - startValueY) * centerPointY);
			var yTo:Number = centerPointPx.y * (1 - endValueY)  + target.y;// - (h * (1 - startValueY) * centerPointY);
			
			var x:ITweenTarget = new TargetProperty(target, "x", xFrom, xTo);
			var y:ITweenTarget = new TargetProperty(target, "y", yFrom, yTo);
			
			return newTweenWithTargets([xScale,yScale,x,y], duration, delay, easingFunciton, easingMod1, easingMod2);
		} 

		/**
		 * Creates a new KSTween using an ITweenTarget that you pass into it.
		 * 
		 * @param tweenTarget A tweenTarget object (or an array of tweenTargets) that contains the values you want to tween.
		 * @param duration The time in frames that this tween will take to execute.
		 * @param delay The time to wait before starting the tween.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * 
		 * @return A new KSTween object.
		 */
		public static function newTweenWithTargets(tweenTargets:*, 
												   duration:* = 0, delay:* = 0, 
												   easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			return new KSTween(tweenTargets, duration, delay, easingFunction, easingMod1, easingMod2);
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
		 * @param easingMod1 An optional modifier to the easing funtion.
		 * @param easingMod2 An optional modifier to the easing funtion.
		 * 
		 * @return A new KSTween object.
		 */
		public static function newFilterTween(target:DisplayObject, 
											  filter:Class, filterProperty:String, 
											  startValue:Number = NaN, endValue:Number = NaN, 
											  duration:* = 0, delay:* = 0, 
											  easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN):KSTween {
			return newTweenWithTargets (new FilterTargetProperty(target, filter, filterProperty, startValue, endValue), duration, delay, easingFunction, easingMod1, easingMod2);
		}
	}
}