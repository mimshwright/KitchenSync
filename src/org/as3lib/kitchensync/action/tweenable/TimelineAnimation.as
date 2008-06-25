package org.as3lib.kitchensync.action.tweenable
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	// TODO add documentation.
	// TODO add option for gotoAndPlay?
	/**
	 * A Tweenable that controls a timeline animation in a MovieClip.
	 * 
	 * @since 1.3
	 * @author Mims Wright
	 */
	public class TimelineAnimation implements ITweenable
	{
		
		public function get currentValue():Number {
			if (target != null) {
				return _target.currentFrame;
			} else {
				throw new Error("Target MovieClip is not set. Cannot return the current value.");
			}
		}
		public function set currentValue(currentValue:Number):void {
			if (target != null) {
				// normalize the frame between 1 and the last frame before setting.
				var frame:int = int(currentValue);
				frame = Math.min(Math.max(frame, 1), _target.totalFrames);
				
				// goto the frame.
				target.gotoAndStop(frame);
			} else {
				throw new Error("You must set the target before changing the current value");
			}
		}
		
		public function get startValue():Number { return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = int(startValue); }
		protected var _startValue:int = 1;
		
		public function get endValue():Number { return _endValue; }
		public function set endValue(endValue:Number):void { _endValue = int(endValue); }
		protected var _endValue:int;
		
		public function get target():MovieClip { return _target; }
		public function set target(target:MovieClip):void { 
			_target = target; 
			// TODO make this optional.
			_target.stop();
		} 
		protected var _target:MovieClip;
		
		public function TimelineAnimation(target:MovieClip, startFrame:Object = null, endFrame:Object = null) {
			this.target = target;
				
			if (startFrame == null) {
				// startValue will default to the first frame of the movie.
				this.startValue = 1;
			} else {
				this.startValue = evaluateFrameLabel(startFrame);
			}
			
			if (endFrame == null) {
				// endValue will default to the last frame of the movie.
				this.endValue = _target.totalFrames;
			} else {
				this.endValue = evaluateFrameLabel(endFrame);
			}
		}
		
		protected function evaluateFrameLabel(frameLabel:Object):int {
			if (frameLabel is FrameLabel) {
				return FrameLabel(frameLabel).frame;
			} else if (frameLabel is String) {
				return getFrameNumberFromString(String(frameLabel));
			} else if (frameLabel is Number || frameLabel is int || frameLabel is uint) {
				return int(frameLabel);
			}
			throw new ArgumentError("The 'frameLabel' parameter must be one of the following types: int, uint, Number, FrameLabel, String");
		}

		// todo Move this to a utility function.
		protected function getFrameNumberFromString(matchLabel:String):int {
			var labelList:Array = _target.currentLabels;
			var l:int = labelList.length;
			var label:FrameLabel;
			for (var i:int = 0; i < l; i++) {
				label = FrameLabel(labelList[i]);
				if (label.name == matchLabel) {
					return label.frame;
				}
			}
			throw new Error("Invalid label name. The target MovieClip does not contain this label.");
		}

		public function updateTween(percentComplete:Number):Number {
			return currentValue = percentComplete * differenceInValues + _startValue;
		}
		
		/**
		 * The total amount of change between the start and end values. (used internally)
		 */
		public function get differenceInValues():Number { return _endValue - _startValue; }
		
		
		public function reset():void {
			currentValue = _startValue;
		}
		
		public function clone():ITweenable {
			return new TimelineAnimation(_target, _startValue, _endValue);
		}
	}
}