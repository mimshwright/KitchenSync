package ks.action
{
	import flash.net.URLRequest;
	

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
	 * @example <listing version="3.0">
	 * var urls:Array = ["img1.jpg","img2.jpg","img3.jpg"];
	 * var queue:KSLoadQueue = new KSLoadQueue(urls, KSLoader);
	 * queue.addEventListener(KitchenSyncEvent.COMPLETE, onComplete);
	 * queue.start();
	 * </listing>
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
		public function KSLoadQueue(urlList:Array = null, loaderClass:Class = null)
		{
			super();
			
			_resultList = [];
			
			for each (var url:* in urlList) { 
				addURL(url, loaderClass); 
			}			
		}
		
		/**
		 * Returns the total progress of the load queue.
		 * Since it's difficult to judge how long each loader will take before the 
		 * load has begun, it makes an estimate of the total progress based on the 
		 * number of items in the load queue. Only the currently loading item will
		 * report it's actual progress and it's weighted by its position in the 
		 * queue. 
		 * If every item being loaded is close to the same file size, the
		 * loading percentage should be fairly accurate. If some files are much 
		 * larger, they will cause the progress to appear to be slower while they 
		 * are loading and faster while the small files are loading.
		 * 
		 * @since 2.1
		 */
		override public function get progress():Number {
			return super.progress; // overrriding just for the asdocs
		}
		
		/**
		 * Add a url to the end of the queue.
		 * 
		 * @param url The URL string or URLRequest object of these to load the data from.
		 * @param loaderClass Allows you to specify which type of ILoaderAction to use to load this url.
		 * 					  The default will use KSURLLoader but you may want to use KSLoader or something else.
		 * @param index The index at which to add the action. (default is the end of the queue)
		 * @return A reference to the loaderAction that was created in the queue.
		 * 
		 * @throws flash.errors.TypeError if the url parameter is not either a string or a URLRequest 
		 * @throws flash.errors.TypeError if the loaderClass doesn't implement ILoaderAction 
		 */
		public function addURL(url:*, loaderClass:Class = null, index:int = -1):ILoaderAction {
			
			// determine the type of the url parameter
			var urlRequest:URLRequest;
			if (url is String) {
				urlRequest = new URLRequest(url);
			} else if (url is URLRequest) {
				urlRequest = URLRequest(url);
			} else {
				throw new TypeError("url must either be a string or a URLRequest object.");
			}
			
			// Use KSURLLoader as the default loaderClass
			if (loaderClass == null) { 
				loaderClass = KSURLLoader;
			}
			
			var loaderAction:ILoaderAction = new loaderClass(urlRequest, _resultList) as ILoaderAction;
			// Check to see that the loaderAction is a valid type.
			if (loaderAction == null) {
				throw new TypeError("loaderClass must be a reference to a class that implements ILoaderAction such as KSLoader");
			}
			
			// add the loaderAction to the list of childActions
			if (index < 0) {
				addAction(loaderAction);
			} else {
				addActionAtIndex(loaderAction, index);
			}
			return loaderAction; 
		}
		
		override public function kill():void {
			super.kill();
			_resultList = null;	
		}
		
	}
}