package 'Vacuuming' {
	import VacuumCleanerSystem::*;
	import DriveUnit::systemsEngineeringDomain::*; 
	
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
		
		//using Signals from Tank
		state def TankLevelChanges (usedTank : Tank) {
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
		// Potentieller Bug (siehe DriveUnit): Status müssen aktuell bei ihrem auftreten definiert werden --> Am Anfang alle States zu definiert führt zu einer Schleife
		state def TankLevelChangesTrans (usedTank : Tank) {
			entry; then empty;
			 
			state empty : TankLevel;
					
			transition empty_to_filling
				first empty
				then filling;
			
			state filling : TankLevel;
																			
			transition filling_to_full	
				first filling
				then full;
			
			state full : TankLevel;
			
			transition full_to_empty	
				first full
				then empty;
		}
		
		// Example at 'Action Definition Example-1.sysml'		
		item def Debris;
		item def AirWithDirt;
		item def CleanAir;
		
		action def SuctionProcess(in debris : Debris, out airwithDirt : AirWithDirt);
		action def Filter(in airWithDirt : AirWithDirt, out cleanAir : CleanAir);	
		
		action def Vacuuming(in debris : Debris, out cleanAir : CleanAir){ 
					
			action suctionProcess : SuctionProcess (in debris, out airWithDirt);
			action filterAct : Filter(in airWithDirt, out cleanAir);
			
			bind suctionProcess::debris = debris;
			bind filterAct::cleanAir = cleanAir;
			
			flow suctionProcess::airWithDirt to filterAct::airWithDirt;			
			
		}
	}
		
}
	