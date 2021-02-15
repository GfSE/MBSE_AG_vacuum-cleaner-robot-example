package 'BLI' {
  import EnergySupplyTypes::*;

	part def BatteryLevelIndicator {
	  
	  // physical flows
    port energyIn : EnergyInOutPort;
    
    // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    part blc : BatteryLevelComputer;
    part led : LED;
    
    connection : EnergyToEnergy   connect energyIn          to blc::energyIn;
    
    connection : EnergyToEnergy   connect energyIn          to led::energyIn;
    
    connection : WhySoComplicated connect blc::batteryLevel to batteryLevel;
    
    connection : WhySoComplicated connect blc::batteryLevel to led::batteryLevel;
    
    // E -> LED.E 
	}
}