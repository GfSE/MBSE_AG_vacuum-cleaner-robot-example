package 'Staubsaugerroboter'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	
	part ControllerSystem : controller;
	part NavigationSystem : navigation;
	part EnergySystem : energySupplySystem;
	
	connect NavigationSystem.driverSignal to ControllerSystem.driverSignal;
	connect EnergySystem.powerSignal to NavigationSystem.powerSignal;
}