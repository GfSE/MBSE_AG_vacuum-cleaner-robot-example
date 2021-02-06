package 'EnergySupply' {
	import EnergySupplyTypes::*;

	comment NoEclipse 
	/* Let's hope this works after Juypter crashed my Firefox and some 
   * troubles with Eclipse, e.g., autocpmplete repeatedly crashes Eclipse.
	 */

  alias BatteryLevelIndicator as Indicator;

  part def EnergySupplySystem specializes ElectricalComponent {
  	part c : Charger;
  	part b : Battery;
  	part i : Indicator;
  	
    port energyIn : EnergyInPort;
    port energyOut : EnergyOutPort;
  	port batteryLevel : BatteryLevelOutPort;
  	
  	// energy from the environment to charger
  	connect EnergyToEnergy : connect energyIn to c::energyIn;
  	
  	// energy from charger to battery
  	connect EnergyToEnergy : connect c::energyOut to b::energyIn;
  	
  	// energy from battery to battery level indicator
    connect EnergyToEnergy : connect b::energyOut to i::energyIn;
    
    // energy from battery to envirnonemnt
    connect EnergyToEnergy : connect b::energyOut to energyOut;
    
    // battery level from indicator to environment
    connect WhySoComplicated : connect i::batteryLevel to batteryLevel;
  	}
}