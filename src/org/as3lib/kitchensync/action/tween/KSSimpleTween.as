package org.as3lib.kitchensync.action.tween
{	
	import flash.events.EventDispatcher;
	
	import org.as3lib.kitchensync.action.IAction;
	import org.as3lib.kitchensync.action.IPrecisionAction;
	import org.as3lib.kitchensync.core.KitchenSyncEvent;
	import org.as3lib.kitchensync.core.Synchronizer;
	import org.as3lib.kitchensync.easing.EasingUtil;
	import org.as3lib.kitchensync.easing.Linear;

	
	/**
	 * A simplified version of the KSTween class with NO bells or whistles. Designed for optimized performance,
	 * file size, and minimal memory use. 
	 * The behaviour of a simple tween is similar to that of the KSTween class with a TargetProperty tween target. 
	 * 
	 * @example
	 * <listing version="3.0">
	 * // This example will tween the 'x' property of a sprite from 0 to 500 px over the course of
	 * // 3 seconds with a 1 second delay.
	 * 
	 * var sprite:Sprite = new Sprite(); // this is the object whose property you want to control.
	 * var property:String = "x"; // A string representing the name of the property to control.
	 * var startValue:int = 0, endValue:int = 500;
	 * var duration:int = 3000, delay:int = 1000;  
	 * var easingProperty:Funciton = Cubic.easeOut;
	 * var tween:IAction = new SimpleTween(target, property, startValue, endValue, duration, delay, easingFunction);
	 * tween.start();
	 * 
	 * //Note, this class has 0 references to other classes except when running so it will be garbage collected
	 * //when it is finished playing if there are no other references to it. To create an auto-deleting, anonymouse 
	 * // version, use the following syntax:
	 * new SimpleTween(target, property, 0, 500, 3000, 1000, Cubic.easeOut).start();
	 * </listing>
	 * 
	 * @see org.as3lib.kitchensync.action.KSTween;
	 * @see org.as3lib.kitchensync.easing;
	 * @author Mims Wright
	 * @since 1.6
	 */
	public class KSSimpleTween extends EventDispatcher implements ITween
	{
		/** 
		 * Duration of tween, not including delay, in milliseconds.
		 * Note: despite the * type (required by the IAction interface), this setter will
		 * only accept numeric values. 
		 */ 
		public function get duration():int { return _duration; }
		public function set duration(duration:*):void { _duration = int(duration); }
		protected var _duration:int = 0;
		
		/** 
		 * delay before the animation begins in milliseconds. 
		 * Note: despite the * type (required by the IAction interface), this setter will
		 * only accept numeric values. 
		 */
		public function get delay():int { return _delay; }
		public function set delay(delay:*):void { _delay = int(delay); }
		protected var _delay:int = 0;
		
		/** @inheritDoc */
		public function get runningTime():int { 
			// If not running, return 0
			if (!_running) { return 0; }
			// If the action is paused, factor that into the results
			if (isPaused) { return  (_pauseTime - _startTime); }
			// else 
			return (Synchronizer.getInstance().currentTime - _startTime); 
		}
		
		
		/** target object whose properties will be affected. */
		public var target:Object;
		
		/** property of the target object to affect as a string. */
		public var property:String;
		
		/** the starting value of the tween. */
		public var startValue:Number;
		
		/** the ending value of the tween. */
		public var endValue:Number;
		
		/** Returns false since this has a duration. */
		public function get isInstantaneous():Boolean { return false; } 
		
		/** True when the action is running (or paused) */
		public function get isRunning():Boolean { return _running; }
		
		/** True when the action is paused */ 
		public function get isPaused():Boolean { return _paused; }
		
		/** @inheritDoc */
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ _easingFunction = easingFunction;}
		protected var _easingFunction:Function;
		
		/** @inheritDoc */
		public function get easingMod1():Number { return _easingMod1; }
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		protected var _easingMod1:Number;

		/** @inheritDoc */
		public function get easingMod2():Number { return _easingMod2; }
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		protected var _easingMod2:Number;
		
		/** a cached value for the difference between the start and end. */
		protected var _delta:Number;
		
		/** The time at which the tween was started. */
		protected var _startTime:int;
		
		/** The time at which the tween was last paused. */
		protected var _pauseTime:int;
		
		/** Set to true internally if when the start() method is called (false when stopped). */
		protected var _running:Boolean = false;
		/** Set to true internally when the puase() mehtod is called (false when unpaused) */
		protected var _paused:Boolean = false;
		
		/**
		 * Constuctor.
		 * 
		 * @param target The object whose property will be changed.
		 * @param property The name of the property to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param startValue The value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param endValue The starting value of the tween.
		 * @param duration The time in milliseconds that this tween will take to execute.
		 * @param delay The time to wait in milliseconds before starting the tween.
		 * @param easingFunction The function to use to interpolate the values between fromValue and toValue.
		 * @param easingMod1 Optional modifier for the easing function
		 * @param easingMod2 Optional modifier for the easing function
		 */
		public function KSSimpleTween(target:Object, property:String, startValue:Number, endValue:Number, duration:int, delay:int = 0, easingFunction:Function = null, easingMod1:Number = NaN, easingMod2:Number = NaN) {
			this.target = target;
			this.property = property;
			this.startValue = startValue;
			this.endValue = endValue;
			this.duration = duration;
			this.delay = delay;
			if (easingFunction == null) { easingFunction = Linear.ease; }
			this.easingFunction = easingFunction;
			this.easingMod1 = easingMod1;
			this.easingMod2 = easingMod2;
		}

		/** Called when a pulse is sent from the Synchronizer */
		public function update(currentTime:int):void {
			var currentTime:int = currentTime;
			var timeElapsed:int = currentTime - _startTime;
			
			// timeElapsed shouldn't exceed the duration.
			timeElapsed = Math.min(timeElapsed, _duration);
			
			// if the delay is passed,
			if (timeElapsed >= 0) {
				
				// check for AUTO_TWEEN_VALUE
				if (isNaN(startValue)) {
					startValue = target[property] as Number;
				}
				if (isNaN(endValue)) {
					endValue = target[property] as Number;
				}
				
				// invoke the easing function.
				var result:Number =  EasingUtil.call(easingFunction, timeElapsed, _duration, _easingMod1, _easingMod2); 
				
				target[property] = result * (endValue - startValue) + startValue;
				
				// if the tween's duration is complete.
				if (timeElapsed >= _duration) {
					// end the tween.
					complete();
				}
			}
		}
		
		/** @inheritDoc */
		public function start():IAction {
			// get the current timestamp
			var currentTime:int = Synchronizer.getInstance().currentTime;
			// record the start time
			var startTime:int = currentTime + _delay;
			
			return startAtTime(startTime);
		}
		
		/** @inheritDoc */
		public function startAtTime(startTime:int):IPrecisionAction {
			if (!_running) {
				// get the current timestamp
				var currentTime:int = Synchronizer.getInstance().currentTime;
				// cache the delta
				_delta = endValue - startValue;
				// record the start time
				_startTime = startTime
				// register the class.
				Synchronizer.getInstance().registerClient(this);
				_running = true;
				// force the first update.
				update(currentTime);
				
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_START, currentTime));
			}
			return this;
		}
		
		/**
		 * Stops the tween. All progress will be lost and the tween will restart from the startValue
		 * if start() is called again.
		 */
		public function stop():void {
			Synchronizer.getInstance().unregisterClient(this);
		}
		
		/** @inheritDoc */
		public function reset():void {
			stop();
			
		}
		
		/** Called internally when the tween is completed. */
		protected function complete():void {
			stop();
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_COMPLETE, Synchronizer.getInstance().currentTime));
		}
		
		/** @inheritDoc */
		public function pause():void {
			if (!_running && !_paused) {
				var currentTime:int = Synchronizer.getInstance().currentTime;
				_pauseTime = currentTime;
				_paused = true;
				Synchronizer.getInstance().unregisterClient(this);
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_PAUSE, currentTime));
			}
		}
		
		/** @inheritDoc */
		public function unpause():void {
			if (_running && _paused) {
				Synchronizer.getInstance().registerClient(this);
				_paused = false;
				var currentTime:int = Synchronizer.getInstance().currentTime;
				var timeSincePause:int = currentTime - _pauseTime;
				_startTime = _startTime + timeSincePause; 
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.ACTION_UNPAUSE, currentTime));
			}
		}
		
		/** @inheritDoc */
		public function kill():void {
			target = null;
			easingFunction = null;
		}
		
		/** @inheritDoc */
		public function clone():IAction {
			return new KSSimpleTween(target, property, startValue, endValue, duration, delay, easingFunction, easingMod1, easingMod2);
		}
		
		override public function toString():String {
			return "KSSimpleTween :" + this.target.toString() + "[" + this.property + "]";
		}
	}
}