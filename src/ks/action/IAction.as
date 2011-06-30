package ks.action
{
	import flash.events.IEventDispatcher;
	import ks.core.ISynchronizerClient;
	import ks.core.IPauseable;
	
	
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
	public interface IAction extends ISynchronizerClient, IEventDispatcher, IPauseable
	{
		/**
		 * duration is the length of time that the action will run.
		 * Uses * to allow use of time string parser.
		 * 
		 * @see ks.utils.ITimeStringParser
		 */
		function get duration():int;
		function set duration(duration:*):void;
		
		
		/**
		 * delay is the time that will pass after the start() method is called
		 * before the action begins.
		 * Uses * to allow use of time string parser.
		 * 
		 * @see ks.utils.ITimeStringParser
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
		
		/**
		 * Returns the percentage complete of the action.
		 * The value is generally speaking equal to (runningTime / duration).
		 * This value should be as accurate as possible. When a reading is impractical or if it's difficult
		 * to get an accurate value, the progress should err on the side of less progress.
		 * 
		 * If the action is instantaneous, the progress will go from 0 to 1 when the action executes.  
		 * 
		 * If the action completes, it will stop running. When it isn't running it will always return 0 
		 * so the action may never return a value of 1. Therefore, if you're updating a display with 
		 * the progress, use the complete event to know when it's done rather than waiting 
		 * for progress to equal 1.
		 * 
		 * 
		 * Read-only.
		 * 
		 * @since 2.0, moved to iAction in  
		 */
		function get progress ():Number;
		
		
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