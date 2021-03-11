package SuctionDevice {
	import ScalarValues::*;
    import ISQ::*;
    import ISQMechanics::*;
    import SI::*;
    
    import Definitions::*;

	// Local import not possible
	// import EnergySupplyTypes::*;
	// import VacuumingTypes::*;
	
	package Definitions {
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import PartDefinitions::*;
		import CalculationDefinitions::*;
	
		package PortDefinitions {
			//Ports (temporarily taken from VacuumTypes)
			port def SuctionPowerPort {
				out item suctionPower {
					attribute suctionPower :> ISQ::power;
				}
			}
			
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
			
			// Other Ports (from EnergySupply)
			port def EnergyInOutPort {
				out item electricalEnergy;
			}
		}
	
		package InterfaceDefinitions {
		// Interface Definitions for Vacuuming System
			interface def AirIn {
				end supplierPort : ExternalAirPort;
            	end consumerPort : ExternalAirPort;
			}
			
			interface def SuctionPressure {
				end supplierPort : SuctionPowerPort;
            	end consumerPort : SuctionPowerPort;
			}
		
			interface def EnergySupply {
				end supplierPort : EnergyInOutPort;
            	end consumerPort : EnergyInOutPort;
			}
			
			interface def SuctionLevel {
				end supplierPort : SuctionLevelPort;
            	end consumerPort : SuctionLevelPort;
			}
			
			interface def AirOut {
				end supplierPort : InternalAirPort;
            	end consumerPort : InternalAirPort;
			}
		}
		
		package CalculationDefinitions {
		// Definition of calculations for SuctionDevice
			calc def calcActualPower (powerLevel : Real, maxPower :> ISQ::power) :> ISQ::power {
            	powerLevel * maxPower 
        	}
        
        // Definition of calculations for SuctionChamber
		calc def calcVolFlow (actPower :> ISQ::power, diffPressure :> ISQ::pressure) :> ISQMechanics::volumeFlowRate {
				actPower / diffPressure
			}
		}
	
		package  PartDefinitions {
			part def SuctionMotor {
				port energyIn : EnergyInOutPort; //direction?
				port suctionPowerOut : SuctionPowerPort;
				port suctionLevelIn : ~SuctionLevelPort;
			
				attribute par_maximumPower:>ISQ::power;
			
				calc powerOut : calcActualPower (
					powerLevel = suctionLevelIn::suctionLevel::suctionLevel,
					maxPower = par_maximumPower
				) return pOut = suctionPowerOut::suctionPower::suctionPower;
			
			}
		
			part def SuctionChamber {
				port airIn : ExternalAirPort;
				port airOut : InternalAirPort;
				port suctionPowerIn : ~SuctionPowerPort;
				
				attribute par_diffPressure:>ISQ::pressure;
				
				calc volFlow : calcVolFlow (
					actPower = suctionPowerIn::suctionPower::suctionPower,
					diffPressure = par_diffPressure
				) return vOut;
			}
		
			part def SuctionDevice {	
			
				port airIn : ExternalAirPort;
				port airOut : InternalAirPort;
				port energyIn : EnergyInOutPort;
				port suctionLevelIn : ~SuctionLevelPort;
			}
		}
	}

	package PartsTree {
		part suctionDevice : SuctionDevice { 
			part suctionMotor : SuctionMotor {
				// redefines der Ports sind erforderlich, um den common Kontext herzustellen --> ist allerdings nicht zwingend erforderlich
				port redefines suctionPowerOut; 
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
			
			interface : AirIn connect supplierPort => airIn to consumerPort => suctionChamber::airIn;
			interface : SuctionPressure connect supplierPort => suctionMotor::suctionPowerOut to consumerPort => suctionChamber::suctionPowerIn;
			interface : EnergySupply connect supplierPort => energyIn to consumerPort => suctionMotor::energyIn;
			interface : SuctionLevel connect supplierPort => suctionLevelIn to consumerPort => suctionMotor::suctionLevelIn;
			interface : AirOut connect supplierPort => suctionChamber::airOut to consumerPort => airOut;	
		}
	}
}