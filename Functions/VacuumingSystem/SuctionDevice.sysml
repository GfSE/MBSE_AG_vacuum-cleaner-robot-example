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
			port suctionLevelIn : ~Ports::SuctionLevelPort;
	
			interface def AirIn {
				end supplierPort : Ports::ExternalAirPort;
            	end consumerPort : Ports::ExternalAirPort;
			}
	
			interface : AirIn connect supplierPort => airIn to consumerPort => sc::airIn;
			
			interface def SuctionPressure {
				end supplierPort : Ports::SuctionPressurePort;
            	end consumerPort : Ports::SuctionPressurePort;
			}
	
			interface : SuctionPressure connect supplierPort => sm::suctionPressureOut to consumerPort => sc::suctionPressureIn;
			
			interface def EnergySupply {
				end supplierPort : Ports::EnergyInOutPort;
            	end consumerPort : Ports::EnergyInOutPort;
			}
	
			interface : EnergySupply connect supplierPort => energyIn to consumerPort => sm::energyIn;
			
			interface def SuctionLevel {
				end supplierPort : Ports::SuctionLevelPort;
            	end consumerPort : Ports::SuctionLevelPort;
			}
	
			interface : SuctionLevel connect supplierPort => suctionLevelIn to consumerPort => sm::suctionLevelIn;
						
			interface def AirOut {
				end supplierPort : Ports::InternalAirPort;
            	end consumerPort : Ports::InternalAirPort;
			}
	
			interface : AirOut connect supplierPort => sc::airOut to consumerPort => airOut;			
			
		}
	}
}
	
	
