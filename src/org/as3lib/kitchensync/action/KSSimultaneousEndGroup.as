package org.as3lib.kitchensync.action
{
	/**
	 * A parallel group where all children END at the same time instead of starting
	 * at the same time. 
	 * 
	 * @author Mims Wright
	 * @since 1.6
	 */
	 // todo implement 
	public class KSSimultaneousEndGroup extends KSParallelGroup
	{
		public function KSSimultaneousEndGroup(...children)
		{
			super(children);
		}
		
	}
}