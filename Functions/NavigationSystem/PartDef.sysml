package partDef
{
    import portDef::*;

    part def tire {
        attribute diameter : LengthValue; //LengthValue kommt aus dem ISQ-Paket und beinhaltet ein Real und eine Einheit
    }
    
    enum def EeArchitecture {
        enum arm;
        enum arm64;
        enum i386;
        enum amd64;
    }

    part def driveController {
        attribute architecture : EeArchitecture;
        
        part stearingController;
        part orientationController;
    }
    
    part def dcMotor {
        attribute maxTorque :> ISQ::torque; // maximales Drehmoment
        attribute rpm0 : Real; // Nenndrehzahl
        attribute voltage :> ISQ::voltage; // Voltage;
        
        action def ConvertEletricalToMechanicalEnergy (in current, in voltage, in rpm0, out mechanicalEnergy) {
            calc Torque;
        }
        
        action def ProvideTorque (in current, in voltage, in rpm0, out torque:>ISQ::torque) {
            
            bind convertEnergy::current = current;
            bind convertEnergy::voltage = voltage;
            bind convertEnergy::rpm0 = rpm0;
            
            action convertEnergy:ConvertEletricalToMechanicalEnergy (in current, in voltage, in rpm0, out mechanicalEnergy);
            
            bind convertEnergy::mechanicalEnergy = torque;
            
        }
            
        port psu :powerSupplyPort;
        port Torque : torque;
        
        part motorTire : tire [1..2];
        
        state def motorDirection {
            entry; then idle;
            
            state idle;
           
            transition idle_to_left
                first idle
                then left;
            
            transition idle_to_right
                first idle
                then right;
            
            state left;               
            
            transition left_to_idle
                first left
                then idle;
            
            state right;
            
            transition right_to_idle
                first right
                then idle;               
        }
    }

    part def Lasertower {
        attribute distance : LengthValue; // abstand in meter
        attribute distanceAngle : Real; // winkel der zum abstand gemessen wurden
        attribute motor; // für das rotieren
        port position : LaserTowerPosition;
        port psu : powerSupplyPort;
    }

    part def Bumber {
        attribute isContact : Boolean;

        port Contact : contact;
    }

    part def infrarotController{
            // berechnet Abbstand
        //sendet signal
    }
    part def timeOfFlightSensor{
        port i2cSlave : i2c;
    }
    
    part def timeofFlightController{
        part timeOfFlightSensor;
        port psu : powerSupplyPort;
        port i2cMaster : i2c;
        
    }  
}