package ess_charge {
    doc /* Ladegerät: nimmt Energie von der Ladestation auf und lädt damit die Batterie. */

    private import ScalarValues::*;
    private import PortDef::*;
    private import RobotPortDefs::*;

    part def Charger {
        doc /* Ladegerät: lädt die Batterie, solange der BatteryLevelComputer es anfordert. */

        attribute doCharge : Boolean;

        port chargeCommandInputPort : ~ChargeCommand;
        port stationEnergyInputPort : PowerInOutPort;   // von der Ladestation
        port batteryEnergyOutputPort : PowerInOutPort;  // zur Batterie
    }
}
