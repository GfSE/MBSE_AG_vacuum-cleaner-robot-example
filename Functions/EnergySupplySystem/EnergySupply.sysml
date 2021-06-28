package 'EnergySupply' {
	import EnergySupplyTypes::*;

  alias BatteryLevelIndicator as Indicator;

  part def EnergySupplySystem {
  	part c : Charger;
  	part b : Battery;
  	part i : BatteryLevelIndicator;

  	port energy : PowerInOutPort;
  	port batteryLevel : BatteryLevelOutPort;
  	
  	// energy from the environment to charger
  	interface : PowerInterface connect energy to c::energy;
  	
  	// energy from charger to battery
  	interface : PowerInterface connect c::energy to b::energy;
  	
  	// energy from battery to battery level indicator
    interface : PowerInterface connect b::energy to i::energy;
    
    // energy from battery to environment
    interface : PowerInterface connect b::energy to energy;
    
    // battery level from indicator to environment
    interface : WhySoComplicated connect i::batteryLevel to batteryLevel;
  }

}