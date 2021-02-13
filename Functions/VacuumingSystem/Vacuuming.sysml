package 'Vacuuming' {
	//import VacuumCleanerSystem::*;
	//import DriveUnit::systemsEngineeringDomain::*; 
	
	package 'Structure' {
		part def Filter;
		part def Tank {
			//attributes/Signals
			attribute def TankFillingSignal;
			attribute def TankFullSignal;
			attribute def EmptyingTankSignal;
			//States
			state def TankLevelChanges (usedTank : Tank);
			state def TankLevel (usedTank : Tank);
		}		
	}
	
	package 'Interactions' {
		import Structure::*;
		import Structure::Tank::*;
		
		//actually a state change structure
		state tankLevelChanges : TankLevelChanges (usedTank : Tank) {
			
			entry; then empty;
			 
			state empty : TankLevel;
																		
			accept Tank::TankFillingSignal
				then filling;
			
			state filling : TankLevel;
			
			accept TankFullSignal
				then full;
				
			state full : TankLevel;
			
			accept EmptyingTankSignal
				then empty;
		}
				
		item def Debris;
		item def AirWithDirt;
		item def CleanAir;
		
		//action def Vacuuming(in debris : Debris, out cleanAir : CleanAir);
		action def SuctionProcess(in debris : Debris, out airwithDirt : AirWithDirt);
		action def Filter(in airWithDirt : AirWithDirt, out cleanAir : CleanAir);	
		
		action def Vacuuming(in debris : Debris, out cleanAir : CleanAir){ 
			// still some errors with the bind
			bind suctionProcess::debris = debris;
			
			//Hier werden noch einige Fehler angezeigt, allerdings treten die auch in den Beispielen auf. Wie wird damit in zukunft umgegangen?
			action suctionProcess:SuctionProcess (in debris, out airWithDirt)
			
			flow suctionProcess::airWithDirt to filter::airWithDirt;			
			action filter : Filter(in airWithDirt, out cleanAir)
			
			bind filter::cleanAir = cleanAir;
		}
		// Action Allocation Example (21 in training) noch fehlerhaft
	}
		
}
	