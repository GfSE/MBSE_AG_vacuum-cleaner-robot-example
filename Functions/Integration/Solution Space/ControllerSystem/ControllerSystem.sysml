package ControllerSystem_Controller{
	private import RobotPortDefs::*;
	private import Signals::ControllerSignals::*;

	port def DriverUnitControlPort {
            out attribute forward;
            out attribute left;
            out attribute right;
    }
    
    interface def DriverUnitControlInterface{
    	end supplierPort : DriverUnitControlPort;
    	end consumerPort : ~DriverUnitControlPort;
    	
    	flow supplierPort.forward to consumerPort.forward;
    	flow supplierPort.left to consumerPort.left;
    	flow supplierPort.right to consumerPort.right;
    }
	
	part def Controller{
		action def IsCarpet;
		attribute def StartVacuumingSignal;
		attribute def StopVacuumingSignal;
		attribute def IdleVacuumingSignal;


		port driverSignalOutputPort : DriverUnitControlPort;
		port powerSignal : ~PowerSignal;

		// To Vacuuming System
		port suctionLevel : SuctionLevel;
		port brushRotationLevel : BrushRotationLevel;
		
		// From Vacuuming System
		port fillState : ~FillState;
	}
}
