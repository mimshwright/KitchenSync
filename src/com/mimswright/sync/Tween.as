package com.mimswright.sync
{
	import com.mimswright.easing.EasingUtil;
	import com.mimswright.easing.Linear;
	
	/**
	 * A tween will change an object's numeric value over time.
	 * 
	 * -todo - make getters and setters for most of the properties.
	 */
	public class Tween extends AbstractSynchronizedAction
	{
		protected var _easingFunction:Function;
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ _easingFunction = easingFunction;}
		
		protected var _target:Object;
		protected var _property:String;
		protected var _fromValue:Number;
		protected var _toValue:Number;
		
		protected var _easingMod1:Number;
		protected var _easingMod2:Number;
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		public function get easingMod1():Number { return _easingMod1; }
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		public function get easingMod2():Number { return _easingMod2; }
		
		protected var _snapToValue:Boolean = true;
		public function set snapToValue(snapToValue:Boolean):void { _snapToValue = snapToValue; }
		
		protected function get delta():Number {
			return _toValue - _fromValue;
		}
		protected function set targetProperty(value:Number):void {
			_target[_property] = value;
		}
		
		protected function get targetProperty():Number {
			return _target[_property];
		}
		
		/**
		 * Constructor
		 * 
		 * -todo - make all of these optional
		 * 
		 * @param target - the object whose property will be changed.
		 * @param property - the name of the property to change. Must be a numeric property such as a Sprite object's "alpha"
		 * @param fromValue - the starting value of the tween. By default, this is the value of the property before the tween.
		 * @param toValue - the target value to tween the property to.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param offset - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public function Tween(target:Object, property:String, fromValue:Number, toValue:Number, duration:int = 0, offset:int = 0, easingFunction:Function = null)
		{
			super();
			_target = target;
			_property = property;
			_fromValue = fromValue;
			_toValue = toValue;
			if (isNaN(_fromValue)) { _fromValue = targetProperty; }
			_duration = duration;
			_offset = offset;
			if (easingFunction != null) { _easingFunction = easingFunction; } else { _easingFunction = Linear.ease; }
		}
		
		/**
		 * Executes the tween.
		 * 
		 * -todo - make snapping to the final value optional.
		 */
		override internal function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed) {
				var timeElapsed:int = time.currentFrame - _startTime.currentFrame - _offset;
				var result:Number =  EasingUtil.call(_easingFunction, timeElapsed, _duration, _easingMod1, _easingMod2) * delta + _fromValue; 
				
				targetProperty = result;

				if (durationHasElapsed) {
					// if snapToValue is set to true, the target property will be set to the target value 
					// regardless of the results of the easing function.
					if (_snapToValue) { targetProperty = _toValue; }
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
			var clone:Tween = new Tween(_target, _property, _fromValue, _toValue, _duration, _offset, _easingFunction);
			clone._easingMod1 = _easingMod1;
			clone._easingMod2 = _easingMod2;
			clone.autoDelete = _autoDelete;
			clone.snapToValue = _snapToValue;
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