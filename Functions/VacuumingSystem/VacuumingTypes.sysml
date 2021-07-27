package VacuumingTypes {
	// Standard libraries
	import SI::*;	// Für m³ etc.
	import ISQSpaceTime::*; // angularVelocity
	import ISQMechanics::*; // pressure
	import ScalarValues::*; //Real
	//import PortDef::*; deprecated, use Signals instead
	import Signals::*;
	
	// External ports of vacuuming system subsystems
	package PortDefinitions {
		
		// Wie kann man sicherstellen, dass das zweite Attribute nicht vererbt wird, bzw. weggelassen wird
		port def SuctionLevelPort :> BatterySignals::VacuumSystemPowerOutPort {
				out attribute redefines suctionPower :> ISQMechanics::power;
            }
        port def RotationLevelPort :> BatterySignals::VacuumSystemPowerOutPort {
        		out attribute redefines brushPower :> ISQMechanics::power; 	
        	}
		//port def PowerInOutVac :> Signals::BatterySignals::PowerInOutPort;
		
		
		// Suction Device
		//port def SuctionLevelPort {
		// {
		//	out item suctionLevel {
		//		attribute suctionLevel : Real; // :% (from control -> needs to be moved there)
		//	}
		//}
		
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
		//port def RotationLevelPort :> NumericSignal {
		//	out item rotationLevel {
		//		attribute rotationLevel : Real; // :% (from control -> needs to be moved there)
		//	} 
		//}
			
		// Filter System
		port def DebrisPort {
			inout item debris{
				attribute vol:> SI::'m³';
				attribute mass :> SI::kg;
			}
		}
		
		port def FillStatePort :> NumericSignal;
				
	}
	
	// Interfaces between vacuuming system subsystems
	package InterfaceDefinitions {
		
		interface def ExternalAir {
			end supplierPort : PortDefinitions::ExternalAirPort;
            end consumerPort : PortDefinitions::ExternalAirPort;
		}
		

		interface def SuctionLevel :> Signals::BatterySignals::VacuumSystemPowerInterface;
		interface def RotationLevel :> Signals::BatterySignals::VacuumSystemPowerInterface;
		interface def FillStateLevel :> Signals::NumericSignalInterface;
		
		
		/* interface def SuctionLevel {
			end supplierPort : PortDefinitions::SuctionLevelPort;
            end consumerPort : PortDefinitions::SuctionLevelPort;
		}*/
		 
		/*interface def RotationLevel {
			end supplierPort : PortDefinitions::RotationLevelPort;
            end consumerPort : PortDefinitions::RotationLevelPort;
		}*/
		
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
