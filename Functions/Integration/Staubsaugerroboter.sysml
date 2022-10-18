package 'Staubsaugerroboter'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import Vacuum::*;
	
	part def staubsauger{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : energySupplySystem;
		part Vaccum : vacuum;		
	}
}