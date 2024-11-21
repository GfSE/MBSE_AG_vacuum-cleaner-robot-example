package 'Energy Supply System' {

  private import ScalarValues::*;
  private import PortDef::*;

  part def Charger {
    
    attribute doCharge : Boolean;

    port statPlug : PowerInOutPort;
    port batPlug : PowerInOutPort;
  }

}