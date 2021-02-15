package 'EnergySupply' {
	import EnergySupplyTypes::*;

  alias BatteryLevelIndicator as Indicator;

  part def EnergySupplySystem {
  	part c : Charger;
  	part b : Battery;
  	part i : BatteryLevelIndicator;
  	
    port energyIn     : EnergyInOutPort;
    port energyOut    : EnergyInOutPort;
  	port batteryLevel : BatteryLevelOutPort;
  	
  	// energy from the environment to charger
  	connection EnergyToEnergy : connect energyIn to c::energyIn;
  	
  	// energy from charger to battery
  	connection EnergyToEnergy : connect c::energyOut to b::energyIn;
  	
  	// energy from battery to battery level indicator
    connection EnergyToEnergy : connect b::energyOut to i::energyIn;
    
    // energy from battery to environment
    connection EnergyToEnergy : connect b::energyOut to energyOut;
    
    // battery level from indicator to environment
    connection WhySoComplicated : connect i::batteryLevel to batteryLevel;
  	}
}