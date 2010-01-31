package org.as3lib.kitchensync.action.tween
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	
	/**
	 * A color matrix tween that affects brightness.
	 * 
	 * The range of values should be between -1 (dark) and 1 (light)
	 * with a value of 0 being no adjustment to the brightness.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class BrightnessTweenTarget extends AbstractColorMatrixTweenTarget
	{
		
		/**
		 * Constructor.
		 * 
		 * @param target The do to apply the brightness to.
		 * @param startValue The beginning value for the brightness.
		 * @param endValue The end value for the brightness.
		 */
		public function BrightnessTweenTarget(target:DisplayObject, startValue:Number, endValue:Number) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
		}
		
		/**
		 * Applies the brightness to the color matrix.
		 */
		override protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			value *= 100;
			colorMatrix.adjustBrightness(value);
		}
		
		/** @inheritDoc */
		override public function clone():ITweenTarget
		{
			return new BrightnessTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}