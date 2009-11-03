package org.as3lib.kitchensync.action.loading
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.as3lib.kitchensync.action.*;
	
	/**
	 * A KitchenSync action version of a URLLoader. Loads data from a URLRequest
	 * when the start() mehtod is called and disptaches a complete event when 
	 * the data is finished loading.
	 * You can access the loaded data using the <code>data</code> property.
	 *
	 * @example <listing version="3.0">
	 * 
	 * package {
	 * class KSURLLoaderExample {
	 * import org.as3lib.kitchensync.*
	 * import org.as3lib.kitchensync.core.*
	 * import org.as3lib.kitchensync.action.*
	 * import org.as3lib.kitchensync.action.loading.*
	 * 
	 * public var results:Array;
	 * private function KSURLLoaderExample () {
	 * 		KitchenSync.initialize(30, "2.0");		
	 * 
	 * 		results = new Array();
	 * 
	 * 		var url1:URLRequest = new URLRequest("http://www.example.com/file1.txt");
	 * 		var url2:URLRequest = new URLRequest("http://www.example.com/file2.txt");
	 * 		var url3:URLRequest = new URLRequest("http://www.example.com/file3.txt");
	 * 
	 * 		var loadingQueue:KSSequenceGroup = new KSSequenceGroup(
	 * 			new KSURLLoader(url1, results),
	 * 			new KSURLLoader(url2, results),
	 * 			new KSURLLoader(url3, results)
	 * 		);
	 * 		loadingQueue.addEventListener(KitchenSyncEvent.COMPLETE, onLoadComplete);
	 * 		loadingQueue.start();
	 * }
	 * 
	 * private function onLoadComplete(event:Event):void {
	 * 		for each (var data:* in results) {
	 * 			// do something with data.
	 * 		}
	 * }
	 * }
	 * }
	 * 
	 * </listing>
	 * 
	 * @see org.as3lib.kitchensync.action.KSSequenceGroup
	 *  
	 * @author Mims Wright
	 * @since 1.7
	 */
	public class KSURLLoader extends KSAsynchronousFunction implements ILoaderAction
	{
		/**
		 * @inheritDoc
		 */  
		public function get resultList():Array { return _resultList; }
		public function set resultList(resultList:Array):void { _resultList = resultList; }
		protected var _resultList:Array;
		
		
		/**
		 * A reference to the actual URLLoader object. 
		 * You can access this directly to make adjustments to the way data is loaded
		 * and so forth.
		 */
		public function get loader():URLLoader { return _loader; }
		public function set loader(loader:URLLoader):void {  _loader = loader; }
		protected var _loader:URLLoader;
		
		
		/**
		 * @inheritDoc
		 */
		public function get data():* { return _data; } 
		protected var _data:* = null;
		
		/**
		 * @inheritDoc
		 */
		public function get throwErrorOnFail():Boolean { return _throwErrorOnFail; }
		public function set throwErrorOnFail(throwError:Boolean):void { _throwErrorOnFail = throwError; }
		protected var _throwErrorOnFail:Boolean;
		
		/**
		 * Constructor.
		 * 
		 * @param url The URLRequest object to load the data from.
		 * @param resultList An array to store the results of this operation in.
		 * @param throwErrorOnFail If set to true, errors will be dispatched if something goes wrong.
		 */
		public function KSURLLoader(url:URLRequest, resultList:Array = null, throwErrorOnFail:Boolean = true)
		{
			_throwErrorOnFail = throwErrorOnFail;
			_resultList = resultList;
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoadSuccess, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail, false, 0, true);
			
			super(_loader.load, _loader, Event.COMPLETE, url);
		}

		/**
		 * Called when the load is successful.
		 */
		protected function onLoadSuccess(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			_data = loader.data;
			if (_resultList) {
				_resultList.push(_data);
			}
		}
		
		/**
		 * Called when the load fails.
		 * 
		 * @throws flash.errors.IOErrorEvent if there was a problem loading the file.
		 */
		protected function onLoadFail(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			if (_throwErrorOnFail) {
				throw new IOError(event.text);
			} else {
				complete();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function kill():void {
			super.kill();
			_data = null;
			_loader = null;
			_resultList = null;
		}
	}
}