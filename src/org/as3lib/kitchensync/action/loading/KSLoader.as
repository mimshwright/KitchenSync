package org.as3lib.kitchensync.action.loading
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.as3lib.kitchensync.action.KSAsynchronousFunction;
	
	/**
	 * An action for loading swf or image files. Acts as a wrapper for a Loader object.
	 * 
	 * @see KSURLLoader
	 * 
	 * @author Mims Wright
	 * @since 1.7
	 */
	public class KSLoader extends KSAsynchronousFunction implements ILoaderAction
	{
		/**
		 * @inheritDoc
		 */  
		public function get resultList():Array { return _resultList; }
		public function set resultList(resultList:Array):void { _resultList = resultList; }
		protected var _resultList:Array;
		
		
		/**
		 * A reference to the actual Loader object. 
		 * You can access this directly to make adjustments to the way data is loaded
		 * and so forth.
		 */
		public function get loader():Loader { return _loader; }
		public function set loader(loader:Loader):void {  _loader = loader; }
		protected var _loader:Loader;
		
		/**
		 * Returns the loaded data. In this case the loaded data will be the 
		 * Loader object that contains the swf or image.
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
		 * @param context The LoaderContext object to use when the loader.load() method is called. Optional.
		 * @param throwErrorOnFail If set to true, errors will be dispatched if something goes wrong.
		 */
		public function KSLoader(url:URLRequest, resultList:Array = null, context:LoaderContext = null, throwErrorOnFail:Boolean = true)
		{
			loader = new Loader();
			_resultList = resultList;
			_throwErrorOnFail = throwErrorOnFail;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSuccess, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail, false, 0, true);
			
			super(loader.load, loader.contentLoaderInfo, Event.COMPLETE, url, context);
		}
		
		/**
		 * Called when the load is successful.
		 * Adds the result to the results list.
		 */
		protected function onLoadSuccess(event:Event):void {
			_data = _loader;
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
			var loader:LoaderInfo = LoaderInfo(event.target);
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
			_loader.unload();
			_loader = null;
			_resultList = null;
		}		
	}
}