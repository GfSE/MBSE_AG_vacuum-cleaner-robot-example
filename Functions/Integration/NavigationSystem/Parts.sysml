package Parts{
	
	part def driveController {
        part stearingController;
        part orientationController;
    }
    
    part def dcMotor {
        attribute maxTorque :> ISQ::torque; // maximales Drehmoment
        attribute rpm0 : Real; // Nenndrehzahl
        attribute voltage :> ISQ::voltage; // Voltage;
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

	part def TimeOfFlightSensor{
        port i2cSlave : i2c;
    }
    
    part def InfrarotController{
        part timeOfFlightSensor;
        port psu : powerSupplyPort;
        port i2cMaster : i2c;
        
    }  
}
