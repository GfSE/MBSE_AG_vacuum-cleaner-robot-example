package Controller{
	import Ports::*;
	
	part def controller{
		port driverSignal : ~DriverUnitControlSignal;
		port powerSignal : ~PowerSignal;
	}
}
