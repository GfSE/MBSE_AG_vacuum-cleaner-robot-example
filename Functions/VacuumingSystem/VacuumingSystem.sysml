package VacuumingSystem {
	import BrushSystem::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import VacuumingTypes::*;
	
	
	part def VacuumingSystem {
		//port energyIn : VacuumingTypes::PortDefinitions::PowerInOutVac;
		port airIn : VacuumingTypes::PortDefinitions::ExternalAirPort;
		port airOut : VacuumingTypes::PortDefinitions::InternalAirPort;
		port suctionLevel : ~VacuumingTypes::PortDefinitions::SuctionLevelPort;
		port rotationLevel : ~VacuumingTypes::PortDefinitions::RotationLevelPort;
		port debrisOut : DebrisPort;
		port fillState : FillStatePort; 
		
		
	}
	
	part vacSys : VacuumingSystem{
		part bs : BrushSystem {
			port redefines rotationLevelIn; 
			//port redefines energyIn;
		}
		part sd : SuctionDevice {
			port redefines airIn;
			port redefines airOut;
			//port redefines energyIn;
			port redefines suctionLevelIn;
		}
		part fs : FilterSystem {
			port redefines airIn;
			port redefines airOut;
			port redefines debrisOut;
			port redefines fillState;
		}
		
		interface : VacuumingTypes::InterfaceDefinitions::ExternalAir connect supplierPort => airIn to consumerPort => sd::airIn;
		//interface : Signals::BatterySignals::VacuumSystemPowerInterface connect supplierPort => energyIn to consumerPort => sd::energyIn;
		//interface : Signals::BatterySignals::VacuumSystemPowerInterface connect supplierPort => energyIn to consumerPort => bs::energyIn;
		interface : VacuumingTypes::InterfaceDefinitions::SuctionLevel connect supplierPort => suctionLevel to consumerPort => sd::suctionLevelIn;
		interface : VacuumingTypes::InterfaceDefinitions::RotationLevel connect supplierPort => rotationLevel to consumerPort => bs::rotationLevelIn;
		 
		// Needs to be aligned with filter system
		interface : VacuumingTypes::InterfaceDefinitions::InternalAir connect supplierPort => sd::airOut to consumerPort => fs::airIn;
		interface : VacuumingTypes::InterfaceDefinitions::Debris connect supplierPort => fs::debrisOut to consumerPort => debrisOut;
		interface : VacuumingTypes::InterfaceDefinitions::ExternalAir connect supplierPort => fs::airOut to consumerPort => airOut; 
		interface : VacuumingTypes::InterfaceDefinitions::FillStateLevel connect src => fs::fillState to tgt => fillState;
	}
}