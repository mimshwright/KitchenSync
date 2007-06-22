package com.mimswright.sync
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.Event;
	
	/**
	 * TODO: Add documentation.
	 * TODO: Test
	 * TODO: deal with the case of a song that's not loaded when it's time to play comes.
	 * todo: add other accessors for the sound's properties.
	 */
	public class SynchronizedSound extends AbstractSynchronizedAction
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
		
		override public function set duration(duration:int):void {
			throw new Error("duration is ignored for SynchronizedSounds");
		}
		
		public function SynchronizedSound(sound:Sound, offset:int = 0, soundOffset:int = 0) {
			_sound = sound;
			_offset = offset;
			_soundOffset = soundOffset;
			
			_duration = 0;
		}
		
		override internal function onUpdate(event:SynchronizerEvent):void {
			if (_startTimeHasElapsed) {
				if (_sound.bytesLoaded = _sound.bytesTotal) {
					_channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					_channel = _sound.play(_soundOffset);
				}
			}
		}
		
		protected function onSoundComplete(event:Event):void {
			complete();
		}
		
		override public function kill():void {
			super.kill();
			_sound = null;
			_channel = null;
		}
	}
}