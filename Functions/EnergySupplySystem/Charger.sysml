package 'EnergySupply' {
  import EnergySupplyTypes::*;

  part def Charger {
    // physical flows
    port energyIn : EnergyInPort;
    port energyOut : EnergyOutPort;
    // data flows
    port batteryLevel : RelativeBatteryLevelInPort;
  }
}