package 'VacuumingTypes' {

	// import ScalarValues::*;
	
	package 'Ports' {
		// Internal ports for Vacuuming System
		port def RotationSpeedPort {
			out item rotationSpeed; // :rpm
		}
		port def SuctionPressurePort {
			out item suctionPressue; // :bar
		}
		port def InternalAirPort {
			out item internalAir; // :m³ ?
		}
		port def DebrisPort {
			out item debris; // dimension?
		}
		// External ports for vacuuming system
		port def SuctionLevelPort {
			out item suctionLevel; // :% (from control -> needs to be moved there)
		}
		port def ExternalAirPort {
			in item externalAir; // :m³ ? 
		}
		port def RotationLevelPort{
			out item rotationLevel; // :% (from control -> needs to be moved there)
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
