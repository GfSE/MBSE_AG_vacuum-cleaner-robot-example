package Controller{
	import Ports::*;
	
	part def controller{
		port driverSignal : ~DriverUnitControlSignal;
		port powerSignal : ~PowerSignal;
		
		// To Vacuuming System
		port suctionLevel : SuctionLevel;
		port brushRotationLevel : BrushRotationLevel;
		
		// From Vacuuming System
		port fillState : ~FillState;
	}
}
