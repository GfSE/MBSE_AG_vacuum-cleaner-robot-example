package Navigation{
	import Ports::*;
	import Parts::*;
	
	part def navigation{
		part DriveController:driveController;
		part Motor[2] : dcMotor;
		part def laserTower : LaserTower;
		part def bumber: Bumber;
		part def infrarotController : InfrarotController;
		part def timeOfFlightSensor : TimeOfFlightSensor;
		part def timeofFlightController : TimeofFlightController;
		
		
		port driverSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;
	}
}
