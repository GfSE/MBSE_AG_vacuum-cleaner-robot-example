package 'EnergySupply' {
  import EnergySupplyTypes::*;

  doc /*
    =======================================================================
    The following SysML v2 package specifies the battery 
    of the vacuum cleaner robot in a black-box fashion
    =======================================================================
    */  

	part def Battery {
	  // ports
	  port energy : PowerInOutPort;

	  // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // TOOD: Decompose in individual cells
    
    // TODO: Add battery management such as overcharging protection
	}
}
