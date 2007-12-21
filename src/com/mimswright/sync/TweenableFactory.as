package com.mimswright.sync
{
	import flash.display.DisplayObject;
	
	
	
	/** 
	 * Manages the instantiation of ITweenable objects.
	 * 
	 * @example <listing version="3.0">
	 * 		var tweenTarget:ITweenable = TweenableFactory.
	 * 		</listing>
	 * 
	 * @see ITweenable
	 * @see TweenableType
	 * @see Tween
	 */
	public class TweenableFactory
	{
		private static var _instance:TweenableFactory;
		public static function get instance():TweenableFactory { 
			if (!_instance) { _instance = new TweenableFactory(new SingletonEnforcer()); }
			return _instance; 
		}
		public function TweenableFactory (singletonEnforcer:SingletonEnforcer) {}
		
		public function getTweenable(target:Object, property:String):ITweenable {
			/*	
			if (target is DisplayObject) {
				switch ( property ) {
					break;
				}
			}
			*/

			if (target[property] is Number) {
				return new TargetProperty(target, property);
			} else { 
				throw new TypeError("The specified target's property must be a number.");
			}
		}
	}
}
class SingletonEnforcer {}