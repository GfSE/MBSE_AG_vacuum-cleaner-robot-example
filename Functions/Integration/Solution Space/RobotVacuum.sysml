package 'Robotic Vacuum Cleaner'{
	
	private import Controller::*;
	private import Navigation::*;
	private import EnergySupply::*;
	private import VacuumingSystem::*;
	private import RobotPortDefs::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : EnergySupplySystem;
		part VacuumingSystem : vacuumingSystem;

		action def doClean;

		interface : DriverUnitControlInterface connect
			supplierPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		interface : VacuumingSystem::suctionLevelPorts connect
			supplierPort ::> ControllerSystem.suctionLevel to
			consumerPort ::> VacuumingSystem.suctionLevel;

		// Control signal for brush rotation level
		interface def brushRotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: brushRotationLevelPorts connect
			supplierPort ::> ControllerSystem.brushRotationLevel to
			consumerPort ::> VacuumingSystem.bs.brushRotationLevel;
		
		// Current fill state of debris container
		interface def fillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> VacuumingSystem.fillState to
			consumerPort ::> ControllerSystem.fillState;
		
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
