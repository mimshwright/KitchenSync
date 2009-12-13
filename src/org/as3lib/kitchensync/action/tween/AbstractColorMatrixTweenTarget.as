package org.as3lib.kitchensync.action.tween
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	import org.as3lib.utils.AbstractEnforcer;
	
	// todo: consider switching to http://www.quasimondo.com/archives/000671.php
	
	/**
	 * A type of tween target that uses a ColorMatrixFilter (using the ColorMatrix
	 * object from Grant Skinner). This class is used as a base for other tween targets
	 * that adjust individual properties such as saturation or brightness.   
	 * 
	 * @abstract
	 * 
	 * @see http://www.gskinner.com/blog/archives/2007/12/colormatrix_upd.html
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class AbstractColorMatrixTweenTarget implements IFilterTweenTarget
	{

		/**
		 * @inheritDoc
		 * The filter type for all of the ColorMatrix TweenTargets is ColorMatrixFilter.
		 */
		public function get filterType():Class {
			return ColorMatrixFilter;
		}
		
		/** @inheritDoc */
		public function get currentValue():Number { return _currentValue; }
		public function set currentValue(currentValue:Number):void {
			var newFilters:Array = [];
			_colorMatrix = new ColorMatrix();
			
			// apply the transformation to the matrix. this method will 
			// be defined in the subclasses.
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
		 * This is the function that applies the transformation to the matrix by
		 * calling the proper adjust method on the ColorMatrix class. 
		 * 
		 * This funciton is defined in child classes. 
		 */ 
		protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			AbstractEnforcer.enforceMethod();
		}
		
		protected var _currentValue:Number = 0;
		protected var _target:DisplayObject;
		protected var _colorMatrix:ColorMatrix;
		
		/** Shortcut to the list of display object filters. */
		protected function get filters ():Array {
			if (_target != null) { return _target.filters; }
			return null;
		}
		protected function set filters (filters:Array):void { 
			if (_target != null) { _target.filters = filters; }
			else { throw new Error("The target must be defined before setting filters"); }
		}
		
		
		
		/** @inheritDoc */		
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		/** @inheritDoc */		
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void	{ _endValue = endValue; }
		protected var _endValue:Number;
		
		
		/** 
		 * Constructor. 
		 * @abstract
		 */
		public function AbstractColorMatrixTweenTarget()
		{
			AbstractEnforcer.enforceConstructor(this, AbstractColorMatrixTweenTarget);
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
		
		/** @inheritDoc */
		public function reset():void {
			currentValue = startValue;
		}
		
		/** 
		 * @inheritDoc 
		 * @abstract 
		 */
		public function clone():ITweenTarget
		{
			AbstractEnforcer.enforceMethod();
			return null;
		}
		
	}
}