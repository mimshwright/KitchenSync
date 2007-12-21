package com.mimswright.sync
{
	import com.mimswright.easing.EasingUtil;
	import com.mimswright.easing.Linear;
	
	/**
	 * A tween will change an object's numeric value over time.
	 * 
	 * -todo - make getters and setters for most of the properties.
	 * -todo - make target property accessable
	 */
	public class Tween extends AbstractSynchronizedAction
	{
		public static const EXISTING_FROM_VALUE:Number = Number.NEGATIVE_INFINITY;
		
		protected var _easingFunction:Function;
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ _easingFunction = easingFunction;}
		
		/** target is the object that will be affected by the tween. */
		protected var _target:Object;
		/** property is the name of the property belonging to target that will be affected by the tween. */
		protected var _property:String;
		/** 
		 * The starting value for the tween. 
		 * You can use EXISTING_FROM_VALUE to cause the tween to start from the from value at
		 * the start of the tween.
		 */
		protected var _fromValue:Number;
		
		/**
		 * The ending value for the tween.
		 */
		protected var _toValue:Number;
		
		protected var _easingMod1:Number;
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		public function get easingMod1():Number { return _easingMod1; }

		protected var _easingMod2:Number;
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		public function get easingMod2():Number { return _easingMod2; }
		
		/**
		 * Indicates whether the final value for the easing function should snap to the 
		 * target _toValue. If set to true, the target property will equal _toValue regardless
		 * of the results of the easing function.
		 * 
		 * @default true
		 */
		protected var _snapToValueOnComplete:Boolean = true;
		public function set snapToValueOnComplete(snapToValueOnComplete:Boolean):void { _snapToValueOnComplete = snapToValueOnComplete; }
		
		/**
		 * Indicates whether tweened values should snap to whole value numbers or use decimals.
		 * If set to true, the results of the easing functions on the target property will be 
		 * rounded to the nearest integer.
		 * 
		 * @default false
		 * @todo test
		 */
		protected var _snapToWholeNumber:Boolean = false;
		public function set snapToWholeNumber(snapToWholeNumber:Boolean):void {
			_snapToWholeNumber = snapToWholeNumber;
		}
		
		protected function get delta():Number {
			return _toValue - _fromValue;
		}
		protected function set value(value:Number):void {
			_target[_property] = value;
		}
		
		protected function get value():Number {
			return _target[_property];
		}
		
		/**
		 * Constructor
		 * 
		 * -todo - make all of these optional
		 * 
		 * @param target - the object whose property will be changed.
		 * @param property - the name of the property to change. Must be a numeric property such as a Sprite object's "alpha"
		 * @param toValue - the target value to tween the property to.
		 * @param fromValue - the starting value of the tween. By default, this is the value of the property before the tween.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param offset - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public function Tween(target:Object, property:String, toValue:Number, fromValue:Number = EXISTING_FROM_VALUE, duration:* = 0, offset:* = 0, easingFunction:Function = null)
		{
			super();
			_target = target;
			_property = property;
			_fromValue = fromValue;
			_toValue = toValue;
			
			this.duration = duration;
			this.offset = offset;
			
			if (easingFunction != null) { _easingFunction = easingFunction; } else { _easingFunction = Linear.ease; }
		}
		
		/**
		 * Stops the tween and sets the target property to the start value.
		 */
		public function reset():void {
			stop();
			value = _fromValue;
		}
		
		/**
		 * Executes the tween.
		 * 
		 * -todo - make snapping to the final value optional.
		 */
		override protected function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			var timeElapsed:int;
			var convertedDuration:int;
			if (startTimeHasElapsed) {
				if (_sync) {
			 		timeElapsed = time.currentTime - _startTime.currentTime - convertToMilliseconds(_offset);
			 		convertedDuration = convertToMilliseconds(duration);		 				 		
			 	} else {
			 		timeElapsed = time.currentFrame - _startTime.currentFrame - convertToFrames(_offset);
			 		convertedDuration = convertToFrames(duration);
			 	}
				//timeElapsed = time.currentFrame - _startTime.currentFrame - _offset;
				if (_fromValue == EXISTING_FROM_VALUE && timeElapsed <= 1) { 
					_fromValue = value; 
				} 
				var result:Number =  EasingUtil.call(_easingFunction, timeElapsed, convertedDuration, _easingMod1, _easingMod2) * delta + _fromValue; 
				if (_snapToWholeNumber) { result = Math.round(result); }
				
				value = result;
				//trace(result, time);
				if (durationHasElapsed) {
					// if snapToValue is set to true, the target property will be set to the target value 
					// regardless of the results of the easing function.
					if (_snapToValueOnComplete) { value = _toValue; }
					complete();
				}
			}
		}
		
		/**
		 * Creates a new Tween and reverses the start and end values of the target property.
		 * 
		 * @use <code>
		 * 			var tween:Tween = new Tween(foo, "x", 100, 200);
		 * 			var sequence:Sequence = new Sequence(
		 * 				tween,							// tweens foo's x from 100 to 200
		 * 				tween.cloneReversed()			// tweens foo's x from 200 to 100
		 * 				tween.cloneReversed(bar)		// tweens bar's x from 200 to 100
		 * 				tween.cloneReversed(foo, y)		// tweens foo's y from 200 to 100
		 * 			);
		 * 		</code>
		 * 
		 * @see #cloneWithTarget()
		 * @see #reverse()
		 * 
		 * @param target - The optional target object of the new Tween
		 * @param property - The optional property to tween with the new Tween. 
		 * @returns Tween - A new Tween identical to this but with start and end reversed.
		 */
		public function cloneReversed(target:Object = null, property:String = null):Tween {
			var clone:Tween = Tween(cloneWithTarget(target, property));
			clone.reverse();
			return clone;
		}
		
		/**
		 * Flips the values for to and from values. Essentially, causes the animation to run backwards.
		 * 
		 * @see #cloneReversed()
		 */
		public function reverse():void {
			var temp:Number = _fromValue;
			_fromValue = _toValue;
			_toValue = temp;						
		}
		
		
		/**
		 * Creates a copy of this Tween which targets a different object and / or property.
		 * This is mostly used as a convenient way to reuse a tween, e.g. in a sequence.
		 * 
		 * @use <code>
		 *		var tween:Tween = new Tween(foo, "x", 100, 200);
		 *		var sequence:Sequence = new Sequence(
		 *			tween,							// tweens foo's x property from 100 to 200
		 *			tween.cloneWithTarget(bar),		// tweens bar's x property from 100 to 200
		 *			tween.cloneWithTarget(foo, y)	// tweens foo's y property from 100 to 200
		 *			tween.cloneWithTarget(bar, y)	// tweens bar's y property from 100 to 200
		 *		);
		 *	</code>
		 * 
		 * @see #clone()
		 * 
		 * @param target - The new object to target. Defaults to the same target as this.
		 * @param property - The new target object's property to target. Defaults to the same property as this.
		 * @return Tween - a copy of this tween with a new target/property.
		 */
		public function cloneWithTarget(target:Object = null, property:String = null):Tween {
			var clone:Tween = Tween(this.clone());
			if (target)		{ clone._target = target; }
			if (property) 	{ clone._property = property; }
			return clone;
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:Tween = new Tween(_target, _property, _toValue, _fromValue, _duration, _offset, _easingFunction);
			clone._timeUnit = _timeUnit;
			clone._easingMod1 = _easingMod1;
			clone._easingMod2 = _easingMod2;
			clone.autoDelete = _autoDelete;
			clone.snapToValueOnComplete = _snapToValueOnComplete;
			clone.snapToWholeNumber = _snapToWholeNumber;
			return clone;
		}
		
		/**
		 * Clean up references to target
		 */
		override public function kill():void {
			super.kill();
			_target = null;
		}
		
		/**
		 * Returns either the _id or a description of the tween.
		 */
		override public function toString():String {
			return "Tween " + _target + "." + _property + "=" + _fromValue + "~" + _toValue;
		}
	}
}