package 'BrushSystem' {
	// import EnergySupplyTypes::*;
	// import VacuumingTypes::*;
	
	package 'Ports'	{
		//Ports (temporarily taken from VacuumTypes)
		port def RotationSpeedPort {
			out item rotationSpeed; // :rpm
		}
		port def RotationLevelPort{
			out item rotationLevel; // :%
		}
	
		// Other Ports (from EnergySupply)
		port def EnergyInOutPort {
			out item electricalEnergy;
		}
	}
	package 'Structure' {
		part def BrushMotor{
			port energyIn : Ports::EnergyInOutPort;
			port rotationLevelIn : ~Ports::RotationLevelPort;
			port rotationSpeedOut : Ports::RotationSpeedPort;
		}
		part def MainBrush{
			port rotationSpeedIn : ~Ports::RotationSpeedPort;
		}
		part def RotatingBrush{
			port rotationSpeedIn : ~Ports::RotationSpeedPort;
		}
		part def BrushSystem
		{
			part mb : MainBrush;
			part rb : RotatingBrush[2];		
			part bm : BrushMotor;
			
			port rotationLevelIn : ~Ports::RotationLevelPort;
			port energyIn : Ports::EnergyInOutPort;
	
			connect rotationLevelIn to bm::rotationLevelIn;
			connect energyIn to bm::energyIn;
			connect bm::rotationSpeedOut to mb::rotationSpeedIn;
			connect bm::rotationSpeedOut to rb::rotationSpeedIn;
			
		}
	}
}
