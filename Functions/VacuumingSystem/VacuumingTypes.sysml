package 'VacuumingTypes' {

	//import ScalarValues::*; //Wo brauchen wir ScalarValues? Werden diese nicht eher über SI abgedeckt? (importiert ScalarValues)
	import SI::*;	// Für m³ etc.
	import ISQSpaceTime::*; // angularVelocity
	import ISQMechanics::*; // pressure
	import ScalarValues::*; //Real
	
	package 'Ports' {
		// Internal ports for Vacuuming System
		// Die genutzen Types sind nicht auf Items übertragbar --> falls die item def wichtig war, gerne austauschen
		port def RotationSpeedPort {
			out rotationSpeed :> ISQSpaceTime::angularVelocity; // :rpm
		}
		
		port def SuctionPressurePort {
			out suctionPressue :> ISQMechanics::pressure; // Kann man die Pressure hier nehmen, oder geht es dabei vorrangig um mechanische Flächendrücke?
		}
		
		port def InternalAirPort {
			out item internalAir{
				attribute vol :> SI::'m³';
			}
		}
			
		port def DebrisPort {
			out item debris{
				attribute vol:> SI::'m³';
				attribute mass :> SI::kg;
			}
		}
		
		// External ports for vacuuming system
		port def SuctionLevelPort {
			out attribute suctionLevel : Real; // :% (from control -> needs to be moved there)
		}
		port def ExternalAirPort {
			in item externalAir {
				attribute vol :> SI::'m³';
			}
		}
		port def RotationLevelPort{
			out rotationLevel : Real; // :% (from control -> needs to be moved there)
		}
		// Temporarily added (from Energy Supply) and adapted
		port def EnergyInOutPort {
			out item electricalEnergy {
				attribute voltage :> SI::V;
				attribute current :> SI::A;
				attribute power :> SI::W;
			} 
		}
	}
	
	package 'Interfaces' {
		// Interface Definitions for Vacuuming System
		interface def AirIn {
			end supplierPort : Ports::ExternalAirPort;
            end consumerPort : Ports::ExternalAirPort;
		}
		interface def SuctionPressure {
			end supplierPort : Ports::SuctionPressurePort;
            end consumerPort : Ports::SuctionPressurePort;
		}
		interface def EnergySupply {
			end supplierPort : Ports::EnergyInOutPort;
            end consumerPort : Ports::EnergyInOutPort;
		}
		interface def SuctionLevel {
			end supplierPort : Ports::SuctionLevelPort;
            end consumerPort : Ports::SuctionLevelPort;
		}
		interface def AirOut {
			end supplierPort : Ports::InternalAirPort;
            end consumerPort : Ports::InternalAirPort;
		}
		interface def RotationSpeed {
			end supplierPort : Ports::RotationSpeedPort;
            end consumerPort : Ports::RotationSpeedPort;
		}
		interface def RotationLevel {
			end supplierPort : Ports::RotationLevelPort;
            end consumerPort : Ports::RotationLevelPort;
		}
	}
}
