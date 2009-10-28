package org.as3lib.kitchensync.action.tween
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import org.as3lib.math.limit;
	
	/**
	 * Tween target for adjusting the color of a DisplayObject using a ColorTransform.
	 * 
	 * @since 1.7
	 * @author Mims Wright
	 */ 
	 // todo: review
	 // todo: add example
	public class TintTweenTarget implements ITweenTarget
	{
		/**
		 * A special value that when used as either the start or end values will
		 * take the current ColorTransform of the target object at the time that 
		 * the tween begins.
		 */
		[Inspectable(name="Use the ColorTransform of the target at the time of the tween.")]
		public static const CURRENT_TINT:String = "currentTint";
		
		/**
		 * A special value that when used as either the start or end values will
		 * remove any colorTransform from the object.
		 */
		[Inspectable(name="No tint (the default ColorTransform)")]
		public static const NO_TINT:String = "noTint";
		
		/**
		 * The target DisplayObject on which the ColorTransform is applied.
		 */
		public function get target ():DisplayObject { return _target; }
		protected var _target:DisplayObject;
		
		
		/**
		 * This is the current value of the tint as a hex color (uint).
		 * Derived from the currentTransform.
		 * 
		 * @see #currentTransform
		 */
		public function get currentValue():Number { return _currentTransform.color;}
		public function set currentValue(currentValue:Number):void { 
			_currentTransform.color = currentValue;
			updateTarget();
		}
		
		/**
		 * This is the current ColorTransform object.
		 * The setter for this property should not normally be used but will update the target DisplayObject.
		 */
		public function get currentTransform():ColorTransform { return _currentTransform; }
		public function set currentTransform(currentTransform:ColorTransform):void {
			_currentTransform = currentTransform;
			updateTarget();
		}
		protected var _currentTransform:ColorTransform;
		
		
		/**
		 * The value that the tweenTarget will begin from represented as a
		 * hex color. Derived from the startTransform.
		 */
		public function get startValue():Number { 
			if (_startTransform) { return _startTransform.color; }
			return new ColorTransform().color; 
		}
		public function set startValue(startValue:Number):void { _startTransform.color = uint(startValue);}
		
		/**
		 * The value that the tweenTarget will begin from.
		 * See constructor for information about acceptable values for startTransform.
		 */
		public function get startTransform():ColorTransform { return _startTransform; }
		public function set startTransform(startTranformValue:*):void { 
			if (startTranformValue == CURRENT_TINT || startTranformValue == null) {
				// Delay the setting of the start color until the tween begins.
				// Note: this is deferred until the start of the tween so that the tint used 
				// will be the one at the time of the start of the tween not at the time of instantiation.
				_startOnCurrentTint = true;
			
			} else if (startTranformValue == NO_TINT) {
				// If the start value is NO_TINT use the identity color transform (i.e., use the default tint.)
				_startTransform = new ColorTransform();
			
			} else if (startTranformValue is ColorTransform) {
				// if the start value is a ColorTransform object, use that object
				_startTransform = startTranformValue as ColorTransform;
				
			} else if (startTranformValue is uint) {
				// if the start value is a number, use that number as the color of the tint.
				_startTransform = new ColorTransform();
				this.startValue = uint(startTranformValue);
				_startTransform.alphaMultiplier = _target.alpha;
			} else {
				throw new TypeError("Type used for startValue is invalid. This value must be of type ColorTransform, uint, or one of the special strings CURRENT_TINT or NO_TINT");  
			}
		}
		protected var _startTransform:ColorTransform;
		
		/**
		 * The value that the tweenTarget will tween to represented as a
		 * hex color. Derived from the endTransform. 
		 */
		public function get endValue():Number {
			if (_endTransform) { return _endTransform.color; }
			return new ColorTransform().color;
		}
		public function set endValue(endValue:Number):void { _endTransform.color = uint(endValue); }

		/**
		 * The value that the tweenTarget will tween to
		 * See constructor for information about acceptable values for endTransform.
		 */
		public function get endTransform():ColorTransform { return _endTransform; }
		public function set endTransform(endTransformValue:*):void { 
			if (endTransformValue == CURRENT_TINT || endTransformValue == null) {
				// delay the setting of the end color until the tween begins.
				_endOnCurrentTint = true;
			} else if (endTransformValue == NO_TINT) {
				_endTransform = new ColorTransform();
				
			} else if (endTransformValue is ColorTransform) {
				// Note: the tintOpacity isn't used if a color transform is provided.
				_endTransform = endTransformValue as ColorTransform;
				
			} else if (endTransformValue is uint) {
				_endTransform = new ColorTransform();
				this.endValue = uint(endTransformValue);
				_endTransform.alphaMultiplier = _target.alpha;
				applyTintOpacity();
				
			} else {
				throw new TypeError("Type used for endValue is invalid or is null. This value must be of type ColorTransform, uint, or one of the special strings CURRENT_TINT or NO_TINT");  
			} 
		}
		protected var _endTransform:ColorTransform;


		/**
		 * A modifier (between 0 and 1) to the tint color that affects its intensity. For example, 
		 * a tint of 0xFF0000 and a tintAmount of 0.5 would appear as a red tint with 50% opacity.
		 * This only affects the endValue.
		 * The default value is 1.0 or 100% opacity.
		 */ 
		protected var _tintOpacity:Number = 1.0;
		
		
		/** Used internally when using the CURRENT_TINT value. */
		protected var _startOnCurrentTint:Boolean = false;
		/** Used internally when using the CURRENT_TINT value. */
		protected var _endOnCurrentTint:Boolean = false;

		
		/**
		 * Constructor.
		 * 
		 * @param target The display object to affect.
		 * @param startValue The color to begin on. This can be a color hex value (uint), a ColorTransform object, or one of the 
		 * 					 special values CURRENT_TINT or NO_TINT. null values will also be interpreted as CURRENT_TINT.
		 * @param endValue The color to tint to. See notes for startValue. 
		 * @param tintOpacity A modifier for the opacity of the endValue tint color. Ignored if endValue is a ColorTransform.
		 * 
		 * @see #CURRENT_TINT
		 * @see #NO_TINT
		 */
		public function TintTweenTarget(target:DisplayObject, startValue:* = CURRENT_TINT, endValue:* = NO_TINT, tintOpacity:Number = 1)
		{
			super();
			
			_target = target;
			
			_currentTransform = new ColorTransform();
			
			// Normalize tint opacity between 0 and 1.
			_tintOpacity = limit(tintOpacity, 0, 1);
			
			this.startTransform = startValue; 
			this.endTransform = endValue;
		}
			
		/**
		 * The main function that the Tween uses to update the TweenTarget. 
		 * Sets the percentage complete.
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update
		 * @return Number the new current value of the tween.
		 */
		public function updateTween(percentComplete:Number):Number {
			
			// check to see if the current tint should be used for start or end properties. 
			if (_startOnCurrentTint || _startTransform == null) {
				_startTransform = target.transform.colorTransform;
				_startOnCurrentTint = false;
			}
			
			if (_endOnCurrentTint || _endTransform == null) {
				_endTransform = target.transform.colorTransform;
				_endOnCurrentTint = false;
				applyTintOpacity();
			}
			
			// interpolate values for all properties
			var redMultiplier:Number = interpolate("redMultiplier"); 
			var greenMultiplier:Number = interpolate("greenMultiplier");
			var blueMultiplier:Number = interpolate("blueMultiplier");
			var alphaMultiplier:Number = interpolate("alphaMultiplier");
			var redOffset:Number = interpolate("redOffset");
			var greenOffset:Number = interpolate("greenOffset");
			var blueOffset:Number = interpolate("blueOffset");
			var alphaOffset:Number = interpolate("alphaOffset");
			
			// change the colorTransform to match the new interpolated values.
			currentTransform = new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
			return currentValue; 
			
			/**
			 * Returns the interpolated value between the start and end transform objects for a given property.
			 * Only used within the updateTween() function.
			 */
			function interpolate(property:String):Number {
				var startProperty:Number = Number(_startTransform[property]);
				var endProperty:Number = Number(_endTransform[property]);
				return percentComplete * ( endProperty - startProperty) + startProperty;
			}
		}
		
		/**
		 * Applies the tintOpacity value to the endTransform. Used internally only.
		 */
		protected function applyTintOpacity():void {
			// Note: use the inverse of the tint opacity. that's because when you use the color property
			// of a color transform it sets the multipliers to 0. 
			var inverseOfTintOpacity:Number = (1 - _tintOpacity);
			
			// increase the intensity of the original colors of the DO.
			endTransform.redMultiplier += inverseOfTintOpacity;
			endTransform.greenMultiplier += inverseOfTintOpacity;
			endTransform.blueMultiplier += inverseOfTintOpacity;
			endTransform.alphaMultiplier += inverseOfTintOpacity;
			
			// reduce the intensity of the tint colors
			endTransform.redOffset *= _tintOpacity;
			endTransform.blueOffset *= _tintOpacity;
			endTransform.greenOffset *= _tintOpacity;
			endTransform.alphaOffset *= _tintOpacity;
		}
		
		/**
		 * Sets the ColorTransform on the target to the _currentTransform value.
		 */
		protected function updateTarget():void {
			_target.transform.colorTransform = _currentTransform;
		}
		
		
		/** 
		 * Reset the value to it's pre-tweened state.
		 */
		public function reset():void { 
			currentTransform = _startTransform;
		}
		
		/** Create a copy of the tweenTarget object */
		public function clone():ITweenTarget {
			var start:ColorTransform = 	startTransform == null ? null :	new ColorTransform(	startTransform.redMultiplier, startTransform.greenMultiplier, 
																							startTransform.blueMultiplier, startTransform.alphaMultiplier,
														  								  	startTransform.redOffset, startTransform.greenOffset, 
														  								  	startTransform.blueOffset, startTransform.alphaOffset);
														  								  	
			var end:ColorTransform = 	endTransform == null ? null : 	new ColorTransform(	endTransform.redMultiplier, endTransform.greenMultiplier, 
																							endTransform.blueMultiplier, endTransform.alphaMultiplier,
																							endTransform.redOffset, endTransform.greenOffset, 
																							endTransform.blueOffset, endTransform.alphaOffset);
			return new TintTweenTarget(target, start, end);
		}
	}
}