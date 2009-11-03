package org.as3lib.kitchensync.action
{
	import flash.events.IEventDispatcher;
	
	import org.as3lib.kitchensync.core.ISynchronizerClient;
	
	/**
	 * An action is a type that represents any kind of happening that takes place at
	 * a certain time. All actions use this interface including function-based actions
	 * and tweens. Actions are teh nuts and bolts of KitchenSync.
	 * Actions can be played, stopped, paused and unpaused. Actions have 
	 * a duration and a delay that specify for how long it will play and how long after
	 * the start it will begin (although some actions will execute instantaneously).
	 * 
	 * @since 1.6
	 * @author Mims Wright
	 */
	public interface IAction extends ISynchronizerClient, IEventDispatcher
	{
		/**
		 * duration is the length of time that the action will run.
		 * Uses * to allow use of time string parser.
		 * 
		 * @see org.as3lib.kitchensync.utils.ITimeStringParser
		 */
		function get duration():int;
		function set duration(duration:*):void;
		
		/**
		 * delay is the time that will pass after the start() method is called
		 * before the action begins.
		 * Uses * to allow use of time string parser.
		 * 
		 * @see org.as3lib.kitchensync.utils.ITimeStringParser
		 */
		function get delay():int;
		function set delay(delay:*):void; 
		
		/** 
		 * Should true if the action will occur instantaneously (if duration is 0). 
		 * Mostly used internally. 
		 */
		function get isInstantaneous():Boolean;
		
		/**
		 * The time in ms since the start of the action or 0 if the action isn't running.
		 * If the action is paused, the result will be the running time at which it was paused.
		 * Typically, the current real time minus the action's start time.
		 * Actions with 0 duration will always return 0.
		 */ 
		function get runningTime():int;
		
		/** Should return true if the action is running (or paused). */
		function get isRunning():Boolean;
		
		/** Should return true if the action is paused. */
		function get isPaused():Boolean;
		
		/**
		 * Begins the action running. The action will execute whatever it is
		 * meant to do when the <code>start()</code> method is called (and after the 
		 * <code>delay</code> time has elapsed).
		 * <code>start()</code> should also cause the action to unpause if it is
		 * paused.
		 * 
		 * <p>This method returns a reference to the action that was started. 
		 * This allows for an action to be constructed and started in a single line of code.</p>
		 * 
		 * @example 
		 * 		<listing version="3.0">
		 *		// Initialize and start an action in a single line of code.
		 * 		var action:IAction = new SomeAction().start();
		 * 		</listing>
		 * 
		 * @return The action that was just started. For convenience.
		 * @throws flash.errors.IllegalOperationError If the method is called while the action is already running.
		 */
		function start():IAction;
		
		/**
		 * Stops the action from running and resets the timer.
		 */
		function stop():void;
		
		/**
		 * Resets the action and returns it to its original state it was in
		 * before being started. In some cases, like with tweens, this 
		 * will reset the values of the tween target. In most other cases,
		 * this will act similarly to the stop() method.
		 */
		function reset():void;
		
		/**
		 * Causes the action to be paused. The action temporarily ignores update events from the Synchronizer 
		 * and the onUpdate() handler will not be called. When unpause() is called,
		 * the action will continue at the point where it was paused.
		 * The pause() method affects the start time even if the delay time hasn't expired yet.
		 */
		function pause():void;
		
		/**
		 * Resumes the action at the point where it was paused.
		 * 
		 * @see #start()
		 */
		function unpause():void;
		
		/**
		 * Creates a clone which is a deep copy of the action.
		 * States (e.g. isRunning will not be copied)
		 *  
		 * @return An exact copy of the action. 
		 */
		function clone():IAction;
		
		/**
		 * Unregisters the action and removes any refrerences to objects that it may be holding onto.
		 * This is done in an attempt to remove the object from memory. 
		 */
		 function kill():void;
	}
}