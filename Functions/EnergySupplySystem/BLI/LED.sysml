package 'BLI' {
  import EnergySupplyTypes::*;

  part def LED {
	  // physical flows
    port energy            : PowerInOutPort;
    
    // data flows
    port batteryLevelColor : BatteryLevelColorInPort; 
	}
	
	// TODO: Wie interagiert dieses Modell mit Code? 
	// opaque actions
}