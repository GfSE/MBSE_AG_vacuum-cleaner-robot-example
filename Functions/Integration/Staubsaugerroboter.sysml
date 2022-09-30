package 'Staubsaugerroboter'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import Vacuum::*;
	
	part ControllerSystem : controller;
	part NavigationSystem : navigation;
	part EnergySystem : energySupplySystem;
	part Vaccum : vacuum;
	
	connect NavigationSystem.driverSignal to ControllerSystem.driverSignal;
	connect EnergySystem.powerSignal to NavigationSystem.powerSignal;
}