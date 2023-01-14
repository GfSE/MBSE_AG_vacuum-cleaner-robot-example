package Parts{
	
	part def driveController {
        part stearingController;
        part orientationController;
    }
    
    part def dcMotor {
        attribute maxTorque :> ISQ::torque;
        attribute rpm0 : Real;
        attribute voltage :> ISQ::voltage;
        
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
        attribute distance : LengthValue;
        attribute distanceAngle : Real;
        attribute motor;
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
