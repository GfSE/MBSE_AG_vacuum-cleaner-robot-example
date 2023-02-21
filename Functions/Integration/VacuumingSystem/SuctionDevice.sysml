package SuctionDevice {

	import Ports::*;
	import ISQ::*;
	import ISQMechanics::*;
	import ISQSpaceTime::*;
	import ScalarValues::*;

	calc def calcActualPower (powerLevel :> Real, maxPower :> ISQ::power) :> ISQ::power {
            	powerLevel * maxPower 
        	}
        
    calc def calcVolFlow (setpointPower :> ISQ::power, diffPressure :> ISQ::pressure) :> ISQMechanics::volumeFlowRate {
				actPower / diffPressure
			}
			
	calc def calcFlowRate (inFlow :> ISQSpaceTime::volume, volFlow :> ISQMechanics::volumeFlowRate) :> ISQSpaceTime::volume {
				// not sure how to model without time steps
			}
		}

	part def SuctionMotor {
		port suctionLevel = ~SuctionLevel;
		port suctionPower = SuctionPower;
			
		attribute parMaxPower :> ISQ::power;
			
		calc powerOut : calcActualPower (
			powerLevel = suctionLevel::suctionLevel,
			maxPower = parMaxPower
		) return pOut = suctionPower::suctionPower;
			
	}
			
	part def SuctionChamber {
		port dirtyAirFlowIn = DirtyAirFlow;
		port dirtyAirFlowOut = ~DirtyAirFlow;
		port suctionPower : ~SuctionPower;
				
		attribute parDiffPressure :> ISQ::pressure;
				
		calc volFlow : calcVolFlow (
			actPower = suctionPower::suctionPower,
			diffPressure = parDiffPressure
		) return currentFlow
		
		calc flowRate : calcFlowRate (
			inFlow = dirtyAirFlowIn::dirtyAirFlow;
			volFlow = currentFlow
		) return currentFlowRate = dirtyAirFlowOut::dirtyAirFlow;
	}
		
	part def suctionDevice { 
		part sm : SuctionMotor;
		part sc : SuctionChamber {
			attribute redefines parDiffPressure = 25000; // 25kPa is a common pressure difference for suction devices
		}
		
		port dirtyAirFlowIn : DirtyAirFlow;
		port dirtyAirFlowOut : ~DirtyAirFlow;
		port suctionLevel : ~SuctionLevel;

		interface def dirtyAirFlowInPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowInPorts connect
			supplierPort ::> dirtyAirFlowIn;
			consumerPort ::> sc.dirtyAirFlowIn;
		
		interface def dirtyAirFlowOutPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowOutPorts connect
			supplierPort ::> sc.dirtyAirFlowOut;
			consumerPort ::> dirtyAirFlowOut;
			
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> suctionLevel;
			consumerPort ::> sm.suctionlevel;

		connect sm to sc;

		interface def suctionPowerPorts {
			end supplierPort : SuctionPower;
			end consumerPort : SuctionPower;
		}
		
		interface: suctionPowerPorts connect
			supplierPort ::> sm.suctionPower;
			consumerPort ::> sc.suctionPower;	
	}
}