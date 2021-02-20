package 'FilterSystem' {
	// Auf dem Linux System mit Version 2020-12 wollen nicht mal die ISQ und SI imports funktionieren --> sollte mit dem neuen RC geprüft werden
	import SI::*;
	
	package 'Ports' {
	//Ports (temporarily taken from VacuumTypes)
		port def ExternalAirPort {
			// Unterschied zwischen out item zu out? In sysml/src/examples/'Vehicle Example'/VehicleDefinitions.sysml (2020-12 Pilot) wird nur out verwendet
			out externalAir :> SI::'m³'; 
			
		}
		port def InternalAirPort {
			in internalAir :> SI::'m³';
		}
		
		port def DebrisPort {
			inout item debris :> SI::'m³';
		}
	}

	package 'Interfaces' {
		// Interface complementary to suction device
		interface def AirOut {
			end supplierPort : Ports::ExternalAirPort;
            end consumerPort : Ports::ExternalAirPort;
		}
		interface def AirIn {
			end supplierPort : Ports::InternalAirPort;
            end consumerPort : Ports::InternalAirPort;
		}
		interface def DebrisOut {
			end supplierPort : Ports::DebrisPort;
            end consumerPort : Ports::DebrisPort;
		}
		
	}

	package 'Structure' {
		
		part def Tank {
			/* The Tank stores debris that has been filtered */
			//attributes/Signals
			// Vom Filter in den Tank
			port debrisIn : Ports::DebrisPort;
			// Zum Tank s�ubern
			port debrisOut : Ports::DebrisPort;
			
			
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
			port debrisOut : Ports::DebrisPort;
			port cleanAir : Ports::ExternalAirPort;
				
		}		
		
		part def FilterSystem
		{
			part filter : Filter;
			part tank : Tank;		
			
			port airIn : Ports::InternalAirPort;
			port airOut : Ports::ExternalAirPort;
			
			interface : Interfaces::AirIn connect supplierPort => airIn to consumerPort => airOut;
		}
	}
}