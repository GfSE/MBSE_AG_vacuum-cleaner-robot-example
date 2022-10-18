package Navigation{
	import Ports::*;
	import Parts::*;
	
	part def navigation{
		part DriveController : driveController;
		part Motor[2] : dcMotor;
		part laserTower : Lasertower;
		part bumber : Bumber;
		part infrarotController : InfrarotController;
	}
}
