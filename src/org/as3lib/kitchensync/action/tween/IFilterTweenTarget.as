package org.as3lib.kitchensync.action.tween
{
	/**
	 * A tween target that affects a BitmapFilter object.
	 * This allows you to tween values of a bitmap filter.
	 * 
	 * @see flash.display.BitmapFilter
	 * @see FilterTargetProperty
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 */
	public interface IFilterTweenTarget extends ITweenTarget
	{
		/**
		 * This is the class type of the filter that will be 
		 * receiving the tween, such as BlurFilter. This has to be a 
		 * class instead of an instance because of the somewhat 
		 * complicated way that the filters are applied to a display object.
		 */
		function get filterType():Class;
	}
}