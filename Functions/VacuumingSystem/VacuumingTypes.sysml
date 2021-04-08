package VacuumingTypes {
	// Standard libraries
	import SI::*;	// Für m³ etc.
	import ISQSpaceTime::*; // angularVelocity
	import ISQMechanics::*; // pressure
	import ScalarValues::*; //Real
	
	// External ports of vacuuming system subsystems
	package PortDefinitions {
		
		// Suction Device
		port def SuctionLevelPort {
			out item suctionLevel {
				attribute suctionLevel : Real; // :% (from control -> needs to be moved there)
			}
		}
		
		port def ExternalAirPort {
			in item externalAir{
				attribute volume :> ISQSpaceTime::volume;
			} 
		}
		
		port def InternalAirPort {
			out item internalAir{
				attribute volume :> ISQSpaceTime::volume;
			} 
		}
		
		// Brush System	
		port def RotationLevelPort {
			out item rotationLevel {
				attribute rotationLevel : Real; // :% (from control -> needs to be moved there)
			} 
		}
			
		// Filter System
		port def DebrisPort {
			inout item debris{
				attribute vol:> SI::'m³';
				attribute mass :> SI::kg;
			}
		}
		
		// Temporarily added (from Energy Supply) and adapted
		// Switch to original library is now possible -> to be removed here !!
		port def EnergyInOutPort {
			out item electricalEnergy {
				attribute voltage :> SI::V;
				attribute current :> SI::A;
				attribute power :> SI::W;
			} 
		}
	}
	
	// Interfaces between vacuuming system subsystems
	package InterfaceDefinitions {
		
		interface def ExternalAir {
			end supplierPort : PortDefinitions::ExternalAirPort;
            end consumerPort : PortDefinitions::ExternalAirPort;
		}
		
		interface def EnergySupply {
			end supplierPort : EnergySupplyTypes::EnergyInOutPort;
            end consumerPort : EnergySupplyTypes::EnergyInOutPort;
		}
		
		interface def SuctionLevel {
			end supplierPort : PortDefinitions::SuctionLevelPort;
            end consumerPort : PortDefinitions::SuctionLevelPort;
		}
		 
		interface def RotationLevel {
			end supplierPort : PortDefinitions::RotationLevelPort;
            end consumerPort : PortDefinitions::RotationLevelPort;
		}
		
		interface def Debris {
			end supplierPort : PortDefinitions::DebrisPort;
			end consumerPort : PortDefinitions::DebrisPort;
		}
		
		interface def InternalAir {
			end supplierPort : PortDefinitions::InternalAirPort;
			end consumerPort : PortDefinitions::InternalAirPort;
		}
	}
}
