package com.mimswright.sync
{
	public interface ITweenable
	{
		function set currentValue(currentValue:Number):void;
		function get currentValue():Number;
		function set startValue(startValue:Number):void;
		function get startValue():Number;
		function set endValue(endValue:Number):void;
		function get endValue():Number;
		//function set target(target:Object):void;
		//function get target():Object;
	}
}