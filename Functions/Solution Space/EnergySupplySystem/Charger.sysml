package ess_charge {

  private import ScalarValues::*;
  private import PortDef::*;
  private import robot_port_defs::*;

  part def Charger {

    attribute doCharge : Boolean;

    port chargeCmd : ~ChargeCommand;

    port statPlug : PowerInOutPort;
    port batPlug : PowerInOutPort;
  }

}