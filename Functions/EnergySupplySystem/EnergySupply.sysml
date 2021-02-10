package 'EnergySupply' {
	import EnergySupplyTypes::*;

	comment NoEclipse 
	/* Let's hope this works after Juypter crashed my Firefox and some 
   * troubles with Eclipse, e.g., autocpmplete repeatedly crashes Eclipse.
	 */

  alias BatteryLevelIndicator as Indicator;

  // woher wissen wir was die 'oberste' Systemkomponente ist?
  part def EnergySupplySystem {
  	part c : Charger;
  	part b : Battery;
  	part i : Indicator;
  	
    port energyIn : EnergyInPort;
    port energyOut : EnergyOutPort;
  	port batteryLevel : BatteryLevelOutPort;
  	
  	// energy from the environment to charger
  	connect EnergyToEnergy : energyIn to c::energyIn;
  	
  	// energy from charger to battery
  	connect EnergyToEnergy : c::energyOut to b::energyIn;
  	
  	// energy from battery to battery level indicator
    connect EnergyToEnergy : b::energyOut to i::energyIn;
    
    // energy from battery to envirnonemnt
    connect EnergyToEnergy : b::energyOut to energyOut;
    
    // battery level from indicator to environment
    connect WhySoComplicated : i::batteryLevel to batteryLevel;
  	}
}