package 'Robotic Vacuum Cleaner'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import Vacuum::*;
	import Ports::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : energySupplySystem;
		part Vaccum : vacuum;

		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;

		connect ControllerSystem to NavigationSystem;

		interface def ports{
			end supliertPort : DriverUnitControlSignal;
			end consumertPort: DriverUnitControlSignal;
		}
		interface: ports connect
			supliertPort ::> driverUnitControlSignal to
			consumerPort ::> NavigationSystem.driverUnitControlSignal;
	}
}
