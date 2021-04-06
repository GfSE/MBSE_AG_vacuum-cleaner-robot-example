package SystemRequirements {

	import SI::*;
	import VacuumCleanerSystem::*;
	
	requirement vacuumSystemMassRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The vehicle mass shall be less than or equal to 5 kg. */
			
		//Werte von https://kaeni.de/technische-daten-zum-xiaomi-mi-vacuum-robot/
		
		require constraint { vacuumCleaner::mass <= 5@[SI::kg] }
		}
		
	requirement vacuumSystemRunTimeRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The vehicle run-time shall be equal or higher than 120 min. */
			
		require constraint { vacuumCleaner::runTimeMax >= 120@[SI::min] }
		}
		
	requirement vacuumSystemDimensionRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The vehicle dimensions shall be less or equal than 15x40cm (height x width). */
			
		require constraint { vacuumCleaner::height <= 0.15@[SI::m] }
		require constraint { vacuumCleaner::width <= 0.40@[SI::m] }
			
		}
		
	requirement vacuumSystemSuctionRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The systems suction power shall be equal or higher than 600 pa. */
			
		//https://comparisono.com/compare-robot-vacuums
		require constraint { vacuumCleaner::suctionPower >= 600@[SI::Pa] }
		}
	
	
	requirement vacuumSystemNoiseRequirement {
		subject vacuumCleaner : VacuumCleanerSystem;
		doc /* The systems noise level  shall be less or equal than 50 dB. */
			
		//https://comparisono.com/compare-robot-vacuums
		//require constraint { vacuumCleaner::suctionPower >= 50@[ISQAcoustics::dB] }
		}			
}		
	