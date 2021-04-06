package VacuumingSystemRequirements {
	
	// Standard libraries
	import SI::*;
	
	// Local imports
	import VacuumingSystem::*;
	import SystemRequirements::*;
	
	package SuctionDeviceRequirements {
		requirement suctionPower {
			subject suctionDevice : SuctionDevice;
			doc /* ... */
		
			require constraint {}
			}
	}
	
	package FilterSystemRequirements {}
	package BrushSystemRequirements {}
	
}