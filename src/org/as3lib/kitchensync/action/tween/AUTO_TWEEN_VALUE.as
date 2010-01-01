package org.as3lib.kitchensync.action.tween
{
	/**
	 * When a ITweenTarget start or end value is set to this, 
	 * the value that exists at the start of the tween is used.
	 * 
	 * @example 
	 * If a sprite has position (100, 0) and you create a new tween
	 * with a target property like this:
	 * new TargetProperty (sprite, "x", AUTO_TWEEN_VALUE, 0);
	 * Then the sprite would tween from 100 to 0 when it starts.
	 * 
	 * @author Mims H. Wright
	 * @since 2.0 
	 */ 
	public const AUTO_TWEEN_VALUE:Number = NaN;
}