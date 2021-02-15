package 'EnergySupply' {
  import EnergySupplyTypes::*;

  part def Charger {
    // physical flows
    port energyIn  : EnergyInOutPort;
    port energyOut : EnergyInOutPort;
    
    // data flows
    port batteryLevel : RelativeBatteryLevelPort;
    
    // TODO:
    // aus staubsauger ausbauen?
  }
}