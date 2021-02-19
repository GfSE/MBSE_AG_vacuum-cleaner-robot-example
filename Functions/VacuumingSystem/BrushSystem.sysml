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
	package 'Interfaces' {
		interface def EnergySupply {
			end supplierPort : Ports::EnergyInOutPort;
            end consumerPort : Ports::EnergyInOutPort;
		}
		interface def RotationSpeed {
			end supplierPort : Ports::RotationSpeedPort;
            end consumerPort : Ports::RotationSpeedPort;
		}
		interface def RotationLevel {
			end supplierPort : Ports::RotationLevelPort;
            end consumerPort : Ports::RotationLevelPort;
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
	
			interface : Interfaces::EnergySupply connect supplierPort => energyIn to consumerPort => bm::energyIn;

			interface : Interfaces::RotationSpeed connect supplierPort => bm::rotationSpeedOut to consumerPort => mb::rotationSpeedIn;
			interface : Interfaces::RotationSpeed connect supplierPort => bm::rotationSpeedOut to consumerPort => rb::rotationSpeedIn;
	
			interface : Interfaces::RotationLevel connect supplierPort => rotationLevelIn to consumerPort => bm::rotationLevelIn;
		}
	}
}
