package org.as3lib.kitchensync.action.tweentarget
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	import org.as3lib.utils.AbstractEnforcer;
	
	public class AbstractColorMatrixTweenTarget implements IFilterTweenTarget
	{

		public function get filterType():Class {
			return ColorMatrixFilter;
		}
		
		public function get currentValue():Number { return _currentValue; }
		public function set currentValue(currentValue:Number):void {
			var newFilters:Array = [];
			_colorMatrix = new ColorMatrix();
			adjustMatrixValue(_colorMatrix, currentValue);
			
			// if the previous filter array contains any filters
			if (filters && filters.length > 0) {
				// pull in all the old filters except the one added previously.
				for each (var filter:BitmapFilter in filters) {
					if (!(filter is filterType)) {
						newFilters.push(filter);
					}
				}
			}
			
			// add the newFilter
			newFilters.push(new ColorMatrixFilter(_colorMatrix));

			// apply the filters
			filters = newFilters;
			
			_currentValue = currentValue;
		}
		/** 
		 * This funciton is defined in child classes. 
		 */ 
		protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			AbstractEnforcer.enforceMethod();
		}
		
		protected var _currentValue:Number = 0;
		protected var _target:DisplayObject;
		protected var _colorMatrix:ColorMatrix;
		
		protected function get filters ():Array {
			if (_target != null) { return _target.filters; }
			return null;
		}
		protected function set filters (filters:Array):void { 
			if (_target != null) { _target.filters = filters; }
			else { throw new Error("The target must be defined before setting filters"); }
		}
		
		
		
		/**
		 * The value to start from when tweening.
		 */ 
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		/**
		 * The value to end on when tweening.
		 */		
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void	{ _endValue = endValue; }
		protected var _endValue:Number;
		
		
		public function AbstractColorMatrixTweenTarget()
		{
		}
		
		
		/**
		 * The main function that the Tween uses to update the TweenTarget. 
		 * Sets the percentage complete.
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update
		 * @return Number the new current value of the tween.
		 */
		public function updateTween(percentComplete:Number):Number {
			return currentValue = percentComplete * (endValue - startValue) + startValue;
		}
		
		
		public function reset():void {
			currentValue = startValue;
		}
		
		public function clone():ITweenTarget
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
	}
}