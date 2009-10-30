package org.as3lib.kitchensync.action.loading
{
	import flash.net.URLRequest;
	
	import org.as3lib.kitchensync.action.KSSequenceGroup;

	/**
	 * Allows you to very quickly create a loading queue to load 
	 * multiple files in a batch. The loaded files will be stored in the
	 * resultList property. 
	 * The KSLoadQueue will be a sequence group containing ILoaderAcitons.
	 * By default, KSURLLoaders will be used but you can specify which class
	 * you would like to use for the loaders. 
	 * 
	 * @see ILoaderAction
	 * @see KSURLLoader
	 * @see KSLoader
	 * 
	 * @author Mims Wright
	 * @since 2.0
	 */
	public class KSLoadQueue extends KSSequenceGroup
	{
		/**
		 * Stores the results of all the loader actions as they complete.
		 */
		public function get resultList():Array { return _resultList; }
		public function set resultList(resultList:Array):void { _resultList = resultList; }
		protected var _resultList:Array;
		
		/**
		 * Constructor.
		 * 
		 * @param urlList An array containing all the URLRequest objects to add to the queue.
		 * 				  More can be added later using the <code>addURL()</code> method.
		 * @param loaderClass The type of ILoaderAction to instantiate. See addURL() for more details.
		 */
		public function KSLoadQueue(urlList:Array, loaderClass:Class = null)
		{
			super();
			
			for each (var url:URLRequest in urlList) { 
				addURL(url, loaderClass); 
			}			
		}
		
		/**
		 * Add a url to the end of the queue.
		 * 
		 * @param url The URLRequest object to load the data from.
		 * @param loaderClass Allows you to specify which type of ILoaderAction to use to load this url.
		 * 					  The default will use KSURLLoader but you may want to use KSLoader or something else.
		 * @return A reference to the loaderAction that was created in the queue.
		 * 
		 * @throws flash.errors.TypeError if the loaderClass doesn't implement ILoaderAction 
		 */
		public function addURL(url:URLRequest, loaderClass:Class = null):ILoaderAction {
			if (loaderClass == null) { 
				loaderClass = KSURLLoader;
			}
			var loaderAction:ILoaderAction = new loaderClass(url, _resultList) as ILoaderAction;
			if (loaderAction == null) {
				throw new TypeError("loaderClass must be a reference to a class that implements ILoaderAction such as KSLoader");
			}
			addAction(loaderAction);
			return loaderAction; 
		}
		
		override public function kill():void {
			super.kill();
			_resultList = null;	
		}
		
	}
}