package RobotPortDefs {

    private import ScalarValues::*;
    private import ISQ::*;

    // Ports for Navigation System
    
    port def PowerSignal {
        out constantCurrent :> totalCurrent;
        out constantVoltage :> voltage;
    }

    // Ports for Vacuuming System

    port def DirtyAirFlow {
        out dirtyAirFlow :> ISQSpaceTime::volume;
    }

    port def CleanAirFlow {
        out cleanAirFlow :> ISQSpaceTime::volume;
    }

    port def Debris {
        out debrisVolume :> SI::'m³';
        out debrisMass :> SI::kg;
    }

    port def FillState {
        out fillState : Real;
    }

    port def SuctionLevel {
        out suctionLevel : Real;
    }

    port def SuctionPower {
        out suctionPower :> ISQ::power;
    }

    port def BrushRotationLevel {
        out brushRotationLevel : Real;
    }

    port def BrushRotationSpeed {
        out brushRotationSpeed :> ISQSpaceTime::rotationalFrequency;
    }


}