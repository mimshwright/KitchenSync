package org.as3lib.kitchensync.action.tween
{
	import flash.media.SoundTransform;
	
	
	/** 
	 * A tween target for setting sound properties of a SoundTransform object (e.g. 'volume'). 
	 * You will provide an object that has a soundTransform property and a property to change.
	 * 
	 * known issue: high speed transitions, such as oscicators with high frequencies,
	 * can cause clicks and distortion in the sound.
	 * 
	 * @example <listing version="3.0">
	 * 
	 * var sound:Sound;
	 * // load your sound here...
	 * 
	 * // fade up over 5 seconds
	 * var fadeUp:ITweenTarget = new SoundTransformTarget(sound, SoundTransformProperty.VOLUME, 0, 1);
	 * var tween:KSTween = TweenFactory.newTweenWithTargets(fadeUp, "5s");
	 * tween.start(); 
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 * @see org.as3lib.kitchensync.action.tween.SoundTransformProperty
	 */
	public class SoundTransformTarget implements ITweenTarget
	{
	
		/**
		 * The target object to which to apply the SoundTransform. 
		 */
		public function get targetSound():Object { return _targetSound; }
		public function set targetSound(channel:Object):void { _targetSound = channel; }
		protected var _targetSound:Object;
		
		/**
		 * The property to tween. Use SoundTransformProperty values.
		 * 
		 * @see org.as3lib.kitchensync.action.tween.SoundTransformProperty
		 */
		public function get property():SoundTransformProperty { return _property; }
		public function set property(property:SoundTransformProperty):void { _property = property; }
		protected var _property:SoundTransformProperty;
		
		/**
		 * The value to start from when tweening.
		 */ 
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		/**
		 * The value to end on when tweening.
		 */		
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void	{ _endValue = endValue; }
		protected var _endValue:Number;
		
		/**
		 * The total amount of change between the start and end values. (used internally)
		 */
		public function get differenceInValues():Number { return _endValue - _startValue; }
		
		/**
		 * Constructor.
		 *
		 * @param targetSound The object to which to apply the transform (Usually a SoundChannel or NetStream). 
		 * 					  Note that there is no type checking on this parameter and you should use an object that
		 * 					  has a soundTransform property.
		 * @param property The property of the sound channel. either pan or volume.
		 * @param startValue the value to start from when tweening
		 * @param endValue the value to end on when tweening 
		 */
		public function SoundTransformTarget (targetSound:Object, property:SoundTransformProperty = null, startValue:Number = NaN, endValue:Number = NaN) {
			_targetSound = targetSound;
			
			if (_targetSound.soundTransform == null) {
				_targetSound.soundTransform = new SoundTransform();
			}
			
			if (property == null) {
				property = SoundTransformProperty.VOLUME;
			}
			
			this.property = property;
			_startValue = (isNaN(startValue)) ? currentValue : startValue;
			_endValue   = (isNaN(endValue))   ? currentValue : endValue;
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
			return currentValue = percentComplete * differenceInValues + startValue;
		}
		
		/**
		 * The current value of the property you specified. 
		 */
		public function get currentValue():Number { 
			return Number(_targetSound.soundTransform[property.toString()]);
		}
		public function set currentValue(currentValue:Number):void { 
			if (_targetSound.soundTransform == null) {
				_targetSound.soundTransform = new SoundTransform();
			}
			var transform:SoundTransform = _targetSound.soundTransform;
			
			transform[property.toString()] = currentValue;
			
			_targetSound.soundTransform = transform;
		}
		
		/**
		 * Returns the current value to the start value. 
		 */
		public function reset():void
		{
			currentValue = startValue;
		}
		
		public function clone():ITweenTarget
		{ 
			return new SoundTransformTarget(_targetSound, _property, _startValue, _endValue);
			
		}
	}
}