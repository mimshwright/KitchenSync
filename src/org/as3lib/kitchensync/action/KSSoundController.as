package org.as3lib.kitchensync.action
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import org.as3lib.kitchensync.KitchenSync;
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * A sound that will be played when the action executes.
	 * The sound passed to the action should be a Sound object although
	 * you can send a string or URLRequest as well (but it will be loaded
	 * when the action is created). When the sound finishes playing, the
	 * action will be completed. Meanwhile, you can access the sound
	 * object and the soundChannel object if you need more control and
	 * you can set the offset when the sound begins playing. 
	 * 
	 * @example <listing version="3.0">
	 * var sound:Sound = new Sound("mySound.mp3");
	 * 
	 * new KSSoundController(sound).start();
	 * </listing>
	 * 
	 * @author Mims Wright
	 * @since 0.2
	 */
	 // todo: does it make sense to have this be a precision action?
	public class KSSoundController extends AbstractAction implements IPrecisionAction
	{
		/**
		 * A pointer to the sound object passed into the constructor or created based on the URL.
		 */
		public function get sound():Sound { return _sound; } 
		public function set sound(sound:Sound):void { _sound = sound; }
		protected var _sound:Sound;
		
		/**
		 * A pointer to the sound channel created by the sound object when it is played.
		 */
		public function get channel():SoundChannel { return _channel; }
		public function set channel(channel:SoundChannel):void { _channel = channel; }
		protected var _channel:SoundChannel;
		
		/**
		 * The offset of the sound object when it is played. For example,
		 * if this is 1000, the sound will play 1 second from the beginning of the audio file.
		 * Uses the time parser so string values are okay too.
		 * 
		 * @see org.as3lib.kitchensync.util.ITimeStringParser
		 * @see #delay
		 */
		public function get soundOffset():int { return _soundOffset; }
		public function set soundOffset(soundOffset:*):void {
			if (!isNaN(soundOffset)) {
				_soundOffset = soundOffset;
			} else {
				var timeString:String = soundOffset.toString();
				_soundOffset = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			// if < 0, make it equal to 0. 
			_soundOffset = Math.max(0, _soundOffset);
		}
		protected var _soundOffset:int = 0;
		
		/** Used internally to track the paused time of the audio. */
		protected var _soundPauseTime:int = 0;
		
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for this type of action");
		}
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - If the sound parameter is not the correct data type.
		 * 
		 * @param sound - The sound to be played.
		 * 				  Can be an object of type Sound, URLRequest, or the URL of the sound as a String.
		 * 				  For best performance, use a preloaded sound.
		 * @param delay - The delay before starting the sound.
		 * @param soundOffset - The point at which to begin playing the sound in milliseconds.
		 */
		public function KSSoundController(sound:*, delay:* = 0, soundOffset:* = 0) {
			super();
			if (sound is Sound) {
				_sound = Sound(sound);
			} else if (sound is URLRequest) {
				_sound = new Sound (URLRequest(sound));
			} else if (sound is String) {
				_sound = new Sound (new URLRequest(String(sound)));
			} else {
				throw new TypeError("The sound parameter must be of type Sound, URLRequest or String.");
			}
			this.delay = delay;
			this.soundOffset = soundOffset;
			_soundPauseTime = _soundOffset;
			
			_duration = 0;
		}
		
		/**
		 * When the synchronizer updates, checks to see if start time has elapsed and the song is loaded. 
		 * If so, it starts playing the song from the soundOffset and unregisters itself.
		 * If the sound hasn't loaded yet, it continues to check each frame until it is loaded, then it plays.
		 */
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed(currentTime) ) {
				if (_sound.bytesLoaded == _sound.bytesTotal && _channel == null) {
					// todo: test
					// adds some precision to the start time of this sound
					var adjustedSoundOffset:int = _soundOffset + (currentTime - _startTime - _delay)
					_channel = _sound.play(adjustedSoundOffset);
					_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					unregister();
				}
			}
		}
		
		/**
		 * The event is considered complete when the sound's SOUND_COMPLETE event is fired.
		 */
		protected function onSoundComplete(event:Event):void {
			complete();
		}
		
		/**
		 * Override the pause functions to pause the actual sound as well as the action.
		 */
		 override public function pause():void {
		 	super.pause();
		 	if (_channel) {
			 	_soundPauseTime = _channel.position;
			 	_channel.stop();
		 	}
		 }

		/**
		 * Override the pause functions to pause the actual sound as well as the action.
		 */
		 override public function unpause():void {
		 	super.unpause();
		 	if (_channel) {
		 		_channel = _sound.play(_soundPauseTime);
		 		_soundPauseTime = _soundOffset;
		 	}
		 } 

		/** @inheritDoc */
		// todo test
		public function startAtTime(startTime:int):IPrecisionAction {
			start();
			_startTime = startTime;
			return this;
		}

		/**
		 * Override the pause functions to pause the actual sound as well as the action.
		 */
		 override public function stop():void {
		 	super.stop();
		 	if (_channel) {
		 		_channel.stop();
		 		_soundPauseTime = _soundOffset;
		 	}
		 } 
		
		/**
		 * Override the kill method to remove references to the sound and channel objects.
		 */
		override public function kill():void {
			super.kill();
			stop();
			_channel = null;
			_sound = null;
		}
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clone:KSSoundController = new KSSoundController(_sound, _delay, _soundOffset);
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}