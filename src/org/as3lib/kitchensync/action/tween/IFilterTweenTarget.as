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
	 */
	 // todo: review
	public interface IFilterTweenTarget extends ITweenTarget
	{
		function get filterType():Class;
	}
}