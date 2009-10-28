package org.as3lib.kitchensync.utils
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.as3lib.kitchensync.core.ISynchronizerClient;
	import org.as3lib.kitchensync.core.Synchronizer;

	/**
	 * A text field that displays the approximate framerate of the synchronizer.
	 * Setting the updateFrequency property will allow you to adjust how often
	 * the display is updated. You can also decide whether to show the average or 
	 * instantaneous framerate.
	 * This class extends TextField so you can add it to the display list, apply 
	 * text formatting and use it as you would a TextField.
	 * 
	 * @example 
	 * 		<listing version="3.0">
	 * 			// create the view.
	 * 			public var frameRateView:TextField = new SynchronizerFrameRateView();
	 * 			// set the display to the average frame rate. (optional)
	 * 			frameRateView.useAverageFrameRate = true;
	 * 			// change the frequency of updates to 1 every 10 frames. (optional)
	 * 			frameRateView.updateFrequency = 10;
	 * 			// apply text formatting  (optional)
	 * 			frameRateView.textFormat = myTextFormat;
	 * 			// add the view to the displayList
	 * 			addChild(frameRateView);  
	 * 		</listing>
	 * 
	 * @see org.as3lib.kitchensync.core.Synchronizer
	 * @see org.as3lib.kitchensync.utils.FrameRateUtil
	 * @author Mims H. Wright
	 * @since 1.5
	 */
	public class FrameRateView extends TextField implements ISynchronizerClient
	{
		/** 
		 * Number of frames between each update.
		 * The default value is set to the average
		 * set the update frequency to 1. 
		 */
		public function get updateFrequency():int { return _updateFrequency; }
		public function set updateFrequency(updateFrequency:int):void { _updateFrequency = Math.max(updateFrequency, 1); }
		private var _updateFrequency:int = 5;
		
		/**
		 * Determines whether to show the average frame rate or
		 * the instantaneous frame rate. 
		 * Default is instantaneous frame rate.
		 */
		public var useAverageFrameRate:Boolean = false;
		
		/** The number currently shown in the display. */
		public function get value():int { return _value; }
		private var _value:int = 0;
		
		/** Constructor */
		public function FrameRateView()
		{
			super();
			this.autoSize = TextFieldAutoSize.LEFT;
			
			Synchronizer.getInstance().registerClient(this);
		}
		
		/** 
		 * The function used to format the text displayed in the textfield. 
		 * This can be replaced by the user.
		 */
		public var formattingFunction:Function = function (frameRate:int):String {
			return frameRate.toString() + " FPS";
		};
		
		
		/**
		 * Display is updated by the synchronizer pulses.
		 */
		public function update(currentTime:int):void {
			if (Synchronizer.getInstance().cycles % updateFrequency == 0) {
				if (useAverageFrameRate) {
					_value = FrameRateUtil.getInstance().averageFrameRate;
				} else {
					_value = FrameRateUtil.getInstance().instantaneousFrameRate;
				}
				this.text = formattingFunction(_value);
			}
		}
	}
}