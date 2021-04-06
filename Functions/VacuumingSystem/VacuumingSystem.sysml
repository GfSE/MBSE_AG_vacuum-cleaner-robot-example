package VacuumingSystem {
	// mit dem neusten Pilot (frisch von Git, commit 81df3ba, 15.03.2021) und Eclipse 2021-03 Modeling, werfen die Imports keine Fehler mehr!
	import BrushSystem::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import VacuumingTypes::*;
	
	
	part def VacuumingSystem {
		part bs : BrushSystem {
			port redefines rotationLevelIn;
			port redefines energyIn;
		}
		part sd : SuctionDevice {
			port redefines airIn;
			port redefines airOut;
			port redefines energyIn;
			port redefines suctionLevelIn;
		}
		part fs : FilterSystem {
			// Port redefintion missing
		}
		
		port airIn : VacuumingTypes::PortDefinitions::ExternalAirPort;
		port airOut : VacuumingTypes::PortDefinitions::ExternalAirPort;
		port suctionLevel : VacuumingTypes::PortDefinitions::SuctionLevelPort;
		port rotationLevel : VacuumingTypes::PortDefinitions::RotationLevelPort;
		port debrisOut : VacuumingTypes::PortDefinitions::DebrisPort;
		port energyIn : EnergySupplyTypes::EnergyInOutPort;
		
		interface : VacuumingTypes::InterfaceDefinitions::ExternalAir connect supplierPort => airIn to consumerPort => sd::airIn;
		interface : VacuumingTypes::InterfaceDefinitions::EnergySupply connect supplierPort => energyIn to consumerPort => sd::energyIn;
		interface : VacuumingTypes::InterfaceDefinitions::EnergySupply connect supplierPort => energyIn to consumerPort => bs::energyIn;
		interface : VacuumingTypes::InterfaceDefinitions::SuctionLevel connect supplierPort => suctionLevel to consumerPort => sd::suctionLevelIn;
		interface : VacuumingTypes::InterfaceDefinitions::RotationLevel connect supplierPort => rotationLevel to consumerPort => bs::rotationLevelIn;
		 
		// Needs to be aligned with filter system
		// interface : VacuumingTypes::InterfaceDefinitions::InternalAir connect supplierPort => sd::airOut to consumerPort => fs::airIn;
		// interface : VacuumingTypes::InterfaceDefinitions::Debris connect supplierPort => fs::debris to consumerPort => debrisOut;
		// interface : VacuumingTypes::InterfaceDefinitions::ExternalAir connect supplierPort => fs::airOut to consumerPort => airOut; 
		
	}
}