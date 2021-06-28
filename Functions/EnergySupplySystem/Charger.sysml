package 'EnergySupply' {
  import EnergySupplyTypes::*;

  part def Charger {
    // physical flows
    port energy : PowerInOutPort;

    // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // TODO:
    // aus staubsauger ausbauen?
  }
}