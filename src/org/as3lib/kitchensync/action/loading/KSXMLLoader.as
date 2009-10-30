package org.as3lib.kitchensync.action.loading
{
	import flash.net.URLRequest;

	/**
	 * A KitchenSync aciton to load an XML file. Essentially the same as KSURLLoader
	 * but with a built-in option to return the results as an XML object.
	 * 
	 * @see KSURLLoader
	 */
	public class KSXMLLoader extends KSURLLoader
	{
		/**
		 * Returns the results of the loader as an XML object.
		 */
		public function get xml():XML {
			return new XML(_data);
		}
		
		/**
		 * @copy KSURLLoader.KSURLLoader()
		 */
		public function KSXMLLoader(url:URLRequest, resultList:Array = null, throwErrorOnFail:Boolean=true)
		{
			super(url, resultList, throwErrorOnFail);
		}
	}
}