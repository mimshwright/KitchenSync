package org.as3lib.kitchensync.action
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * A sound that will be played back at the specified offset.
	 */
	public class KSSoundController extends AbstractAction
	{
		protected var _sound:Sound;
		public function get sound():Sound { return _sound; } 
		public function set sound(sound:Sound):void { _sound = sound; }
		
		protected var _channel:SoundChannel;
		public function get channel():SoundChannel { return _channel; }
		public function set channel(channel:SoundChannel):void { _channel = channel; }
		
		protected var _soundOffset:int = 0;
		public function get soundOffset():int { return _soundOffset; }
		public function set soundOffset(soundOffset:int):void { _soundOffset = soundOffset; }
		
		protected var _soundPauseTime:int = 0;
		
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for SynchronizedSounds");
		}
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - If the sound parameter is not the correct data type.
		 * @param sound - The sound to be played.
		 * 				  Can be an object of type Sound, URLRequest, or the URL of the sound as a String.
		 * @param offset - The delay before starting the sound.
		 * @param soundOffset - The point at which to begin playing the sound in milliseconds.
		 */
		public function KSSoundController(sound:*, offset:* = 0, soundOffset:int = 0) {
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
			this.offset = offset;
			_soundOffset = soundOffset;
			_soundPauseTime = _soundOffset;
			
			_duration = 0;
		}
		
		/**
		 * When the synchronizer updates, checks to see if start time has elapsed and the song is loaded. 
		 * If so, it starts playing the song from the soundOffset and unregisters itself.
		 * If the sound hasn't loaded yet, it continues to check each frame until it is loaded, then it plays.
		 */
		override protected function onUpdate(event:KitchenSyncEvent):void {
			if (startTimeHasElapsed) {
				if (_sound.bytesLoaded == _sound.bytesTotal && _channel == null) {
					_channel = _sound.play(_soundOffset);
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
		
		override public function clone():AbstractAction {
			var clone:KSSoundController = new KSSoundController(_sound, _offset, _soundOffset);
			//clone.timeUnit = _timeUnit;
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}