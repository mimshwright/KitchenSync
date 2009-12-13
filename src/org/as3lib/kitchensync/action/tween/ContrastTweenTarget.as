package org.as3lib.kitchensync.action.tween
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	
	/**
	 * A color matrix tween that affects contrast.
	 * 
	 * The range of values should be between -100 (low contrasst) and 100 (high contrast)
	 * with a value of 0 being no adjustment to the contrast.
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class ContrastTweenTarget extends AbstractColorMatrixTweenTarget
	{
		
		/**
		 * Constructor.
		 * 
		 * @param target The DO to apply the contrast to.
		 * @param startValue The beginning value for the contrast.
		 * @param endValue The end value for the contrast.
		 */
		public function ContrastTweenTarget(target:DisplayObject, startValue:Number, endValue:Number) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
		}
		
		/**
		 * Applies the contrast to the color matrix.
		 */
		override protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			colorMatrix.adjustContrast(value);
		}
		
		/** @inheritDoc */
		override public function clone():ITweenTarget
		{
			return new ContrastTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}