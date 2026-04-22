package navigation_system_drive_controller {
    /* This package implements the DriveController-System 
     * The DriveController drives the system */

    private import Controller::*;
    private import navigation_system_bumper::*;
    private import navigation_system_engine::*;
    private import navigation_system_laser_tower::*;
    private import navigation_system_laser_tower::*;

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
