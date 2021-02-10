package 'EnergySupply' {
  import EnergySupplyTypes::*;

	part def Battery {
	  port energyIn : EnergyInPort;
	  port energyOut : EnergyOutPort;
	  // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // dekomposition in zellen
    
    // batteriemanagement / überladeschutz
	}
}