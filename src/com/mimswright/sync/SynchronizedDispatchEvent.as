package com.mimswright.sync
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	public class SynchronizedDispatchEvent extends AbstractSynchronizedAction
	{
		public static const SELF:IEventDispatcher = null;
		
		protected var _target:IEventDispatcher;
		public function get target ():IEventDispatcher { return _target; }
		public function set target (target:IEventDispatcher):void { _target = target; }
		
		protected var _event:Event;
		public function get event():Event { return _event; }
		public function set event(event:Event):void { _event = event; }
		
		public function set eventType(type:String):void {
			_event = new Event(type);
		}
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - If any objects in listeners are not of type Function.
		 * 
		 * @param event - Can be either an Event object or a String. If event is an Event, that object is used.
		 * 				  If event is a string, a new event with that type is automatically created.
		 * @param target - The IEventDispatcher that will dispatch the event. The default is this.
		 * @param offset - 
		 * @param listeners - Any additional objects passed in will be added as listeners (if they're functions)
		 */
		public function SynchronizedDispatchEvent(event:*, target:IEventDispatcher = SELF, offset:int = 0, ... listeners) {
			if (event is Event) {
				_event = Event(event);
			} else if (event is String) {
				eventType = String(event);
			} else {
				throw new TypeError ("Invalid event parameter. Must be of type Event or String.");
			}
			
			if (target) {
				_target = target;
			} else {
				_target = this;
			}
			
			_offset = offset;
			
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
		 * Note that useWeakReference will always be true so that the listeners don't need to be removed.
		 */
		public function addEventListenerToTarget(listener:Function, useCapture:Boolean=false, priority:int=0.0):void {
			_target.addEventListener(_event.type, listener, useCapture, priority, true);
		}
		
		/**
		 * Allows you to remove an event listener from the target that is dispatching the event.
		 */
		public function removeEventListenerFromTarget(listener:Function, useCapture:Boolean=false):void {
			_target.removeEventListener(_event.type, listener, useCapture);
		}
		
		/**
		 * When the offset is reached, the event will be fired from the target.
		 * Note that if duration is > 0, this will continue to fire for every frame until duration is elapsed.
		 */
		override internal function onUpdate(event:SynchronizerEvent):void {
			if (_startTimeHasElapsed) {
				_target.dispatchEvent(_event);
				if (_durationHasElapsed) {
					complete();
				}
			}
		}
		
		/**
		 * override to clean up references to other objects.
		 */
		override public function kill():void {
			super.kill();
			_target = null;
			_event = null;
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:SynchronizedDispatchEvent = new SynchronizedDispatchEvent(_event, _target, _offset);
			clone.duration = _duration;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}