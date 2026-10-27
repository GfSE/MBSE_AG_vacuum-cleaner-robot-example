package NavigationSystem_DriveController {
    doc /* Fahrsteuerung: wertet Sensorik aus und erzeugt die PWM-Signale für die Motoren. */

    private import ControllerSystem_Controller::*;
    private import NavigationSystem_Bumper::*;
    private import NavigationSystem_Engine::*;
    private import NavigationSystem_LaserTower::*;
    private import NavigationSystem_InfraredController::*;

    port def DriveCommandPort {
        doc /* Fahrbefehl der Orientierung an die Lenkung. */
        // Inhalt folgt mit dem Verhalten
    }

    part def SteeringController {
        doc /* Setzt Fahrbefehle in PWM-Signale für den linken und rechten Motor um. */
        port pwmLeftOutputPort : PwmPort;
        port pwmRightOutputPort : PwmPort;
        port driverUnitControlSignalInputPort : ~DriverUnitControlPort;
        port driveCommandInputPort : ~DriveCommandPort;
    }

    part def OrientationController {
        doc /* Bestimmt aus Kollision, Laser und Ladestation die Fahrtrichtung. */
        port collisionInputPort : ~CollisionPort;
        port laserTowerInputPort : ~LaserTowerPosition;
        port contactChargerInputPort : ~ContactCharger;
        port driveCommandOutputPort : DriveCommandPort;
    }

    part def DriveController {
        doc /* Fahrsteuerung des Roboters, bestehend aus Orientierung und Lenkung. */
        port collisionInputPort : ~CollisionPort;
        port laserTowerInputPort : ~LaserTowerPosition;
        port contactChargerInputPort : ~ContactCharger;
        port driverUnitControlSignalInputPort : ~DriverUnitControlPort;
        port pwmLeftOutputPort : PwmPort;
        port pwmRightOutputPort : PwmPort;

        part steeringController : SteeringController;
        part orientationController : OrientationController;

        // Delegation Außenports → Innenteile
        bind driverUnitControlSignalInputPort = steeringController.driverUnitControlSignalInputPort;
        bind pwmLeftOutputPort                = steeringController.pwmLeftOutputPort;
        bind pwmRightOutputPort               = steeringController.pwmRightOutputPort;
        bind collisionInputPort               = orientationController.collisionInputPort;
        bind laserTowerInputPort              = orientationController.laserTowerInputPort;
        bind contactChargerInputPort          = orientationController.contactChargerInputPort;

        // Interne Verbindung Orientierung → Lenkung
        connect orientationController.driveCommandOutputPort
             to steeringController.driveCommandInputPort;
    }
}