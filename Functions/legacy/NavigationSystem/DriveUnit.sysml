package DriveUnit{
	// global imports
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    import ISQElectromagnetism::*;
	import partDef::*;
	import PortDef::*;	
    
	    
	part def logicalDriveUnit {

	    part motor1 : dcMotor {
	        part tire1 redefines motorTire[1];
	    }
	    part motor2 : dcMotor {
	        part tire2 redefines motorTire[1];
	    }
	    part drvController : driveController{ 
	        attribute redefines architecture = EeArchitecture::arm; //man muss bei "redefine" keinen neuen Namen vergeben.
	    }
	    part orientation : Lasertower;
	    part collision : Bumber;
	    part psuDetection : timeofFlightController;
	    
	    port powerSupply : DriveUnitPowerSupply;
	    port controlSignal : DriverUnitControlSignal;

	}
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::motor1::psu;
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::motor2::psu;
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::orientation::psu;

	//satisfy Beschleunigen by driveUnit; // Funktioniert noch nicht
	}

    