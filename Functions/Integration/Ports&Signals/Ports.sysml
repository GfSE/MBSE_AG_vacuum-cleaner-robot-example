package Ports {
	
	import ScalarValues::*;
	import ISQ::*;
	import SI::*;
	import ISQSpaceTime::*;
	import ISQMechanics::*;

	port def DriverUnitControlSignal {
            in forward :> Boolean;
            in left :> Boolean;
            in right :> Boolean;
    }
         
    port def PowerSignal{
    	out constantCurrent :> totalCurrent;
    	out constantVoltage :> voltage;
    }
	
// Ports for Vacuuming System
	
	port def DirtyAirFlow{
		in dirtyAirFlow :> ISQSpaceTime::volume;
	}
	
	port def CleanAirFlow{
		out cleanAirFlow :> ISQSpaceTime::volume;
	}
	
	port def Debris {
		out debrisVolume :> SI::'m³';
		out debrisMass :> SI::kg;
	}
	
    port def FillState {
		out fillState :> Real;
	}
	
	port SuctionLevel {
		out suctionLevel :> Real;
	}
	
	port SuctionPower {
		out suctionPower :> ISQ::power;
	}
	
	port BrushRotationLevel {
		out brushRotationLevel :> Real;
	}
	
	port def BrushRotationSpeed {
		out brushRotationSpeed :> ISQSpaceTime::rotationalFrequency;
	}
	
}