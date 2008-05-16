
/**
* Benchmark test for use with Moses Gunesch's Go benchmark tester. http://go.mosessupposes.com/?p=5 
* To use this class, you'll need to download the appropriate files from the google code site 
* http://code.google.com/p/goasap/
*/ 
package org.as3lib.kitchensync.test {	
	import flash.display.*;	
	import flash.events.*;	
	
	import com.mosesSupposes.benchmark.*;	
	import com.mosesSupposes.benchmark.tweenbencher.*;
	import com.mosesSupposes.benchmark.tweenbencher.tests.*;
	
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.easing.*;
	
	//	import fl.motion.easing.Exponential; // standard easing function for benchmarks
	
	/**
	 * @author Moses Gunesch / mosessupposes.com (c) 
	 */
	public class KitchenSyncBenchmark extends BenchmarkBase {
		
		public var syncMode:Boolean;
		
		public function KitchenSyncBenchmark(tweenBencher : TweenBencher, name:String = "KitchenSync") 
		{
			super(tweenBencher, name);
			syncMode = false;	
		}

		/**
		 * Mandatory: Override this method to add a tween to the target passed in.
		 * Tween should be - width:760 tween, delay:0, duration:tweenDuration (var is above!), ease Exponential.easeInOut.
		 * 
		 * @param target			The tween target
		 * @param CurrentTime		Not usually needed. The getTimer() clock time when the tween-adding loop starts.
		 * @param firstInNewSet		True if the target is the first in any new test cycle.
		 */
		public override function addTween(target:Sprite, firstInNewSet:Boolean):void
		{
			// each tween fires onMotionEnd on completion.
			var tween:KSTween = new KSTween (target, "width", 760, 0, tweenDuration * 1000, 0, Exponential.easeInOut);
			tween.sync = syncMode;
			tween.addEventListener(KitchenSyncEvent.COMPLETE, onMotionEnd);
			tween.start();
		}
		
		/**
		 * Important! Subclasses MUST call super.onMotionEnd(), so _bencher can do its thing.
		 * Each tween added must trigger this event/callback as it completes. 
		 * Unsubscribe all listeners on the tween here.
		 */
		protected override function onMotionEnd(event:Event=null):void
		{
			
			// This line is mandatory!
			super.onMotionEnd(event);
		}
		
		// -== Optional ==-
		
		/**
		 * Optional - Event is fired when all cycles of the benchmark test are complete.
		 * 
		 * @param event				BenchmarkEvent contains params: benchDescription, fpsResults, startLagResults, timedOut.
		 * @see BenchmarkEvent
		 */ 
		protected override function onBenchmarkComplete(event:BenchmarkEvent) : void {
			// no action necessary
		}
		
/* ALSO IN SUPER (no need to subclass these)
		
		 /**
		 * Optional - Provided as a convenience for subclasses.
		 * Dispatching events (start, update, and end) often affects tween engine performance.
		 * To test how much, subscribe events to this handler, which should remain empty.
		 * /
		protected function anEvent(event:Event=null):void
		
		/**
		 * Sends values to output window.
		 * /
		public function dump() : void
*/
	}
}
