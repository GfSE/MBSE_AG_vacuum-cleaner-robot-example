package 'FilterSystem' {
	
	package 'Ports' {
	//Ports (temporarily taken from VacuumTypes)
		port def ExternalAirPort {
			out item externalAir; // :m³ ? 
		}
		port def InternalAirPort {
			in item internalAir; // :m³ ?
		}
		
		port def Debris {
			inout item debris;
		}
	}

	package 'Structure' {
		
		part def Tank {
			/* The Tank stores debris that has been filtered */
			//attributes/Signals
			// Vom Filter in den Tank
			port debrisIn : Ports::Debris;
			// Zum Tank s�ubern
			port debrisOut : Ports::Debris;
			
			
			// F�r die Interactions wichtig, wo soll das am besten untergebracht werden?
			//attribute def TankFillingSignal;
			//attribute def TankFullSignal;
			//attribute def EmptyingTankSignal;
			
			//States
			//state def TankLevelChanges (usedTank : Tank);
			//state def TankLevel (usedTank : Tank);
		}
		
		part def Filter {
			/* The Filter separates the air from the debris*/
	
			port dirtAir : Ports::InternalAirPort;
			port debrisOut : Ports::Debris;
			port cleanAir : Ports::ExternalAirPort;
				
		}		
		
		part def FilterSystem
		{
			part filter : Filter;
			part tank : Tank;		
			
			port airIn : Ports::InternalAirPort;
			port airOut : Ports::ExternalAirPort;
				
			connect filter::debrisOut to tank::debrisIn;
		}
	}
}