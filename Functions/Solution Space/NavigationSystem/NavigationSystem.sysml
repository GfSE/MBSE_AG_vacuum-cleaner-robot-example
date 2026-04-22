package navigation_system_navigation {
    /* This module implements the Navigation-System
     * The Navigation-System is used for navigating the system */

    private import robot_port_defs::*;
    private import controller_system_controller::*;
    private import navigation_system_bumper::*;
    private import navigation_system_engine::*;
    private import navigation_system_laser_tower::*;
    private import navigation_system_drive_controller::*;
    private import navigation_system_infrared_controller::*;

    part def Navigation {
        action def DoNavigate;
        action def FindHome;

        part driveController : DriveController;
        part engine[2] : Engine;
        part laserTower : LaserTower;
        part bumber : Bumper;
        part infraredController : InfraredController;

        port driverUnitControlSignalInputPort : ~DriverUnitControlPort;
        port powerSignal : PowerSignal;

        interface : BumberInterface connect
            supplierPort ::> bumber.collisionOutputPort to
            consumerPort ::> driveController.collisionInputPort;

        interface : LaserTowerInterface connect
            supplierPort ::> laserTower.laserTowerPositionOutputPort to
            consumerPort ::> driveController.laserTowerInputPort;

        // Navigation mit DriverController
        interface : DriverUnitControlInterface connect
            supplierPort ::> driverUnitControlSignalInputPort to
            consumerPort ::> driveController.driverUnitControlSignalInputPort;

        interface : DriverUnitControlInterface connect
            supplierPort ::> driveController.driverUnitControlSignalInputPort to
            consumerPort ::> driveController.steeringController.driverUnitControlSignalInputPort;

        interface : InfraredControllerInterface connect
            supplierPort ::> infraredController.contactChargerOutputPort to
            consumerPort ::> driveController.contactChargerInputPort;

        interface : PwmControlInterface connect
            supplierPort ::> engine.pwmInputPort to
            consumerPort ::> driveController.pwmOutputPort;
    }
}
