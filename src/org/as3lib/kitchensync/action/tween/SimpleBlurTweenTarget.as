package org.as3lib.kitchensync.action.tween
{
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	
	/**
	 * A simplified version of the Blur filter tween target. This target
	 * allows you to easily adjust a blur's x and y values with a single class.
	 * 
	 * @example <listing version="3.0">
	 * var sprite:Sprite;
	 * // add graphics and add sprite to stage...
	 * 
	 * // create a focus in blur tween that blurs from 5 px to 0 over 3 seconds. 
	 * var blurTween:KSTween = TweenFactory.newTweenWithTargets(new SimpleBlurTweenTarget(sprite, 5, 0), "3s");
	 * blurTween.start();
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 */
	public class SimpleBlurTweenTarget implements IFilterTweenTarget
	{
		/** @inheritDoc */
		public function get currentValue():Number { return _blurXTweenTarget.currentValue; }
		public function set currentValue(currentValue:Number):void { 
			_blurXTweenTarget.currentValue = currentValue;
			_blurYTweenTarget.currentValue = currentValue;
		}
		
		/** @inheritDoc */
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		/** @inheritDoc */
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void { _endValue = endValue; }
		protected var _endValue:Number;
		
		/** The display object whose blur to affect. */
		public function get target():DisplayObject { return _target; }
		public function set target(target:DisplayObject):void { _target = target; }
		protected var _target:DisplayObject;
		
		/** @inheritDoc */
		public function get filterType():Class { return BlurFilter; }
		
		/**
		 * Constructor.
		 * 
		 * @param target The display object whose blur to adjust.
		 * @param startValue The starting value of the blur. Applied to both blurX and blurY properties.
		 * @param endValue The ending value of the blur.
		 */
		public function SimpleBlurTweenTarget(target:DisplayObject, startValue:Number, endValue:Number = 0) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
			
			_blurXTweenTarget = new FilterTargetProperty(target, BlurFilter, "blurX", _startValue, _endValue);
			_blurYTweenTarget = new FilterTargetProperty(target, BlurFilter, "blurY", _startValue, _endValue);
		}
		
		/** Tween target for adjusting the x property. */
		protected var _blurXTweenTarget:FilterTargetProperty;
		/** Tween target for adjusting the y property. */
		protected var _blurYTweenTarget:FilterTargetProperty;

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
			currentValue = _startValue;
		}
		
		/** @inheritDoc */
		public function clone():ITweenTarget {
			return new SimpleBlurTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}