package org.as3lib.kitchensync.action
{
	/**
	 * A group of other actions that is itself an action. 
	 * An action group allows several child actions to execute
	 * as if they were a single unit. The children of a group
	 * can be any kind of IAction including other IActionGroup objects.
	 * The group will be responsible for executing all of the standard 
	 * controls for an action on its children and will keep track of the 
	 * order of the children. For example, pausing and unpausing a group 
	 * should pause and unpause the children in the group.
	 * Note: the duration for groups should be 0.
	 * 
	 * @see AbstractActionGroup
	 * @see KSSequenceGroup
	 * @see IAction
	 * @see http://en.wikipedia.org/wiki/Composite_pattern
	 * 
	 * @since 2.0
	 * @author Mims H. Wright
	 */
	public interface IActionGroup extends IAction
	{
		/**
		 * Provides access to a list of all the child actions 
		 * contained within the group.
		 */
		function get childActions():Array;
		
		/**
		 * Returns the total duration of all the children within
		 * the group. This is calculated by adding upthe sum of each 
		 * child's duration and delay (but does not include the 
		 * delay of the group itself).
		 * Note, some actions, such as KSAsynchronousFunctions, may not report
		 * accurately on their true duration. 
		 */
		function get totalDuration():int;
		
		/**
		 * Adds an action to the end of the group.
		 * Using this method while the action is running could cause unexpected results.
		 * 
		 * @param action One or more actions to add to the group. 
		 * 				   Don't start this action. That will be handled by the group.
		 */
		function addAction(action:IAction, ... additionalActions):void;
		
		/**
		 * Adds an action to the group at the specified index.
		 * Using this method while the action is running could cause unexpected results.
		 * 
		 * @param action The action to add.
		 * @param index The location at which to add the action. Defaults to the end of the Array
		 */
		function addActionAtIndex(action:IAction, index:int = -1):void;
		
		/**
		 * Removes an action from the group if it is a child of the group.
		 * Using this method while the action is running could cause unexpected results.
		 * 
		 * @throws Error if the action cannot be found.
		 * @param action The action to remove.
		 * @return The removed action.
		 */
		function removeAction(action:IAction):IAction;
		
		/**
		 * Removes an action at the specified index if it is a child of the group. 
		 * Using this method while the action is running could cause unexpected results.
		 * 
		 * @throws flash.errors.RangeError if the index is out of bounds.
		 * @param index The index in the array of the action to remove.
		 * @return The removed action.
		 */
		 function removeActionAtIndex(index:int):IAction;
		
		/**
		 * Returns the action at the specified index. 
		 * 
		 * @throws flash.errors.RangeError if the index is out of bounds.
		 * @param index The index in the array of the action to return.
		 * @return The specified action.
		 */ 
		 function getChildAtIndex(index:int):IAction;
		 
		 /**
		 * Reverse the order that the children play back in. 
		 * Essentially, this just reverses the child array.
		 * Should not be allowed to be called when the array is running.
		 * 
		 * @throws flash.errors.IllegalOperationError If this method is called while the 
		 * 											  group is running.
		 */
		 function reverseChildOrder():void;
	}
}