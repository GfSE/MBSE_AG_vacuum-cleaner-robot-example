package 'VacuumingTypes' {

	//import ScalarValues::*; //Wo brauchen wir ScalarValues? Werden diese nicht eher über SI abgedeckt? (importiert ScalarValues)
	import SI::*;	// Für m³ etc.
	import ISQSpaceTime::*; // angularVelocity
	import ISQMechanics::*; // pressure
	
	package 'Ports' {
		// Internal ports for Vacuuming System
		port def RotationSpeedPort {
			out item rotationSpeed :> ISQSpaceTime::angularVelocity; // :rpm
		}
		port def SuctionPressurePort {
			out item suctionPressue :> ISQMechanics::pressure; // Kann man die Pressure hier nehmen, oder geht es dabei vorrangig um mechanische Flächendrücke?
		}
		port def InternalAirPort {
			out item internalAir :> SI::'m³'; // :m³ ?
		}
		port def DebrisPort {
			out item debris :> SI::'m³'; // dimension?
		}
		// External ports for vacuuming system
		port def SuctionLevelPort {
			out item suctionLevel; // :% (from control -> needs to be moved there)
		}
		port def ExternalAirPort {
			in item externalAir :> SI::'m³'; // :m³ ? 
		}
		port def RotationLevelPort{
			out item rotationLevel :> SI::'m³'; // :% (from control -> needs to be moved there)
		}
		// Temporarily added (from Energy Supply)
		port def EnergyInOutPort {
			out item electricalEnergy; // dimension?
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
