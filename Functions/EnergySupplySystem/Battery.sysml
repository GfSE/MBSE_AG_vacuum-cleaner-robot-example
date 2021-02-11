package 'EnergySupply' {
  import EnergySupplyTypes::*;

	part def Battery {
	  port energyIn : EnergyInOutPort;
	  port energyOut : EnergyInOutPort;
	  // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // TOOD:
    // dekomposition in zellen
    
    // TODO:
    // batteriemanagement / überladeschutz
	}
}