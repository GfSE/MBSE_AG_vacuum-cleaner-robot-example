package Ports {
	
	import ScalarValues::*;
	import ISQ::*;

	port def DriverUnitControlSignal {
            in forward :> Boolean;
            in left :> Boolean;
            in right :> Boolean;
    }
        
    
    port def PowerSignal{
    	out constantCurrent :> totalCurrent;
    	out constantVoltage :> voltage;
    }
    
}