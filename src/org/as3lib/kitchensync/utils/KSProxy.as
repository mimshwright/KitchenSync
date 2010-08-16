package org.as3lib.kitchensync.utils
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.as3lib.kitchensync.core.ISynchronizerClient;
	import org.as3lib.kitchensync.core.KitchenSyncEvent;
	import org.as3lib.kitchensync.core.Synchronizer;

	/**
	 * Watches for changes on an object's properties and applies the values to another object's property.
	 * A modification function can be provided so that the values are adjusted before being applied to the 
	 * target property. This class can be used in conjunction with tweens to use a single tween to modify
	 * several different properties. For example, you could tween the x value of sprite A and proxy that 
	 * value onto the y value of text field B.
	 * 
	 * Technical note:
	 * Please note that using this class improperly could cause performance issues and memory leaks. The 
	 * changes to values are checked using bracket notation to access properties of untyped objects (not
	 * very efficient). Once started, the values will be checked every time the Synchronizer updates until
	 * the stop() or kill() methods are called. Also, references to the watched and target objects will be
	 * kept in memory until kill() is called. Therefore, it's important to call kill() when the watcher is
	 * no longer needed. When possible, make use of the kill event listener in the constructor.
	 * 
	 * @example <listing version="3.0">
	 * package {
			import flash.display.*;
			import flash.text.TextField;
			
			import org.as3lib.kitchensync.action.IAction;
			import org.as3lib.kitchensync.action.tween.TweenFactory;
			import org.as3lib.kitchensync.easing.Cubic;
			import org.as3lib.kitchensync.utils.KSProxy;
			
			[SWF ( width="600", height="600", frameRate="50") ]
			public class ProxyTest extends Sprite
			{		
				public function ProxyTest()
				{
					super();
					
					
					// The original shape. Tweened from left to right.
					var r1:Shape = newRect(0);
					addChild(r1);
					var start:int = 0;
					var end:int = 500;
					var tween:IAction = TweenFactory.newTween(r1, "x", start, end, "5s", 0, Cubic.easeInOut).start();
					
					// Apply the original tween to the y property of this block.
					var r2:Shape = newRect(50);
					new KSProxy(r1, "x", r2, "y", null, tween).start();
					addChild(r2);
		
					// Apply the inverse of the tween to this block (by subtracting it from the end value)
					var r3:Shape = newRect(100);
					new KSProxy(r1, "x", r3, "x", function (inValue:Number):Number { return end - inValue; }, tween).start();
					addChild(r3);
		
					// Apply half the tween value to this block. 
					var r4:Shape = newRect(150);
					new KSProxy(r1, "x", r4, "x", function (inValue:Number):Number { return inValue/2; }, tween).start();
					addChild(r4);
					
					// Use the tween value as a string in this text field
					var t:TextField = new TextField();
					new KSProxy(r1, "x", t, "text", function (inValue:Number):String { return "r1's x value is : " + inValue.toString(); }, tween).start();
					addChild(t);
					
					// shortcut function for creating 20x20 black rectangles
					function newRect(y:int):Shape { 
						var r:Shape = new Shape();
						r.graphics.beginFill(0);
						r.graphics.drawRect(0,y, 20, 20);
						return r;
					}
				}
			}
		}
 	 * </listing>
	 * 
	 * @author Mims H. Wright
	 * @since 2.1
	 */
	public class KSProxy implements ISynchronizerClient
	{
		private var _watchedObject:*;
		private var _watchedProperty:String;
		private var _targetObject:*;
		private var _targetProperty:String;
		
		/**
		 * An optional function that modifies the watched value before it's applied
		 * to the target property. The mod function should be in the format 
		 * <code>function (inValue:*):* // returning an out value</code>.
		 */
		private var _modFunction:Function;
		public function get modFunction():Function { return _modFunction; }
		public function set modFunction(value:Function):void { _modFunction = value; }

		/**
		 * Holds the previous change value so that updates only happen when the value has changed.
		 */
		private var _previousValue:*;
		
		public function get isRunning():Boolean { return _isRunning; }
		private var _isRunning:Boolean;
		
		
		/**
		 * Constructor.
		 * 
		 * @param watchedObject The object that owns the property to watch for changes.
		 * @param watchedProperty The property to watch for changes. Must be public. 
		 * @param targetObject The object that owns the property to apply the changes to.
		 * @param targetProperty The property to apply the changes to. Must be public.
		 * @param modFunction An optional function that modifies the watched value before it's applied
		 * 					  to the target property. The mod function should be in the format 
		 * 					  <code>function (inValue:*):* // returning an out value</code>.
		 * @param killEventDispatcher An optional parameter for the event dispatcher to listen to for complete 
		 * 							  events that kill the proxy. If you use this, you should also provide
		 * 							  a value for killEventType.
		 * @param killEventType The event type to listen for if you provided a killEventDispatcher. By default,
		 * 						it will use the KitchenSyncEvent.ACTION_COMPLETE type since this class will commonly
		 * 						be used to mirror a tween onto another property.
		 */
		public function KSProxy(watchedObject:*, watchedProperty:String, targetObject:*, targetProperty:String, modFunction:Function = null, killEventDispatcher:IEventDispatcher = null, killEventType:String = "actionComplete" )
		{
			if (watchedObject == null || targetObject == null) {
				throw new ArgumentError ("Both watchedObject and targetObject must not be null.");
			}
			
			_watchedObject = watchedObject;
			_watchedProperty = watchedProperty;
			
			_targetObject = targetObject;
			_targetProperty = targetProperty;
			
			_modFunction = modFunction;
			
			if (killEventDispatcher) {
				listenForKillEvent(killEventDispatcher, killEventType);
			}
		}
		
		/**
		 * Registers an event listener that kills the proxy relationship when the event is received.
		 * Always uses a weak reference. To use a strong reference, set up your own event listener using
		 * addEventListener().  
		 * 
		 * @param eventDispatcher The event dispatcher to listen to. 
		 * @param eventType The event type (string name of the event) to listen for.
		 */
		public function listenForKillEvent(eventDispatcher:IEventDispatcher, eventType:String):void {
			eventDispatcher.addEventListener(eventType, onKill, false, 0, true); 
		}
										 
		
		/**
		 * Starts watching the watched values and applying values to the target.
		 */
		public function start():void {
			if (isRunning == false) {
				_isRunning = true;
				Synchronizer.getInstance().registerClient(this);
			}
		}
		
		/**
		 * Stops watching the watched values and applying values to the target.
		 */
		public function stop():void {
			if (isRunning) {
				Synchronizer.getInstance().unregisterClient(this);
				_isRunning = false;
			}
		}
		
		
		/**
		 * @private
		 */
		private function onKill(event:Event = null):void {
			kill();
		}
		
		/**
		 * Stops and drops all references to the objects so that they may be released from 
		 * memory.
		 */
		public function kill():void {
			if (isRunning) stop();
			_watchedObject = null;
			_targetObject = null;
			_modFunction = null;
		}
		
		/**
		 * Function that is run each frame to check for changes in values.
		 */
		public function update(currentTime:int):void {
			if (isRunning) {
				if (needsUpdate()) {
					var newValue:*;
					if (_modFunction != null) {
						// if modFunction was provided, use it to modify the value before applying it to 
						// the target.
						newValue = modifiedWatchedValue;
					} else {
						newValue = watchedValue;
					}
					targetValue = newValue;
					_previousValue = newValue;
				}
			}	
			
			function needsUpdate():Boolean { return watchedValue != _previousValue; }
		}
		
		/**
		 * Directly accesses the unmodified value of the watched object.
		 */
		public function get watchedValue():* {
			return _watchedObject[_watchedProperty];
		}
		public function set watchedValue(value:*):void {
			_watchedObject[_watchedProperty] = value;
		}
		
		/**
		 * Retrieves the value of the watched object after being modified by
		 * the watched value. 
		 * 
		 * @throws Error if _modFunciton is null.
		 */
		public function get modifiedWatchedValue():* {
			return _modFunction.call(null, watchedValue);
		}
		
		
		/**
		 * Directly accesses the target value.
		 */
		public function get targetValue ():* { 
			return _targetObject[_targetProperty];
		}
		public function set targetValue (value:*):void {
			_targetObject[_targetProperty] = value;
		}
		
	}
}