package 'Robotic Vacuum Cleaner'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import VacuumingSystem::*;
	import Ports::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : energySupplySystem;
		part VaccumingSystem : vacuumingSystem;  // Typo: should be VacuumingSystem

		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;

		interface : DriverUnitControlInterface connect
			supliertPort ::> ControllerSystem.driverSignalOutputPort to  // Typo: supliertPort should be supplierPort
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;
		
		// Interfaces to/from Vaccuming System  // Typo: should be Vacuuming System
		connect ControllerSystem to VacuumingSystem;
				
		// Control signal for level of suction intesity  // Typo: intensity

		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> ControllerSystem.suctionLevel;
			consumerPort ::> VacuumingSystem.suctionLevel;
			
		// Control signal for brush rotation level
		interface def brushRotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: brushRotationLevelPorts connect
			supplierPort ::> ControllerSystem.brushRotationLevel;
			consumerPort ::> VacuumingSystem.brushRotationLevel;
		
		// Current fill state of debris container
		interface def fillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> VacuumingSystem.fillState;
			consumerPort ::> ControllerSystem.fillState;
		
		// Dirty air flow
		interface def dirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirPorts connect
			supplierPort ::> dirtyAirFlow;
			consumerPort ::> VacuumingSystem.dirtyAirFlow;
			
		// Clean air flow
		interface def cleanAirPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirPorts connect
			supplierPort ::> VacuumingSystem.cleanAirFlow;
			consumerPort ::> cleanAirFlow;
		
	}
}
