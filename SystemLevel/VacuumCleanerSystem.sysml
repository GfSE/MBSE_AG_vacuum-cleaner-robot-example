package 'VacuumCleanerSystem' {
	//Was ist für den Import noch erforderlich?
	import  DriveUnit::*;
		
	part def VacuumCleanerSystem {
		attribute mass :> ISQ::mass;
		attribute runTimeMax :> ISQ::time;
		attribute height :> ISQ::length;
		attribute width :> ISQ::length;	
		attribute suctionPower :> ISQ::pressure;
		attribute noiseLevel :> ISQ::soundPowerLevel;
	}
	//Werte von https://kaeni.de/technische-daten-zum-xiaomi-mi-vacuum-robot/
	requirement vacuumSystemMassRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The vehicle mass shall be less than or equal to 5 kg. */
		
		require constraint { vacuumCleaner::mass <= 5@[SI::kg] }
	}
	
	requirement vacuumSystemRunTimeRequirement {
		subject vacuumCleaner : VacuumingCleanerSystem;
		doc /* The vehicle run-time shall be equal or higher than 120 min. */
		
		//Welche Abwandlungen von SI-Einheiten sind alle als SI modellierbar? cm nicht, min anscheinend schon
		require constraint { vacuumCleaner::runTimeMax >= 120@[SI::min] }
	}
	
	requirement vacuumSystemDimensionRequirement {
		subject vacuumCleaner : VacuumingCleanerSystem;
		doc /* The vehicle dimensions shall be less or equal than 15x40cm (height x width). */
		
		require constraint { vacuumCleaner::height <= 0.15@[SI::m] }
		require constraint { vacuumCleaner::width <= 0.40@[SI::m] }
		
	}
	//https://comparisono.com/compare-robot-vacuums
	requirement vacuumSystemSuctionRequirement {
		subject vacuumCleaner : VacuumingCleanerSystem;
		doc /* The systems suction power shall be equal or higher than 600 pa. */
		
		require constraint { vacuumCleaner::suctionPower >= 600@[SI::Pa] }
	}

	//https://comparisono.com/compare-robot-vacuums
	requirement vacuumSystemNoiseRequirement {
		subject vacuumCleaner : VacuumingCleanerSystem;
		doc /* The systems noise level  shall be less or equal than 50 dB. */
		
		//require constraint { vacuumCleaner::suctionPower >= 50@[ISQAcoustics::dB] }
	}			
}