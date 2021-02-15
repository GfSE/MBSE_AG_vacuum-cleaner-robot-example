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
	package 'Structure' {
		part def SuctionMotor {
			port energyIn : Ports::EnergyInOutPort; //direction?
			port suctionPressureOut : Ports::SuctionPressurePort;
			port suctionLevelIn : ~Ports::SuctionLevelPort;
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
			port suctionLevelIn : ~Ports::SuctionPressurePort;
	
			connect sm::suctionPressureOut to sc::suctionPressureIn;
			connect energyIn to sm::energyIn;
			connect suctionLevelIn to sm::suctionLevelIn;
			connect airIn to sc::airIn;
			connect sc::airOut to airOut;
			
	
			// interface : SuctionPressure connect supplierPort => sm::suctionPressureOut to consumerPort => sc::suctionPressureIn;
			// interface : EnergyIn connect supplierPort => energyIn to consumerPort => sm:energyIn;
			// interface : SuctionLevel connect supplierPort => suctionLevelIn to sm::suctionLevelIn;
			// interface : ExternalAir connect supplierPort => airIn to sc::airIn;
			// interface : InternalAir connect supplierPort => sc::airOut to airOut;
		}
	}
}
	
	
