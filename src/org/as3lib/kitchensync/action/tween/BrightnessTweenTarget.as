package org.as3lib.kitchensync.action.tween
{
	import com.gskinner.geom.ColorMatrix;
	
	import flash.display.DisplayObject;
	
	public class BrightnessTweenTarget extends AbstractColorMatrixTweenTarget
	{
		
		public function BrightnessTweenTarget(target:DisplayObject, startValue:Number, endValue:Number) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
		}
		
		override protected function adjustMatrixValue(colorMatrix:ColorMatrix, value:Number):void {
			colorMatrix.adjustBrightness(value);
		}
		
		override public function clone():ITweenTarget
		{
			return new BrightnessTweenTarget(_target, _startValue, _endValue);
		}
		
	}
}