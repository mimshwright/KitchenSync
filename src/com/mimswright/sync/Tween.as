package com.mimswright.sync
{
	import com.mimswright.easing.Linear;
	import flash.display.FrameLabel;
	import com.mimswright.easing.EasingUtil;
	
	/**
	 * A tween will change an object's numeric value over time.
	 * 
	 * @TODO - make getters and setters for most of the properties.
	 */
	public class Tween extends AbstractSynchronizedAction
	{
		protected var _easingFunction:Function;
		protected var _target:Object;
		protected var _property:String;
		protected var _fromValue:Number;
		protected var _toValue:Number;
		
		protected var _easingMod1:Number;
		protected var _easingMod2:Number;
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		public function get easingMod1():Number { return _easingMod1; }
		public function set overshoot(overshoot:Number):void { _easingMod1 = overshoot; }
		public function get overshoot():Number { return _easingMod1; }
		public function set amplitude(amplitude:Number):void { _easingMod1 = amplitude; }
		public function get amplitude():Number { return _easingMod1; }
		public function set period(period:Number):void { _easingMod2 = period; }
		public function get period():Number { return _easingMod2; }
		
		protected function get _delta():Number {
			return _toValue - _fromValue;
		}
		protected function set _targetProperty(value:Number):void {
			_target[_property] = value;
		}
		protected function get _targetProperty():Number {
			return _target[_property];
		}
		public function get targetProperty():Number {
			return _target[_property];
		}
		
		/**
		 * Constructor
		 * 
		 * @todo - make all of these optional
		 * 
		 * @param target - the object whose property will be changed.
		 * @param property - the name of the property to change. Must be a numeric property such as a Sprite object's "alpha"
		 * @param fromValue - the starting value of the tween. By default, this is the value of the property before the tween.
		 * @param toValue - the target value to tween the property to.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param offset - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public function Tween(target:Object, propterty:String, fromValue:Number, toValue:Number, duration:int = 0, offset:int = 0, easingFunction:Function = null)
		{
			super();
			_target = target;
			_property = propterty;
			_fromValue = fromValue;
			_toValue = toValue;
			if (isNaN(_fromValue)) { _fromValue = targetProperty; }
			_duration = duration;
			_offset = offset;
			if (easingFunction != null) { _easingFunction = easingFunction; } else { _easingFunction = Linear.easeIn; }
		}
		
		/**
		 * Executes the tween.
		 */
		override internal function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (_startTimeHasElapsed) {
				var timeElapsed:int = time.currentFrame - _startTime.currentFrame - _offset;
				var result:Number =  EasingUtil.call(_easingFunction, timeElapsed, _duration, _easingMod1, _easingMod2) * _delta + _fromValue; 
				
				_targetProperty = result;

				if (_durationHasElapsed) {
					if (_targetProperty != _toValue) { _targetProperty = _toValue; }
					complete();
				}
			}
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
			if (_id) { return _id; }
			return "Tween " + _target + "." + _property + "=" + _fromValue + "~" + _toValue;
		}
	}
}