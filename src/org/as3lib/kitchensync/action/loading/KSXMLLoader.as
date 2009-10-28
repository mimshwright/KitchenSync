package org.as3lib.kitchensync.action.loading
{
	import flash.events.Event;
	import flash.net.URLRequest;

	// todo: add docs
	public class KSXMLLoader extends KSURLLoader
	{
		public function get xml():XML {
			return new XML(_data);
		}
		
		public function KSXMLLoader(url:URLRequest, throwErrorOnFail:Boolean=true)
		{
			super(url, throwErrorOnFail);
		}
	}
}