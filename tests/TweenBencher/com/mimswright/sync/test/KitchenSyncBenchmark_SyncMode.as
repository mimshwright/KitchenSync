/**
* Benchmark test for use with Moses Gunesch's Go benchmark tester. http://go.mosessupposes.com/?p=5 
* To use this class, you'll need to download the appropriate files from the google code site 
* http://code.google.com/p/goasap/
*/
package com.mimswright.sync.test {	
	import com.mosesSupposes.benchmark.tweenbencher.*;	
	import com.mimswright.sync.test.*;
	/**
	 * @author Moses Gunesch / mosessupposes.com (c) 
	 */
	public class KitchenSyncBenchmark_SyncMode extends KitchenSyncBenchmark {
		
		public function KitchenSyncBenchmark_SyncMode(tweenBencher : TweenBencher) 
		{
			super(tweenBencher, "KitchenSync (sync mode)");
			syncMode = true;
		}
	}
}
