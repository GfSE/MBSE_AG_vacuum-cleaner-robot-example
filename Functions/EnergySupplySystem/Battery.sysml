package 'EnergySupply' {
  import EnergySupplyTypes::*;

	part def Battery {
	  // ports
	  port energy : PowerInOutPort;

	  // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // TOOD:
    // dekomposition in zellen
    
    // TODO:
    // batteriemanagement / überladeschutz
	}
}