package org.as3lib.kitchensync.action.tween
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	
	/**
	 * A color matrix tween that affects saturation.
	 * 
	 * The range of values should be between -1 (greyscale) and 1 (full saturation)
	 * with a value of 0 being no adjustment to the saturation.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class SaturationTweenTarget extends AbstractColorMatrixTweenTarget
	{
		
		/**
		 * Constructor.
		 * 
		 * @param target The do to apply the saturation to.
		 * @param startValue The beginning value for the saturation. From -1 to 1
		 * @param endValue The end value for the saturation.
		 */
		public function SaturationTweenTarget(target:DisplayObject, startValue:Number, endValue:Number) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
		}
		
		/**
		 * Applies the saturation to the color matrix.
		 */
		override protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			value *= 100;
			colorMatrix.adjustSaturation(value);
		}
		
		/** @inheritDoc */
		override public function clone():ITweenTarget
		{
			return new SaturationTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}