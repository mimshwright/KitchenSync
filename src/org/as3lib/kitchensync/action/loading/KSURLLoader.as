package org.as3lib.kitchensync.action.loading
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import org.as3lib.kitchensync.action.*;
	
	public class KSURLLoader extends KSAsynchronousFunction implements ILoaderAction
	{
		public function KSURLLoader(url:URLRequest, throwErrorOnFail:Boolean = true)
		{
			_throwErrorOnFail = throwErrorOnFail;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadSuccess, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFail, false, 0, true);
			
			super(0, loader.load, loader, Event.COMPLETE, url);
		}

		protected function onLoadSuccess(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			_data = loader.data;
		}
		
		protected function onLoadFail(event:IOErrorEvent):void {
			var loader:URLLoader = URLLoader(event.target);
			if (_throwErrorOnFail) {
				throw new IOError(event.text);
			} else {
				complete();
			}
		}
		
		public function get data():* { return _data; } 
		protected var _data:* = null;
		
		public function get throwErrorOnFail():Boolean { return _throwErrorOnFail; }
		public function set throwErrorOnFail(throwError:Boolean):void { _throwErrorOnFail = throwError; }
		protected var _throwErrorOnFail:Boolean;
		
		override public function kill():void {
			super.kill();
			_data = null;
		}
	}
}