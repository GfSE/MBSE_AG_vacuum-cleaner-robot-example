package Navigation{
/*This module implements the Navigation-System
 * The Navigation-System is used for navigating the system
 */
	import Ports::*;
	
	private import Controller::*;
	private import Bumber::*;
	private import Engine::*;
	private import LaserTower::*;
	private import DriveController::*;
	private import InfraredController::*;


	part def navigation{
		part DriveController : driveController;
		part Engine[2] : engine;
		part LaserTower : laserTower;
		part Bumber : bumber;
		part InfraredController : infraredController;

		port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		port powerSignal : PowerSignal;

		bind driverUnitControlSignalInputPort = DriveController.driverUnitControlSignalInputPort;

     	interface : bumberInterface connect
			suppliertPort ::> Bumber.CollisionOutputPort to
			consumerPort ::> DriveController.CollisionInputPort;	    	

	    interface : laserTowerInterface connect
	    	supplierPort ::> LaserTower.LaserTowerPositionOutputPort to
	    	consumerPort ::> DriveController.LaserTowerInputPort;

    	interface : infraredControllerInterface connect
    		supplierPort ::> InfraredController.ContactChargerOutputPort to
	    	consumerPort ::> DriveController.ContactChargerInputPort;    	

	    interface : pwmControllInterface connect
			suppliertPort ::> Engine.PwmInputPort to
			consumerPort ::> DriveController.PwmOutputPort;

	}
}