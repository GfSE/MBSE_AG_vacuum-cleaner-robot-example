package 'SuctionDevice' {
	// import EnergySupplyTypes::*;
	// import VacuumingTypes::*;
	
	package 'Ports' {
		//Ports (temporarily taken from VacuumTypes)
		port def SuctionPressurePort {
			out item suctionPressue; // :bar
		}
		port def SuctionLevelPort {
			out item suctionLevel; // :% (from control -> needs to be moved there)
		}
		port def ExternalAirPort {
			in item externalAir; // :m³ ? 
		}
		port def InternalAirPort {
			out item internalAir; // :m³ ?
		}
	
		// Other Ports (from EnergySupply)
		port def EnergyInOutPort {
			out item electricalEnergy;
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
	}
	package 'Calculations' {
		// Definition of calculations for SuctionDevice
		calc def calcPowerOut (powerLevel, maxPower) = powerLevel * maxPower;
		calc def calcPressureOut (inPower) = inPower * 10; // generic number
	}
	package 'Structure' {
		part def SuctionMotor {
			port energyIn : Ports::EnergyInOutPort; //direction?
			port suctionPressureOut : Ports::SuctionPressurePort;
			port suctionLevelIn : ~Ports::SuctionLevelPort;
			
			attribute maximumPower; // :maxType = 800;
			
			calc powerOut : calcPowerOut (
				powerLevel = suctionLevelIn::suctionLevel,
				maxPower = maximumPower
			) return pOut
			
			calc pressureOut : calcPressureOut (
				inPower = powerOut::pOut
			) return prOut = suctionPressureOut::suctionPressure;
		}
		
		part def SuctionChamber {
			port airIn : Ports::ExternalAirPort;
			port airOut : Ports::InternalAirPort;
			port suctionPressureIn : ~Ports::SuctionPressurePort;  
		}
		
		part def SuctionDevice
		{
			part sm : SuctionMotor;
			part sc : SuctionChamber;		
			
			port airIn : Ports::ExternalAirPort;
			port airOut : Ports::InternalAirPort;
			port energyIn : Ports::EnergyInOutPort;
			port suctionLevelIn : ~Ports::SuctionLevelPort;
	
			interface : Interfaces::AirIn connect supplierPort => airIn to consumerPort => sc::airIn;
	
			interface : Interfaces::SuctionPressure connect supplierPort => sm::suctionPressureOut to consumerPort => sc::suctionPressureIn;
	
			interface : Interfaces::EnergySupply connect supplierPort => energyIn to consumerPort => sm::energyIn;
	
			interface : Interfaces::SuctionLevel connect supplierPort => suctionLevelIn to consumerPort => sm::suctionLevelIn;
	
			interface : Interfaces::AirOut connect supplierPort => sc::airOut to consumerPort => airOut;			
			
		}
	}
}
	
	
