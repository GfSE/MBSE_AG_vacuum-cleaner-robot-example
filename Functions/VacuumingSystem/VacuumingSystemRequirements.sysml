package VacuumingSystemRequirements {
	
	// Standard libraries
	import SI::*;
	import Requirements::*;
	
	// Local import
	import VacuumingSystem::*;
	import SystemRequirements::*;
	
	package SuctionDeviceRequirements {
	// Requirements for suction device
		requirement id 'sd1' SuctionPower : PhysicalRequirementCheck {
			subject suctionMotor : SuctionMotor;
			doc /* The maximum suction power shall be at least 1000W */
		
			require constraint {suctionMotor::par_maximumPower >= 1000@[SI::W]}
		}
	}
	
	// 
	// How to use requirement defs from "Requirements", e.g. PhysicalRequirementCheck?
	// How to link requirements (subsystem) to other requirements (system), e.g. "derive"?
	//
	
	package BrushSystemRequirements {}
	package FilterSystemRequirements {}
}