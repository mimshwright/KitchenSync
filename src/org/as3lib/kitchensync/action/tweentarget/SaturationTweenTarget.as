package org.as3lib.kitchensync.action.tweentarget
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	
	public class SaturationTweenTarget extends AbstractColorMatrixTweenTarget
	{
		
		public function SaturationTweenTarget(target:DisplayObject, startValue:Number, endValue:Number) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
		}
		
		override protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			colorMatrix.adjustSaturation(value);
		}
		
		override public function clone():ITweenTarget
		{
			return new SaturationTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}