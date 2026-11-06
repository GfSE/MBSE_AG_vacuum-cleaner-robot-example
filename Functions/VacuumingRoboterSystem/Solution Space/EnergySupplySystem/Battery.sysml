package ess_bat {
    doc /* Batterie des Roboters (Black-Box-Sicht) sowie erste Entwürfe für ihren inneren Aufbau. */

    private import ScalarValues::*;
    private import PortDef::*;
    private import Signals::BatterySignals::BatterySignal;
    private import ISQ::*;

    part def Battery {
        doc /* Batterie: speichert die Energie vom Ladegerät und gibt sie an den Spannungsregler ab. */

        // aktuelle Ladung
        attribute capacity : EnergyValue;
        attribute totCapacity : EnergyValue;

        port energyInputPort : PowerInOutPort;    // vom Ladegerät
        port energyOutputPort : PowerInOutPort;   // an den Spannungsregler
    }

    // Entwurf: innerer Aufbau der Batterie, wird von Battery noch nicht verwendet
    part def Accumulator {
        doc /* Akkupack aus Zellen. Entwurf, noch nicht in Battery verwendet. */
        item def Energy;
        attribute mass : Real;
        attribute totCapacity;

        part def Cell {
            capacity  : Real;
            voltage   : Real;
        }

        part def CellConnector;

        attribute def Layout {
            numOfParCells : Integer;
            numOfSerCells : Integer;
        }
    }

    // Entwurf: Batteriemanagement, wird von Battery noch nicht verwendet
    part def BMS {
        doc /* Battery Management System. Entwurf, noch nicht in Battery verwendet. */
        part def VolSensor;
        part def CurSensor;
        part def TempSensor;
        part def MicroController;
        part def Balancer;

        port batSig : BatterySignal;
    }
}
