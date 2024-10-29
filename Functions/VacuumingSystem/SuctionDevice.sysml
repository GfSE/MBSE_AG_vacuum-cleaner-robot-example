package SuctionDevice {
	// Standard libraries
	import ScalarValues::*;
    import ISQ::*;
    import ISQMechanics::*;
    import SI::*;
    
    // Local libraries
    import EnergySupplyTypes::*;
	import VacuumingTypes::*;
    
    // Local imports
    import Definitions::*;

	// Model packages
	package Definitions {
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import CalculationDefinitions::*;
	
		// Definition of internal ports
		package PortDefinitions {	

			port def SuctionPowerPort {
				out suctionPower :> ISQ::power;
			}
		}
			
		// Definition of internal interfaces
		package InterfaceDefinitions {
			interface def AirIn {
				end supplierPort : ~VacuumingTypes::PortDefinitions::AirPort;
            	end consumerPort : VacuumingTypes::PortDefinitions::AirPort;
			}
			
			interface def SuctionPressure {
				end supplierPort : SuctionPowerPort;
            	end consumerPort : SuctionPowerPort;
			}
		
			interface def EnergySupply {
				end supplierPort : EnergySupplyTypes::EnergyInOutPort;
            	end consumerPort : EnergySupplyTypes::EnergyInOutPort;
			}
			
			interface def SuctionLevel {
				end supplierPort : VacuumingTypes::PortDefinitions::SuctionLevelPort;
            	end consumerPort : VacuumingTypes::PortDefinitions::SuctionLevelPort;
			}
			
			interface def AirOut {
				end supplierPort : ~VacuumingTypes::PortDefinitions::AirPort;
            	end consumerPort : VacuumingTypes::PortDefinitions::AirPort;
			}
		}
		
		package CalculationDefinitions {
		// Definition of calculations for SuctionDevice
			calc def calcActualPower {
				in powerLevel : VacuumingTypes::PortDefinitions::SuctionLevelPort::suctionPower;
				in maxPower :> ISQ::power;
                return pOut :> ISQ::power = powerLevel * maxPower ;
        	}
        
        // Definition of calculations for SuctionChamber
			calc def calcVolFlow {
				in actPower :> ISQ::power;
				in diffPressure :> ISQ::pressure;
				return :> ISQMechanics::volumeFlowRate = actPower / diffPressure;
			}
			
			calc def inOutFlow {
				in inFlow :> ISQSpaceTime::volume;
				in volFlow :> ISQMechanics::volumeFlowRate;
				return :> ISQSpaceTime::volume;
				// not sure how to model, without time steps	
			}
		}
	
		package  PartDefinitions {
			part def SuctionMotor {
				//port energyIn : VacuumingTypes::PortDefinitions::PowerInOutVac;
				port suctionPowerOut : SuctionPowerPort {
					suctionPower = powerOut::pOut;
				}
				port suctionLevelIn : ~VacuumingTypes::PortDefinitions::SuctionLevelPort;
			
				attribute par_maximumPower:>ISQ::power;
			
				calc powerOut : calcActualPower {
					in powerLevel = suctionLevelIn::suctionPower;
					in maxPower = par_maximumPower;
				}
			
			}
		
			part def SuctionChamber {
				port airIn : ~VacuumingTypes::PortDefinitions::AirPort;
				port airOut : VacuumingTypes::PortDefinitions::AirPort;
				port suctionPowerIn : ~SuctionPowerPort;
				
				attribute par_diffPressure:>ISQ::pressure;
				
				calc volFlow : calcVolFlow {
					in actPower = suctionPowerIn::suctionPower;
					in diffPressure = par_diffPressure;
				    return vOut;
				}
			}
		
			part def SuctionDevice {	
			
				port airIn : ~VacuumingTypes::PortDefinitions::AirPort;
				port airOut : VacuumingTypes::PortDefinitions::AirPort;
				port energyIn : VacuumingTypes::PortDefinitions::PowerInOutVac;
				port suctionLevelIn : ~VacuumingTypes::PortDefinitions::SuctionLevelPort;
			}
		}
	}

	package PartsTree {
		import SuctionDevice::Definitions::PartDefinitions::*;
		part suctionDevice : SuctionDevice { 
			part suctionMotor : SuctionMotor {
				// redefines der Ports sind erforderlich, um den common Kontext herzustellen --> ist allerdings nicht zwingend erforderlich
				port redefines suctionPowerOut ; 
				port redefines energyIn;
				port redefines suctionLevelIn;
				
				// Maximum suction pressure 1000W
				attribute redefines par_maximumPower = 1000;
			}
			
			part suctionChamber : SuctionChamber {
				port redefines suctionPowerIn;
				port redefines airIn;
				port redefines airOut;
				
				attribute redefines par_diffPressure = 25000; // 25kPa is a common pressure difference for suction devices
			}
			
			port redefines airIn;
			port redefines airOut;
			port redefines energyIn;
			port redefines suctionLevelIn;
			
			interface : AirIn connect supplierPort ::> airIn to consumerPort ::> suctionChamber::airIn;
			interface : SuctionPressure connect supplierPort ::> suctionMotor::suctionPowerOut to consumerPort ::> suctionChamber::suctionPowerIn;
			interface : PortDef::PowerInterface connect supplierPort ::> energyIn to consumerPort ::> suctionMotor::energyIn;
			interface : VacuumingTypes::InterfaceDefinitions::SuctionLevel connect supplierPort ::> suctionLevelIn to consumerPort ::> suctionMotor::suctionLevelIn;
			interface : AirOut connect supplierPort ::> suctionChamber::airOut to consumerPort ::> airOut;	
		}
	}
}