package org.as3lib.kitchensync.action
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * An object that causes an event to be dispatched at the time of execution.
	 * An AS3 Event can be dispatched after a delay or as part of a sequence using this class. 
	 * Events are dispatched using the AS3 event dispatching system and can be sent from the 
	 * object itself or from any other IEventDispatcher. The constructor can 
	 * be passed either an Event object or a string for the event type.
	 * 
	 * Keep in mind that the same rules apply for removingEventListeners to release them from memory.
	 * Use weak references when possible. 
	 *
	 * @example <listing version="3.0">
	 * // this dispatcher will dispatch an event after 5 seconds.
	 * var dispatcher:KSDispatchEvent = new KSDispatchEvent(new Event("myEvent"), SELF, "5 sec");
	 * dispatcher.addEventListenerToTarget(onEvent, false, 0, true);
	 * 
	 * function onEvent(event:Event):viod { 
	 * 	trace("event dispatched from " + event.target);
	 * }
	 * </listing>
	 *  
	 * @author Mims H. Wright
	 * @since 0.1
	 */
	public class KSDispatchEvent extends AbstractAction
	{
		/**
		 * Use SELF in the constructor when you want to use the 
		 * instance of the classs as the event dispatcher (target).
		 */ 
		public static const SELF:IEventDispatcher = null;
		
		/**
		 * This is the IEventDispatcher that the event will be dispatched from. 
		 * @default is <code>SELF</code> (or <code>this</code>). 
		 */ 
		public function get target ():IEventDispatcher { return _target; }
		public function set target (target:IEventDispatcher):void { _target = target; }
		protected var _target:IEventDispatcher;
		

		/**
		 * The event that will be dispatched.
		 */
		public function get event():Event { return _event; }
		public function set event(event:Event):void { _event = event; }
		protected var _event:Event;
		
		
		/**
		 * Constructor.
		 * 
		 * @param event - Can be either an Event object or a String. If event is an Event, that object is used.
		 * 				  If event is a string, a new event with that type is automatically created.
		 * @param target - The IEventDispatcher that will dispatch the event. The default is <code>this</code>.
		 * @param delay - time to wait before execution
		 * @param listeners - Any additional objects passed in will be added as listeners (if they're functions)
		 * 
		 * @throws TypeError - If event is not of type String or Event.
		 * @throws TypeError - If any objects in listeners are not of type Function.
		 */
		public function KSDispatchEvent(event:*, target:IEventDispatcher = SELF, delay:* = 0, ... listeners) {
			super();
			
			// determine the type of the event parameter
			if (event is Event) {
				_event = Event(event);
			} else if (event is String) {
				_event = new Event(String(event));
			} else {
				throw new TypeError ("Invalid event parameter. Must be of type Event or String.");
			}
			
			this.target = target;
			this.delay = delay;
			
			// step through all the listeners and add them as listeners.
			for (var i:int = 0; i < listeners.length; i++) {
				var func:Function = listeners[i] as Function;
				if (func != null) {
					addEventListenerToTarget(func);
				} else {
					throw new TypeError("All listeners must be of type Function.");
				}
			}
		}
		
		/**
		 * Allows you to add an event listener to the target that is dispatching the event.
		 * 
		 * @see flash.events.EventDispatcher#addEventListener()
		 */
		public function addEventListenerToTarget(listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReferences:Boolean=false):void {
			_target.addEventListener(_event.type, listener, useCapture, priority, useWeakReferences);
		}
		
		/**
		 * Allows you to remove an event listener from the target that is dispatching the event.
		 */
		public function removeEventListenerFromTarget(listener:Function, useCapture:Boolean=false):void {
			_target.removeEventListener(_event.type, listener, useCapture);
		}
		
		/**
		 * When the delay is reached, the event will be fired from the target.
		 * Note that if duration is > 0, this will continue to fire for every frame until duration is elapsed.
		 */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed) {
				// If target is null, use this as the dispatcher.
				if (_target == null || _target == SELF) { _target = this; }
				_target.dispatchEvent(_event);
				
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		
		/**
		 * Kills the object and attempts to remove it from memory.
		 * Keep in mind that you will need to remove any event listeners
		 * to the target to release the listeners from memory.  
		 */
		override public function kill():void {
			super.kill();
			_target = null;
			_event = null;
		}
		
		/**
		 * Duplicates the object.
		 * Note, the listeners added to the original will not be added.
		 */
		override public function clone():IAction {
			var clone:KSDispatchEvent = new KSDispatchEvent(_event, _target, _delay);
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}