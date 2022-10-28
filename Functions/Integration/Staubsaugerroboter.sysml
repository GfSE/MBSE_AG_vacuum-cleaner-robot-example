package 'Staubsaugerroboter'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import Vacuum::*;
	import Ports::*;
	
	part def Staubsauger{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : energySupplySystem;
		part Vaccum : vacuum;
		
		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;

	}
}
