package SuctionDevice {

	private import RobotPortDefs::*;
	private import Ports::*;
	private import ISQ::*;
	private import ISQMechanics::*;
	private import ISQSpaceTime::*;
	private import ScalarValues::*;
/*
	calc def calcActualPower {
      	in powerLevel : Real;
		in maxPower : PowerValue;
		
		return PowerValue = powerLevel * maxPower;
  	}
        
    calc def calcVolFlow {
		in setpointPower :> ISQ::power;
		in diffPressure :> ISQ::pressure;

		return : ISQMechanics::volumeFlowRate = setpointPower / diffPressure;
	}
			
	calc def calcFlowRate {
		in inFlow :> ISQSpaceTime::volume;
		in volFlow :> ISQMechanics::volumeFlowRate;

		return : ISQSpaceTime::volume;
		// not sure how to model without time steps
		
	}*/

	part def SuctionMotor {
		port suctionLevel : ~SuctionLevel;
		port suctionPower : SuctionPower {
			//suctionPower = powerOut.res;
		}
			
		attribute parMaxPower :> ISQ::power;
		/*	
		calc powerOut : calcActualPower {
			in powerLevel = suctionLevel::suctionLevel;
			in maxPower = parMaxPower;
		    return res;
		
		}*/
			
	}
			
	part def SuctionChamber {
		port dirtyAirFlowIn : DirtyAirFlow;
		port dirtyAirFlowOut : ~DirtyAirFlow {
			//dirtyAirFlow = flowRate.currentFlowRate;
		}
		port suctionPower : ~SuctionPower;
				
		attribute parDiffPressure :> ISQ::pressure;
		/*		
		calc flowRate : calcFlowRate {
			in inFlow = dirtyAirFlowIn::dirtyAirFlow;
			in volFlow = calcVolFlow(suctionPower::suctionPower, parDiffPressure);
		    return currentFlowRate;
		}*/
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
			supplierPort ::> dirtyAirFlowIn to
			consumerPort ::> sc.dirtyAirFlowIn;
		
		interface def dirtyAirFlowOutPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowOutPorts connect
			supplierPort ::> sc.dirtyAirFlowOut to
			consumerPort ::> dirtyAirFlowOut;
			
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> suctionLevel to
			consumerPort ::> sm.suctionLevel;

		connect sm to sc;

		interface def suctionPowerPorts {
			end supplierPort : SuctionPower;
			end consumerPort : SuctionPower;
		}
		
		interface: suctionPowerPorts connect
			supplierPort ::> sm.suctionPower to
			consumerPort ::> sc.suctionPower;	
	}
}