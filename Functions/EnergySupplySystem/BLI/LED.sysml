package 'BLI' {
  import EnergySupplyTypes::*;

  part def LED {
	  // physical flows
    port energyIn          : EnergyInOutPort;
    
    // data flows
    port batteryLevelColor : BatteryLevelColorInPort; 
	}
	
	// TODO: Wie interagiert dieses Modell mit Code? 
	// opaque actions
}