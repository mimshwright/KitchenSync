package org.as3lib.kitchensync.action.loading
{
	import org.as3lib.kitchensync.action.IAction;
	
	// todo: docs
	public interface ILoaderAction extends IAction
	{
		function get data():*;
		function get throwErrorOnFail():Boolean;
		function set throwErrorOnFail(throwError:Boolean):void;
	}
}