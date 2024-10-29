package Controller{
	import RobotPortDefs::*;
	import Signals::ControllerSignals::*;
	
	port def DriverUnitControlSignal {
            out attribute forward : Boolean;
            out attribute left : Boolean;
            out attribute right : Boolean;
    }
    
    interface def DriverUnitControlInterface{
    	end supplierPort : DriverUnitControlSignal;
    	end consumerPort : ~DriverUnitControlSignal;
    	
    	flow supplierPort.forward to consumerPort.forward;
    	flow supplierPort.left to consumerPort.left;
    	flow supplierPort.right to consumerPort.right;
    }
	
	part def controller{
		port driverSignalOutputPort : DriverUnitControlSignal;
		port powerSignal : ~PowerSignal;
		
		// To Vacuuming System
		port suctionLevel : SuctionLevel;
		port brushRotationLevel : BrushRotationLevel;
		
		// From Vacuuming System
		port fillState : ~FillState;
	}
}
