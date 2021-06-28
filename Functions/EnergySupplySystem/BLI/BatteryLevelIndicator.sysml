package 'BLI' {
  import EnergySupplyTypes::*;

	part def BatteryLevelIndicator {
	  
	  // physical flows
    port energy : PowerInOutPort;
    
    // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    part blc : BatteryLevelComputer;
    part led : LED;
    
    connection : EnergyToEnergy   connect energy            to blc::energyIn;
    
    connection : EnergyToEnergy   connect energy            to led::energyIn;
    
    connection : WhySoComplicated connect blc::batteryLevel to batteryLevel;
    
    connection : WhySoComplicated connect blc::batteryLevel to led::batteryLevel;
	}
}