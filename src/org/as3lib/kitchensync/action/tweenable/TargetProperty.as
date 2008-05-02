package org.as3lib.kitchensync.action.tweenable
{
	public class TargetProperty implements ITweenable
	{
		protected var _target:Object;
		public function get target():Object { return _target; }
		
		protected var _property:String;
		public function get property():Object { return _property; }
		
		public function setTargetPropterty(target:Object, property:String):void {
			if (target[property] is Number) {
				_target = target;
				_property = property;
			} else {
				throw new Error ("The 'property' of the object 'target' must be a Number, int, or uint.");
			}
		}
		
		public function set currentValue(currentValue:Number):void{
			if (_target && _property) {
				if (_useSnapping) { currentValue = Math.round(currentValue); }
				_target[_property] = currentValue;
			} else {
				throw new Error ("Target and Property must both be defined before setting the value.");
			}
		}
		public function get currentValue():Number {
			return _target[_property];
		}
		
		protected var _startValue:Number;
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		public function get startValue():Number	{ return _startValue; }
		
		protected var _endValue:Number;
		public function set endValue(endValue:Number):void	{ _endValue = endValue; }
		public function get endValue():Number {	return _endValue; }
		
		protected var _useSnapping:Boolean = false;
		public function get useSnapping():Boolean { return _useSnapping; }
		public function set useSnapping(useSnapping:Boolean):void { _useSnapping = useSnapping; }
		
		public function TargetProperty (target:Object, property:String, startValue:Number = NaN, endValue:Number = NaN) {
			setTargetPropterty(target, property);
			_startValue = (isNaN(startValue)) ? currentValue : startValue;
			_endValue   = (isNaN(endValue))   ? currentValue : endValue;
		}
	}
}