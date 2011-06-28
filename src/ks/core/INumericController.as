package ks.core
{
	/**
	 * A wrapper that allows you to translate non-numeric values to and from numeric values. 
	 * For example, you might use this to create a numeric setter for a letter using ASCII codes or
	 * for setting a hex color channel using a decimal number.
	 * 
	 * @author Mims Wright
	 */
	public interface INumericController
	{
		/**
		 * Get the value of the object as a number.
		 * The implementation should handle the conversion from
		 * the native format to a number.
		 */
		function get currentValue():Number;
		
		/**
		 * Set the value of the object as a number.
		 * The implementation should handle the conversion from
		 * the number to the native format.
		 */
		function set currentValue(currentValue:Number):void;
		
	}
}