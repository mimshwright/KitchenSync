package org.as3lib.kitchensync.action.tween
{
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.easing.EasingUtil;
	import org.as3lib.kitchensync.utils.*;
	
	/**
	 * Used for animating an object's properties, such as position or scale, over time. 
	 * A tween will change an object's numeric value over time.
	 * It makes use of one or more TweenTarget objects to determine what to tween. 
	 * This can be handled automatically or declared explicitly.
	 * 
	 * Rule of thumb: KSTween is the action that handles the timing and starting and stopping
	 * the tween while ITweenTargets control the values of the tween. This allows you to tween
	 * all types of values, including complex ones like filter properties, with a single tween class. 
	 * 
	 * It's recommended that you use TweenFactory to create the tweens. 
	 * 
	 * @see org.as3lib.kitchensync.action.tween.TweenFactory
	 * @see org.as3lib.kitchensync.action.tween.ITweenTarget
	 * @see org.as3lib.kitchensync.action.tween.KSSimpleTween
	 * @since 0.1
	 * @author Mims Wright
	 */
	public class KSTween extends AbstractAction implements ITween, IPrecisionAction, ITweenTargetCollection
	{
		/** @inheritDoc */
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ 
			if (easingFunction == null) { easingFunction = KitchenSyncDefaults.easingFunction; }
			_easingFunction = easingFunction;
		}
		protected var _easingFunction:Function;
		
		
		/**
		 * @inheritDoc
		 */
		protected var _tweenTargets:Array;
		public function get tweenTargets():Array { return _tweenTargets; }
		
		/** 
		 * @inheritDoc
		 */
		public function addTweenTarget(tweenTarget:ITweenTarget):void { 
			if (tweenTarget != null) {
				_tweenTargets.push(tweenTarget);
			} else {
				throw new ArgumentError("tweenTarget cannot be null");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeTweenTarget(tweenTarget:ITweenTarget):void { 
			var index:int = _tweenTargets.indexOf(tweenTarget);
			if (index >= 0) {
				_tweenTargets.splice(index, 1);
			}
		}
		
		/** Removes all tween targets from the tween. */
		public function removeAllTweenTargets():void {
			_tweenTargets = new Array();
		}
		
		/** @inheritDoc */
		public function get easingMod1():Number { return _easingMod1; }
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		protected var _easingMod1:Number;

		/** @inheritDoc */
		public function get easingMod2():Number { return _easingMod2; }
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		protected var _easingMod2:Number;
		
		/**
		 * Indicates whether the final value for the easing function should snap to the 
		 * target _toValue. If set to true, the target property will equal _toValue regardless
		 * of the results of the easing function.
		 * 
		 * @default true
		 */
		public function get snapToValueOnComplete():Boolean { return _snapToValueOnComplete; }
		public function set snapToValueOnComplete(snapToValueOnComplete:Boolean):void { _snapToValueOnComplete = snapToValueOnComplete; }
		protected var _snapToValueOnComplete:Boolean;
		
		
		/**
		 * Constructor - It's recommended to use TweenFactory.
		 * 
		 * @see org.as3lib.kitchensync.action.tween.TweenFactory#newTween()
		 * @see org.as3lib.kitchensync.action.tween.KSSimpleTween
		 * @see #newWithTweenTarget()
		 * 
		 * @param tweenTargets A tweenTarget object (or an array of tweentargets) that contains the values you want to tween.
		 * @param duration The time in milliseconds that this tween will take to execute. Accepts string values.
		 * @param delay The time to wait before starting the tween. Accepts string values.
		 * @param easingFunction The function to use to interpolate the values between the start and end values. Default is set in KitchenSyncDefaults.
		 */
		public function KSTween(tweenTargets:*, duration:* = 0, delay:* = 0, easingFunction:Function = null)
		{
			super();
			_tweenTargets = new Array();
			
			// If tweenTargets is a single tweenTarget...
			if (tweenTargets is ITweenTarget) {
				// use the tweenTarget and ignore the first four params.
				// (it's recommended that you use newWithTweenTarget() instead)
				addTweenTarget(ITweenTarget(tweenTargets));
			} else if (tweenTargets is Array && tweenTargets != null) {
				// add the items in the array to the tweenTargets list and ignore the rest of the params.
				var tweenTargetArray:Array = tweenTargets as Array;
				for each (var tweenTarget:ITweenTarget in tweenTargetArray) {
					addTweenTarget(tweenTarget);
				}
			} else {
				throw new TypeError("'tweenTargets' parameter must be of type ITweenTarget or of type Array (containting ITweenTarget).");
			}
			
			snapToValueOnComplete = KitchenSyncDefaults.snapToValueOnComplete;
			
			this.duration = duration;
			this.delay = delay;
			
			if (easingFunction == null) { 
				// use default easing function if null.
				easingFunction = KitchenSyncDefaults.easingFunction;
			}
			_easingFunction = easingFunction;
		}
		

		/** @inheritDoc */
		override public function start():IAction {
			// use startAtTime with the default start time.
			return startAtTime(-1);
		}
		
		/** @inheritDoc */
		public function startAtTime(startTime:int):IPrecisionAction {
			if (_tweenTargets && _tweenTargets.length >= 0) { 
				super.start();
				if (startTime > 0) {
					_startTime = startTime;
				}
				return this;
			}
			// else 
			throw new Error("Tween must have at least one tween target. use addTweenTarget().");
			return null;
		}
		
		
		/**
		 * Stops the tween and sets the target property to the start value.
		 */
		override public function reset():void {
			stop();
			for each (var target:ITweenTarget in _tweenTargets) {
				target.reset();
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Executes the tween when start time has elapsed.
		 */
		override public function update(currentTime:int):void {
			var timeElapsed:int;
			
			// if the tween is running and the delay time has elapsed, perform tweening.
			if ( startTimeHasElapsed(currentTime) ) {
		 		timeElapsed = currentTime - _startTime - _delay;
				
				var target:ITweenTarget
				
				// if this is the start of the tween.
				if (timeElapsed <= 1) {
					for each (target in _tweenTargets) {
						// if using the 'existing from value' set the start value at the time that the tween begins.
						if (isNaN(target.startValue)) { 
							target.startValue = target.currentValue; 
						}
						if (isNaN(target.endValue)) {
							target.endValue = target.currentValue;
						}
					}
				}
				
				// invoke the easing function.
				var easingResult:Number =  EasingUtil.call(_easingFunction, timeElapsed, duration, _easingMod1, _easingMod2); 
				
				// apply the result to each tween target				
				for each (target in _tweenTargets) {
					// total change in values for the tween.
					//var delta:Number = target.endValue - target.startValue; 
					
					// set the tweenTarget's value.
					target.updateTween(easingResult);
				}
				
				// if the tween's duration is complete.
				if (durationHasElapsed(currentTime)) {
					
					// if snapToValue is set to true, the target property will be set to the target value 
					// regardless of the results of the easing function.
					if (_snapToValueOnComplete) { 
						for each (target in _tweenTargets) {
							target.updateTween(1.0); 
						}
					}
					
					// end the tween.
					complete();
				}
			}
		}
		
		
		/**
		 * Flips the values for to and from values. Essentially, causes the animation to run backwards.
		 * 
		 * Internally, this runs thorugh all the tweenTargets and swaps the start and end values.
		 * 
		 * @see #cloneReversed()
		 */
		public function reverse():void {
			for each (var target:ITweenTarget in _tweenTargets) {
				var temp:Number = target.startValue;
				target.startValue = target.endValue;
				target.endValue = temp;
			}						
		}
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clonedTargets:Array = _tweenTargets.concat();
			var clone:KSTween = new KSTween(clonedTargets, this.duration, this.delay, this.easingFunction);
			clone._easingMod1 = _easingMod1;
			clone._easingMod2 = _easingMod2;
			clone.autoDelete = _autoDelete;
			clone.snapToValueOnComplete = _snapToValueOnComplete;
			return clone;
		}
		
		/**
		 * Duplicates a tween and if the first tween target is a TargetProperty, makes 
		 * a copy of it with a new target and property.
		 * The first tweenTarget of the KSTween must be a TargetProperty for this to work.
		 * 
		 * Personal note: This method is somewhat of a hack. I'm including it for 
		 * ease of use but a better way to do this would be to create a clone of a 
		 * TargetProperty object and attach that to a clone of this KSTween.
		 * 
		 * @param target The new target object.
		 * @param property The new property of the target.
		 * @return KSTween A cloned instance of this tween with the new tween targets.
		 */
		public function cloneWithTargetProperty (target:*, property:String = ""):KSTween {
			var oldTarget:TargetProperty = tweenTargets[0] as TargetProperty;
			if (!oldTarget) {
				throw new Error("You can't use this method unless the first tweenTarget is a TargetProperty");
			}
			var tweenTarget:TargetProperty = oldTarget.clone() as TargetProperty;
			if ( property != "") { property = oldTarget.property; }
			tweenTarget.setTargetPropterty(target, property);
			
			var clone:KSTween = clone() as KSTween;
			clone.removeAllTweenTargets();
			
			clone.addTweenTarget(tweenTarget);
			return clone;
		}
		
		/**
		 * Duplicates a tween and replaces all the tween targets with the ones provided.
		 * 
		 * @param target An ITweenTarget to use in the cloned tween.
		 * @return KSTween A cloned instance of this tween with the new tween targets.
		 */
		public function cloneWithTweenTarget(target:ITweenTarget):KSTween {
			var clone:KSTween = clone() as KSTween;
			clone.removeAllTweenTargets();
			clone.addTweenTarget(target);
			return clone;
		}
		
		
		/**
		 * Creates a new Tween and reverses the start and end values of the target property.
		 * 
		 * @example 
		 * 		<listing version="3.0">
		 * 			var tween:KSTween = new KSTween(foo, "x", 100, 200);
		 * 			var sequence:KSSequence = new KSSequence(
		 * 				tween,							// tweens foo's x from 100 to 200
		 * 				tween.cloneReversed()			// tweens foo's x from 200 to 100
		 * 			);
		 * 		</listing>
		 * 
		 * @see #reverse()
		 * @see #clone()
		 * 
		 * @returns KSTween A new Tween identical to this but with start and end reversed.
		 */
		public function cloneReversed():KSTween {
			var clone:KSTween;
			clone = KSTween(this.clone());
			clone.reverse();
			return clone;
		}
		
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			removeAllTweenTargets();
		}
		
		/**
		 * Returns a description of the tween.
		 */
		override public function toString():String {
			var string:String = "KSTween ";
			string += "[";
			for each (var target:ITweenTarget in _tweenTargets) {
				string += Object(target).toString() + ", ";
			} 
			string += "]";
			
			if (description != "") { 
				string += " - " + description; 
			}
			return string;
		}
	}
}