package DriveController{
/* This package implements the DriveContoller-System 
 * The DriveController drives the system*/

	private import Controller::*;
	private import Bumber::*;
	private import Engine::*;
	private import LaserTower::*;
	private import InfraredController::*;
	private import InfraredController::infraredController;


    part def stearingController{
		port PwmOutputPort : ~pwmPort;
    	port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
    }

    part def orienttationController{
    	port CollisionInputPort : ~collision;
    	port LaserTowerInputPort : ~laserTowerPosition;
    	port ContactChargerInputPort : ~contactCharger;
    }

    part def driveController {
    	port CollisionInputPort : ~collision;
    	port LaserTowerInputPort : ~laserTowerPosition;
    	port PwmOutputPort : ~pwmPort;
    	port ContactChargerInputPort : ~contactCharger;
    	port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		
        part StearingController : stearingController;
        part OrientationController : orienttationController;
        
        interface : bumberPassThroughInterface connect
	        supplierPort ::> CollisionInputPort to
	        consumerPort ::> OrientationController.CollisionInputPort;
        
        interface : pwmPassThroughInterface connect
        	supplierPort ::> PwmOutputPort to
        	consumeport ::> StearingController.PwmOutputPort;
        
        interface : infraredControllerPassThroughInterface connect
        	supplierPort ::> ContactChargerInputPort to
        	consumerPort ::> OrientationController.ContactChargerInputPort;
        
        interface : laserTowerPassThroughInterface connect
        	supplierPort ::> LaserTowerInputPort to
        	consumerPort ::> OrientationController.LaserTowerInputPort;

		interface : DriverUnitControlPassThroughInterface connect
			suppliertPort ::> driverUnitControlSignalInputPort to
			consumerPort ::> StearingController.PwmOutputPort;
	}
}