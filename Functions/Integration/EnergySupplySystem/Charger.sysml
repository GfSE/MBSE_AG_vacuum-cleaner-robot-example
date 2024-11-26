package ESS_Charge {

  private import ScalarValues::*;
  private import PortDef::*;
  private import RobotPortDefs::*;

  part def Charger {

    attribute doCharge : Boolean;

    port chargeCmd : ~ChargeCommand;

    port statPlug : PowerInOutPort;
    port batPlug : PowerInOutPort;
  }

}