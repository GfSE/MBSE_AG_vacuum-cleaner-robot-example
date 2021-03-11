package BrushSystem {
	import ScalarValues::*;
    import ISQ::*;
    import ISQMechanics::*;
    import SI::*;
    import ISQSpaceTime::*;
    
    import Definitions::*;

	// Local import not possible
	// import EnergySupplyTypes::*;
	// import VacuumingTypes::*;
	
	package Definitions {
		
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import InterfaceDefinitions::*;
		import PartDefinitions::*;
		import CalculationDefinitions::*;
		
		package PortDefinitions {
		//Ports (temporarily taken from VacuumTypes)
			
			port def RotationSpeedPort {
				out item rotationSpeed{
					attribute rotationSpeed :> ISQSpaceTime::rotationalFrequency; // :rpm
				}
			}
			
			port def RotationLevelPort {
				out item rotationLevel {
					attribute rotationLevel : Real;
				} 
			}
	
			// Other Ports (from EnergySupply)
			port def EnergyInOutPort {
				out item electricalEnergy;
			}
		}
		
		package InterfaceDefinitions {
		
			interface def EnergySupply {
				end supplierPort : EnergyInOutPort;
            	end consumerPort : EnergyInOutPort;
			}
		
			interface def RotationSpeed {
				end supplierPort : RotationSpeedPort;
            	end consumerPort : RotationSpeedPort;
			}
			
			interface def RotationLevel {
				end supplierPort : RotationLevelPort;
            	end consumerPort : RotationLevelPort;
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
				port energyIn : EnergyInOutPort;
				port rotationLevelIn : ~RotationLevelPort;
				port rotationSpeedOut : RotationSpeedPort;
				
				attribute par_maximumRPM :> ISQSpaceTime::rotationalFrequency;
				
				calc actualRPM : calcActualRPM (
					rotationLevel = rotationLevelIn::rotationLevel::rotationLevel,
					maxPower = par_maximumRPM
				) return pOut = rotationSpeedOut::rotationSpeed::rotationSpeed;
			}
			
			part def MainBrush {
				port rotationSpeedIn : ~RotationSpeedPort;
			}
			
			part def RotatingBrush{
				port rotationSpeedIn : ~RotationSpeedPort;
			}
		
			part def BrushSystem
			{
				port rotationLevelIn : ~RotationLevelPort;
				port energyIn : EnergyInOutPort;
				
				
			}	
		}
	}
	
	package PartsTree {
		part brushSystem : BrushSystem {
			part mainBrush : MainBrush{
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

			interface : EnergySupply connect supplierPort => energyIn to consumerPort => brushMotor::energyIn;
			interface : RotationSpeed connect supplierPort => brushMotor::rotationSpeedOut to consumerPort => mainBrush::rotationSpeedIn;
			interface : RotationSpeed connect supplierPort => brushMotor::rotationSpeedOut to consumerPort => rotatingBrush::rotationSpeedIn;
			interface : RotationLevel connect supplierPort => rotationLevelIn to consumerPort => brushMotor::rotationLevelIn;
		}
	}
}
