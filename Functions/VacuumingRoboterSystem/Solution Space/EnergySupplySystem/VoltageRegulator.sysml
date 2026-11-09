package ess_reg {
    doc /* Spannungsregler: wandelt die Batteriespannung in die Versorgungsspannung des Roboters. */

    private import PortDef::*;
    private import RobotPortDefs::*;

    part def VoltageRegulator {
        doc /* Spannungsregler: regelt die Ausgangsspannung auf den Sollwert des BatteryLevelComputers. */

        port targetVoltageInputPort : ~EnergyRegulation;
        port batteryEnergyInputPort : PowerInOutPort;   // von der Batterie
        port energyOutputPort : PowerInOutPort;         // an die anderen Subsysteme
    }
}
