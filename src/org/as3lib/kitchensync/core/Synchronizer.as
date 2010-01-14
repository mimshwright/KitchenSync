package org.as3lib.kitchensync.core
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.as3lib.kitchensync.KitchenSync;
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	
	// todo : implement IPauseable
	
	/**
	 * @eventType org.as3lib.kitchensync.core.KitchenSyncEvent.SYNCHRONIZER_UPDATE
	 */
	[Event(name="synchronizerUpdate", type="org.as3lib.kitchensync.core.KitchenSyncEvent")]
	
	/**
	 * Synchronizer acts as the main time keeper for the animation engine. 
	 * Normally, this class will not be used directly except by advanced users.
	 * The SynchronizerCore isolates the function that times the dispatches. 
	 * To initialize the class, use KitchenSync.initialize() or initializeWithCore().
	 * 
	 * @see org.as3lib.kitchensync.KitchenSync#initialize()
	 * 
	 * @author Mims H. Wright
	 * @since 0.1
	 */
	public final class Synchronizer extends EventDispatcher
	{
		
		private static var _instance:Synchronizer = null;
		
		/**
		 * The ISynchronizerCore that causes the Synchronizer to dispatch
		 * events.
		 */
		public function get core():ISynchronizerCore { return _core; }
		public function set core(core:ISynchronizerCore):void { 
			// remove the old core.
			if (_core) _core.stop();
			_core = core; 
			_core.start();
		}
		private var _core:ISynchronizerCore;
		
		/**
		 * The official timestamp for the current moment in the synchronizer.
		 * This time will be dispatched to actions when they are updated so that
		 * everything happens in sync.
		 */
		public function get currentTime():int { return _currentTime; }
		private var _currentTime:int = 0;
		
		/**
		 * The number of times that the update has been dispatched since the
		 * start of the program. This replaces the <code>frames</code> property in 
		 * v2.0 where different cores can cause different types of updates.
		 */
		public function get cycles():int { return _cycles; }
		private var _cycles:int = 0;

		/** A list of clients that are registered to listen for updates. */
		private var _clients:Dictionary = new Dictionary(KitchenSyncDefaults.syncrhonizerUsesWeakReferences);
		
		/** Returns the number of active actions. */
		public function get activeClients():int { 
			var count:int = 0;
			for each (var client:* in _clients) count++;
			return count;
		}
		
		/**
		 * Constructor. SingletonEnforcer prevents this class from being instantiated without
		 * using the initialize() method.
		 * 
		 * @param enforcer - a SingletonEnforcer can only be created internally.
		 */
		public function Synchronizer(enforcer:SingletonEnforcer) { 
			super(); 
		}
		
		
		/**
		 * Returns an instance to the single instance of the class. 
		 * 
		 * @return a reference to the only instance of the Synchronizer.
		 */
		public static function getInstance():Synchronizer {
			if (_instance == null) {
				_instance = new Synchronizer(new SingletonEnforcer()); 
			}
			return _instance;
		}
		
		
		/**
		 * Adds a Syncrhonizer client to the list that will be updated when the dispatchUpdate() method is called.
		 * 
		 * @param client The client that will receive the update.
		 */ 
		public function registerClient(client:ISynchronizerClient):void {
			if (_core && KitchenSync.isInitialized) {
				_clients[client] = client;
			} else {
				throw new Error("KitchenSync has not been initialized yet and actions will not receive updates. Please run KitchenSync.initialize() in the main function of your program (or in the first frame).");
			}
		}
		
		/**
		 * Removes a Syncrhonizer client from the list.
		 * 
		 * @param client The client that will be unregistered.
		 */ 
		public function unregisterClient(client:ISynchronizerClient):void {
			delete _clients[client];
		}
		
	
		/**
		 * Dispatches events to children for them to update.
		 */
		internal function dispatchUpdate():void {
			_currentTime = getTimer();
			_cycles++;
			
			// update registered clients.
			for each (var client:ISynchronizerClient in _clients) {
				client.update(currentTime);
			}
			
			// dispatch event to event listeners.
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.SYNCHRONIZER_UPDATE, currentTime));
			
			//trace(currentTime);			
		}

	}
}
class SingletonEnforcer {}