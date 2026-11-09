package 'Robotic Vacuum Cleaner'{
	
	private import ControllerSystem_Controller::*;
	private import NavigationSystem_Navigation::*;
	private import EnergySupply::*;
	private import vacuuming_system::*;
	private import RobotPortDefs::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : Controller;
		part NavigationSystem : Navigation;
		part EnergySystem : EnergySupplySystem;
		part vacuumingSystem : VacuumingSystem;

		action def doClean;

		interface : DriverUnitControlInterface connect
			supplierPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		// Saugstufe Controller → Saugsystem
		interface : SuctionLevelInterface connect
			supplierPort ::> ControllerSystem.suctionLevel to
			consumerPort ::> vacuumingSystem.suctionLevelInputPort;

		// Bürstenstufe Controller → Saugsystem
		interface : BrushRotationLevelInterface connect
			supplierPort ::> ControllerSystem.brushRotationLevel to
			consumerPort ::> vacuumingSystem.brushRotationLevelInputPort;

		// Füllstand Saugsystem → Controller
		interface : FillStateInterface connect
			supplierPort ::> vacuumingSystem.fillStateOutputPort to
			consumerPort ::> ControllerSystem.fillState;

		// Luftstrom: Umgebung → Roboter → Umgebung
		port dirtyAirFlowInputPort : ~DirtyAirFlow;
		port cleanAirFlowOutputPort : CleanAirFlow;

		bind dirtyAirFlowInputPort  = vacuumingSystem.dirtyAirFlowInputPort;
		bind cleanAirFlowOutputPort = vacuumingSystem.cleanAirFlowOutputPort;

	}
}