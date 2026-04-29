package NavigationSystem_DriveController {
    /* This package implements the DriveController-System 
     * The DriveController drives the system */

    private import Controller::*;
    private import NavigationSystem_Bumper::*;
    private import NavigationSystem_Engine::*;
    private import NavigationSystem_LaserTower::*;
    private import NavigationSystem_InfraredController::*;

    part def SteeringController {
        port pwmOutputPort : ~PwmPort;
        port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
    }

    part def OrientationController {
        port collisionInputPort : ~CollisionPort;
        port laserTowerInputPort : ~LaserTowerPosition;
        port contactChargerInputPort : ~ContactCharger;
    }

    part def DriveController {
        port collisionInputPort : ~CollisionPort;
        port laserTowerInputPort : ~LaserTowerPosition;
        port pwmOutputPort : ~PwmPort;
        port contactChargerInputPort : ~ContactCharger;
        port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;

        part steeringController : SteeringController;
        part orientationController : OrientationController;

        interface : DriverUnitControlInterface connect
            supplierPort ::> driverUnitControlSignalInputPort to
            consumerPort ::> steeringController.driverUnitControlSignalInputPort;
    }
}
