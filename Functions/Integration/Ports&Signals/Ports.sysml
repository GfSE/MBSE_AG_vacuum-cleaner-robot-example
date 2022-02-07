package Ports {
	
	import ScalarValues::*;
	import ISQ::*;

	port def DriverUnitControlSignal {
            in forward : Boolean;
            in left : Boolean;
            in right : Boolean;
    }
        
    	interface def DriverUnitControlSignalInterface{
    	end DriverSignalSrc : DriverUnitControlSignal;
    	end DriverSignalTgt : ~DriverUnitControlSignal;
    }
    
    port def PowerSignal{
    	out constantCurrent :> totalCurrent;
    	out constantVoltage :> voltage;
    }
    
    interface def PowerSignalInterface{
    	end PowerSignalSrc : ~PowerSignal;
    	end PowerSignalTgt : PowerSignal;
    }

}