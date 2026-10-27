package NavigationSystem_Navigation {
    doc /* Navigationssystem des Roboters: erfasst die Umgebung und steuert die Antriebe. */

    private import RobotPortDefs::*;
    private import ControllerSystem_Controller::*;
    private import NavigationSystem_Bumper::*;
    private import NavigationSystem_Engine::*;
    private import NavigationSystem_LaserTower::*;
    private import NavigationSystem_DriveController::*;
    private import NavigationSystem_InfraredController::*;

    part def Navigation {
        doc /* Navigation aus Sensorik (Bumper, Laser, Infrarot), Fahrsteuerung und zwei Motoren. */

        part driveController : DriveController;
        part engineLeft : Engine;
        part engineRight : Engine;
        part laserTower : LaserTower;
        part bumper : Bumper;
        part infraredController : InfraredController;

        // Außenports
        port driverUnitControlSignalInputPort : ~DriverUnitControlPort;
        port powerInputPort : ~PowerSignal;

        // Delegation Außenports → Innenteile
        bind driverUnitControlSignalInputPort = driveController.driverUnitControlSignalInputPort;
        bind powerInputPort = engineLeft.powerInputPort;
        bind powerInputPort = engineRight.powerInputPort;

        // Sensorik → Fahrsteuerung
        interface : BumperInterface connect
            supplierPort ::> bumper.collisionOutputPort to
            consumerPort ::> driveController.collisionInputPort;

        interface : LaserTowerInterface connect
            supplierPort ::> laserTower.laserTowerPositionOutputPort to
            consumerPort ::> driveController.laserTowerInputPort;

        interface : InfraredControllerInterface connect
            supplierPort ::> infraredController.contactChargerOutputPort to
            consumerPort ::> driveController.contactChargerInputPort;

        // Fahrsteuerung → Motoren
        interface : PwmControlInterface connect
            supplierPort ::> driveController.pwmLeftOutputPort to
            consumerPort ::> engineLeft.pwmInputPort;

        interface : PwmControlInterface connect
            supplierPort ::> driveController.pwmRightOutputPort to
            consumerPort ::> engineRight.pwmInputPort;
    }
}