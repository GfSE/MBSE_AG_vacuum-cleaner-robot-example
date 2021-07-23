package BrushSystem {
	// Standard libraries
	import ScalarValues::*;
    import ISQ::*;
    import ISQMechanics::*;
    import SI::*;
    import ISQSpaceTime::*;
    
    // Local libraries
    import EnergySupplyTypes::*;
	import VacuumingTypes::*;
    
    // Local imports
    import Definitions::*;
    
    // Model packages
	package Definitions {
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import InterfaceDefinitions::*;
		import PartDefinitions::*;
		import CalculationDefinitions::*;
		
		// Definition of internal ports
		package PortDefinitions {
			
			port def RotationSpeedPort {
				out item rotationSpeed {
					attribute rotationSpeed :> ISQSpaceTime::rotationalFrequency; // :rpm
				}
			}
		}
		
		package InterfaceDefinitions {
		
		doc /* 
		 * from PortDef
		 */
			//interface def EnergySupply {
			//	end supplierPort : EnergySupplyTypes::EnergyInOutPort;
            //	end consumerPort : EnergySupplyTypes::EnergyInOutPort;
			//}
		
			interface def RotationSpeed {
				end supplierPort : RotationSpeedPort;
            	end consumerPort : RotationSpeedPort;
			}
			
			interface def RotationLevel {
				end supplierPort : VacuumingTypes::PortDefinitions::RotationLevelPort;
            	end consumerPort : VacuumingTypes::PortDefinitions::RotationLevelPort;
			}
		}
		
		package CalculationDefinitions {
		// Definition of calculations for BrushMotor
			calc def calcActualRPM (rotationLevel : Real, maxRPM :> ISQSpaceTime::rotationalFrequency) :> ISQSpaceTime::rotationalFrequency {
            	rotationLevel * maxRPM 
        	}
        }
		
		package PartDefinitions {
			
			part def BrushMotor {	
				port energyIn : VacuumingTypes::PortDefinitions::PowerInOutVac;
				port rotationLevelIn : ~VacuumingTypes::PortDefinitions::RotationLevelPort;
				port rotationSpeedOut : RotationSpeedPort;
				
				attribute par_maximumRPM :> ISQSpaceTime::rotationalFrequency;
				
				calc actualRPM : calcActualRPM (
					rotationLevel = rotationLevelIn::val,
					maxRPM = par_maximumRPM
				) return pOut = rotationSpeedOut::rotationSpeed::rotationSpeed;
			}
			
			part def MainBrush {
				port rotationSpeedIn : ~RotationSpeedPort;
			}
			
			part def RotatingBrush {
				port rotationSpeedIn : ~RotationSpeedPort;
			}
		
			part def BrushSystem {
				port rotationLevelIn : ~VacuumingTypes::PortDefinitions::RotationLevelPort;
				port energyIn : VacuumingTypes::PortDefinitions::PowerInOutVac;
			}	
		}
	}
	
	package PartsTree {
		part brushSystem : BrushSystem {
			part mainBrush : MainBrush {
				port redefines rotationSpeedIn;
			} 
			
			part rotatingBrush : RotatingBrush[2] {
				port redefines rotationSpeedIn;
			}
	
			part brushMotor : BrushMotor {
				port redefines energyIn;
				port redefines rotationLevelIn;
				port redefines rotationSpeedOut;
				
				attribute redefines par_maximumRPM = 167; // 10000 rpm is a common rotational speed of the brushes, recalculation because rotationalFrequency is [1/s]
			}
			
			port redefines rotationLevelIn;
			port redefines energyIn; 

			interface : Signals::BatterySignals::PowerInterface connect supplierPort => energyIn to consumerPort => brushMotor::energyIn;
			interface : RotationSpeed connect supplierPort => brushMotor::rotationSpeedOut to consumerPort => mainBrush::rotationSpeedIn;
			interface : RotationSpeed connect supplierPort => brushMotor::rotationSpeedOut to consumerPort => rotatingBrush::rotationSpeedIn;
			interface : RotationLevel connect supplierPort => rotationLevelIn to consumerPort => brushMotor::rotationLevelIn;
		}
	}
}
