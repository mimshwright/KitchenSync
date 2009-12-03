package org.as3lib.kitchensync.action.tween
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	/**
	 * A tween target that targets a property of a BitmapFilter object. 
	 * For example, you may target the "blurX" property of a BlurFilter on a 
	 * particular movieClip.
	 * 
	 * Tweens will be applied to the filter class rather than the individual filter
	 * objects because in order for the filter to be applied to the display object, 
	 * the array of filters must be rewritten on each update.
	 * 
	 * @author Mims H. Wright
	 * @since 1.5 
	 */ 
	// todo change this to accept either a class or an instance of a filter.
	// todo review
	public class FilterTargetProperty implements IFilterTweenTarget
	{
		/**
		 * The object containing the filter property you want to tween. 
		 */
		public function get target():DisplayObject { return _target; }
		protected var _target:DisplayObject;
		
		/** 
		 * The class for the filter to target. 
		 */
		public function get filterType():Class { return _filterType; }
		protected var _filterType:Class;
		
		/**
		 * The string name of the property of the target object that you want to tween.
		 */
		public function get property():String { return _property; }
		protected var _property:String;
		
		/**
		 * @inheritDoc
		 */ 
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		/**
		 * @inheritDoc
		 */		
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void	{ _endValue = endValue; }
		protected var _endValue:Number;
		
		/**
		 * The total amount of change between the start and end values. (used internally)
		 */
		public function get differenceInValues():Number { return _endValue - _startValue; }
		
		/**
		 * Constructor.
		 * 
		 * @param target The display object that will receive the filter.
		 * @param filterType The Class of the filter you're targeting.
		 * @param property The name of the numeric property to tween.
		 * @param startValue The value to start from when tweening.
		 * @param endValue The value to end on when tweening.
		 */
		public function FilterTargetProperty (target:DisplayObject, filterType:Class, property:String, startValue:Number = NaN, endValue:Number = NaN) {
			_target = target;
			_filterType = filterType;
			_property = property;
			_startValue = (isNaN(startValue)) ? currentValue : startValue;
			_endValue   = (isNaN(endValue))   ? currentValue : endValue;
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
			return currentValue = percentComplete * differenceInValues + startValue;
		}
		
		/** @inheritDoc */
		public function get currentValue():Number { return Number(_previousFilter[property]); }
		public function set currentValue(currentValue:Number):void { 
			var newFilters:Array = [];
			
			// if the previous filter array contains any filters
			if (filters && filters.length > 0) {
				// pull in all the old filters except the one added previously.
				for each (var filter:BitmapFilter in filters) {
					if (filter is _filterType) {
						_previousFilter = filter;
					} else {
						newFilters.push(filter);
					}
				}
			}
			
			var newFilter:BitmapFilter = _previousFilter == null ? getDefaultFilter(_filterType) : _previousFilter;
			newFilter[_property] = currentValue;
			
			// add the newFilter
			newFilters.push(newFilter);

			// apply the filters
			filters = newFilters;
			// save the previous filter.
			_previousFilter = newFilter;
		}
		protected var _previousFilter:BitmapFilter = null;
		
		
		/** 
		 * The array of filters currently being applied to the target.
		 */ 
		protected function get filters ():Array {
			if (_target != null) { return _target.filters; }
			return null;
		}
		protected function set filters (filters:Array):void { 
			if (_target != null) { _target.filters = filters; }
			else { throw new Error("The target must be defined before setting filters"); }
		}
		
		
		/**
		 * Returns a default instance of the filterType.
		 * 
		 * @param filterType The class of the filter to get.
		 * @return BitmapFilter The default instance of a new filter (of type filterType).
		 */		
		protected function getDefaultFilter(filterType:Class):BitmapFilter { 
			var emptyFilter:BitmapFilter = BitmapFilter(new filterType());
			return emptyFilter;
		}
		
		/** @inheritDoc */
		public function reset():void
		{
			currentValue = startValue;
		}
		
		/** @inheritDoc */
		public function clone():ITweenTarget
		{
			return new FilterTargetProperty(_target, _filterType, _property, _startValue, _endValue);
			
		}
		
	}
}