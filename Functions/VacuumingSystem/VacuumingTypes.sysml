package 'VacuumingTypes' {

	// import ScalarValues::*;
	
	package 'Ports' {

		port def RotationSpeedPort {
			out item rotationSpeed; // :rpm
		}
		port def SuctionPressurePort {
			out item suctionPressue; // :bar
		}
		port def SuctionLevelPort {
			out item suctionLevel; // :% (from control -> needs to be moved there)
		}
		port def ExternalAirPort {
			in item externalAir; // :m³ ? 
		}
		port def InternalAirPort {
			out item internalAir; // :m³ ?
		}
		port def RotationLevelPort{
			out item rotationLevel; // :%
		}
	}
}
