package 'BLI' {
	import EnergySupplyTypes::*;

	part def BatteryLevelComputer {
	   // physical flows
    port energyIn : EnergyInPort;
    // data flows
    port batteryLevel : RelativeBatteryLevelOutPort;
    
    // hier sollte nun ca. folgendes geschehen: 
    // batteryLevel = energyIn / battery.capacity 
	}
}