package VacuumCleanerSystem {
	import DriveUnit::*;
	import VacuumingSystem::*;
		
	part def VacuumCleanerSystem {
		attribute mass :> ISQ::mass;
		attribute runTimeMax :> ISQ::time;
		attribute height :> ISQ::length;
		attribute width :> ISQ::length;	
		attribute suctionPower :> ISQ::pressure;
		attribute noiseLevel :> ISQ::soundPowerLevel;
		
		// Additional parts from subsystems needs to be added
	}
	
	
	part vacuumCleanerSystem : VacuumCleanerSystem {
		part vacuuming : VacuumingSystem;
		//part driveUnit : DriveUnit;
		//part nav : NavigationSystem;
		//part energ : EnergySupplySystem;
	}
	
}