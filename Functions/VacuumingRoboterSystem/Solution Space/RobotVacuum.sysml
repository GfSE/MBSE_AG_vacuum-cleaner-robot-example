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
			supplierPort ::> ControllerSystem.driverUnitControlOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		interface : VacuumingSystem::suctionLevelPorts connect
			supplierPort ::> ControllerSystem.suctionLevelOutputPort to
			consumerPort ::> VacuumingSystem.suctionLevel;

		// Control signal for brush rotation level
		interface def brushRotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: brushRotationLevelPorts connect
			supplierPort ::> ControllerSystem.brushRotationLevelOutputPort to
			consumerPort ::> VacuumingSystem.bs.brushRotationLevel;
		
		// Current fill state of debris container
		interface def fillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> VacuumingSystem.fillState to
			consumerPort ::> ControllerSystem.fillStateInputPort;
		
		// Dirty air flow
		interface def dirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirPorts connect
			supplierPort ::> dirtyAirFlow to
			consumerPort ::> VacuumingSystem.dirtyAirFlow;
			
		// Clean air flow
		interface def cleanAirPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirPorts connect
			supplierPort ::> VacuumingSystem.cleanAirFlow to
			consumerPort ::> cleanAirFlow;

	}
}