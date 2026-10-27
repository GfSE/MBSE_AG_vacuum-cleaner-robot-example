package NavigationSystem_Navigation {
    /* This module implements the Navigation-System
     * The Navigation-System is used for navigating the system */

    private import RobotPortDefs::*;
    private import ControllerSystem_Controller::*;
    private import NavigationSystem_Bumper::*;
    private import NavigationSystem_Engine::*;
    private import NavigationSystem_LaserTower::*;
    private import NavigationSystem_DriveController::*;
    private import NavigationSystem_InfraredController::*;

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

        interface : BumperInterface connect
            supplierPort ::> bumber.collisionOutputPort to
            consumerPort ::> driveController.collisionInputPort;

        interface : LaserTowerInterface connect
            supplierPort ::> laserTower.laserTowerPositionOutputPort to
            consumerPort ::> driveController.laserTowerInputPort;

        // Navigation mit DriverController
        interface : DriverUnitControlInterface connect
            supplierPort ::> driverUnitControlSignalInputPort to
            consumerPort ::> driveController.driverUnitControlSignalInputPort;

        interface : InfraredControllerInterface connect
            supplierPort ::> infraredController.contactChargerOutputPort to
            consumerPort ::> driveController.contactChargerInputPort;

        interface : PwmControlInterface connect
            supplierPort ::> driveController.pwmOutputPort to
            consumerPort ::> engine.pwmInputPort;
    }
}
