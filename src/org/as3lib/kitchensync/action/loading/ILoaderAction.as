package org.as3lib.kitchensync.action.loading
{
	import org.as3lib.kitchensync.action.IAction;
	
	/**
	 * A type of action that loads data from some external source when the start() mehtod is called
	 * and is considered finished when the transfer of data is complete. The loaded data can be accessed
	 * in the data property.This is typically implemented in a subclass of KSAsynchronousFunction.
	 * 
	 * These types of actions are useful if you wish to queue up several loaders using a 
	 * KSSequenceGroup and be notified when they're all finished.
	 * 
	 * @see org.as3lib.kitchensync.action.KSAsynchronousFunction
	 * @see org.as3lib.kitchensync.action.KSSequenceGroup
	 * 
	 * @author Mims Wright
	 * @since 1.7
	 */
	public interface ILoaderAction extends IAction
	{
		/**
		 * Whatever data is loaded by the loader action can be accessed
		 * through this property.
		 */
		function get data():*;
		
		/**
		 * When set to true, an error will be thrown when there is
		 * a problem with the loading.
		 * If set to false, the loader will fail silently and dispatch
		 * a complete event.
		 */
		function get throwErrorOnFail():Boolean;
		function set throwErrorOnFail(throwError:Boolean):void;
		
		/**
		 * Optional property allows you to provide an array that the 
		 * results of the loader will automatically be pushed onto when the
		 * loading is finished. This is convenient when using a KSSequenceGroup
		 * and ILoaderActions to load several files because you can access
		 * the results easily.
		 * If the value is left null, then nothing should happen on complete.
		 * 
		 * @since 2.0
		 */
		function get resultList():Array;
		function set resultList(resultList:Array):void;
	}
}