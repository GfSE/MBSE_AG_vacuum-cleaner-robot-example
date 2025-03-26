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


		state def VacuumCleanerBehavior{
		doc /* This is the Statemachine Diagram */
		entry; then Idle;

		/* It seems that we need to declare actions here and  */		

		attribute startVacuumingSignal : RoboticVacuumCleaner::ControllerSystem::StartVacuumingSignal;
		attribute stopVacuumingSignal : RoboticVacuumCleaner::ControllerSystem::StopVacuumingSignal;
		attribute idleVacuumingSignal : RoboticVacuumCleaner::ControllerSystem::IdleVacuumingSignal;
		attribute lowBatterySignal : RoboticVacuumCleaner::EnergySystem::LowBatterySignal;
		attribute charingSignal : RoboticVacuumCleaner::EnergySystem::CharingSignal;
		attribute continueVacuumingSingal : RoboticVacuumCleaner::EnergySystem::ContinueVacuumingSingal;
		
		/* It seems that we need to composite actions
		We might need to consider race-conditions*/
		action VaccumingDoActions {
			action doNavigate : RoboticVacuumCleaner::NavigationSystem::DoNavigate;
			action isCarpet : RoboticVacuumCleaner::ControllerSystem::IsCarpet;
			// Energy: DoEnergy()
			// Vacuum: DoVacuum()
		}
		
		action ChargingDoActions{
			// Energy: DoCharge()
			action findHome : RoboticVacuumCleaner::NavigationSystem::FindHome;
			// Vacuum: EmptyVacuum()
		}

		// States
		state Idle{
		}

		state Vaccuming {
			do VaccumingDoActions;
		}

		state Finish{
		}

		state LowBattery{
		}

		state Charging {
			do ChargingDoActions;
		}
		
		//Transition

		transition IdleToVaccuming
			first Idle
			accept startVacuumingSignal
			then Vaccuming;

		transition VaccumingToFinish
			first Vaccuming
			accept stopVacuumingSignal
			then Finish;

		transition FinishToIdle
			first Finish
			accept idleVacuumingSignal
			then Idle;
		
		transition ChargingToVacuuming
			first Charging
			accept continueVacuumingSingal
			then Vaccuming;

		transition VaccumingToLowBattery
			first Vaccuming
			accept lowBatterySignal
			then LowBattery;

		transition LowBatteryToCharing
			first LowBattery
			accept charingSignal
			then Charging;

		}
		


	}
}
