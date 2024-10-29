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
		part VacuumingSystem : vacuumingSystem;

		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;

		interface : DriverUnitControlInterface connect
			supliertPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;
		
		// Interfaces to/from Vaccuming System
		connect ControllerSystem to VacuumingSystem;
				
		// Control signal for level of suction intesity
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> ControllerSystem.suctionLevel to
			consumerPort ::> VacuumingSystem.suctionLevel;
			
		// Control signal for brush rotation level
		interface def brushRotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: brushRotationLevelPorts connect
			supplierPort ::> ControllerSystem.brushRotationLevel to
			consumerPort ::> VacuumingSystem.brushRotationLevel;
		
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
