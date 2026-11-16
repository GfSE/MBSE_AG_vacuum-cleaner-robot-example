package 'Robotic Vacuum Cleaner' {
	doc /* Top Level des Saugroboters: die vier Subsysteme und ihre Verbindungen. */

	private import ControllerSystem_Controller::*;
	private import NavigationSystem_Navigation::*;
	private import energy_supply::*;
	private import vacuuming_system::*;
	private import RobotPortDefs::*;

	part def RoboticVacuumCleaner {
		doc /* Saugroboter aus Controller, Navigation, Energieversorgung und Saugsystem.
		     * Der Controller entscheidet, wohin gefahren wird (Fahrauftrag an die Navigation),
		     * und wann zurückgefahren wird (Füllstand, Ladezustand, Fahrstatus). */

		part ControllerSystem : Controller;
		part NavigationSystem : Navigation;
		part EnergySystem : EnergySupplySystem;
		part vacuumingSystem : VacuumingSystem;

		// Außenports: Luftstrom
		port dirtyAirFlowInputPort : ~DirtyAirFlow;
		port cleanAirFlowOutputPort : CleanAirFlow;

		// Delegation Außenports → Saugsystem
		bind dirtyAirFlowInputPort  = vacuumingSystem.dirtyAirFlowInputPort;
		bind cleanAirFlowOutputPort = vacuumingSystem.cleanAirFlowOutputPort;

		// 1a) Wohin geht's: Controller → Navigation
		interface : DriveTaskInterface connect
			supplierPort ::> ControllerSystem.driveTaskOutputPort to
			consumerPort ::> NavigationSystem.driveTaskInputPort;

		interface : DriverUnitControlInterface connect
			supplierPort ::> ControllerSystem.driverUnitControlOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		// 1b) Wann müssen wir zurück: Subsysteme → Controller
		interface : FillStateInterface connect
			supplierPort ::> vacuumingSystem.fillStateOutputPort to
			consumerPort ::> ControllerSystem.fillStateInputPort;

		interface : BatteryLevelInterface connect
			supplierPort ::> EnergySystem.batteryLevelOutputPort to
			consumerPort ::> ControllerSystem.batteryLevelInputPort;

		interface : NavigationStatusInterface connect
			supplierPort ::> NavigationSystem.navigationStatusOutputPort to
			consumerPort ::> ControllerSystem.navigationStatusInputPort;

		// Saugleistung: Controller → Saugsystem
		interface : SuctionLevelInterface connect
			supplierPort ::> ControllerSystem.suctionLevelOutputPort to
			consumerPort ::> vacuumingSystem.suctionLevelInputPort;

		interface : BrushRotationLevelInterface connect
			supplierPort ::> ControllerSystem.brushRotationLevelOutputPort to
			consumerPort ::> vacuumingSystem.brushRotationLevelInputPort;
	}
}
