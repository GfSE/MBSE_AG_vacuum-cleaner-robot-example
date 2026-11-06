package RobotPortDefs {
    doc /* Port-Definitionen, die über Subsystemgrenzen hinweg genutzt werden.
         * Port-Defs, die nur innerhalb eines Subsystems vorkommen, gehören in das Subsystem. */

    private import ScalarValues::*;
    private import ISQ::*;

    // Versorgung

    port def PowerSignal {
        doc /* Elektrische Versorgung. Richtung: Energieversorgung → Verbraucher.
             * Aus Senderperspektive definiert; Empfänger nutzt ~PowerSignal. */
        out constantCurrent :> totalCurrent;
        out constantVoltage :> voltage;
    }

    // Luftstrom (Umgebung ↔ Saugsystem)

    port def DirtyAirFlow {
        doc /* Verschmutzte Luft. Richtung: Umgebung → Saugsystem, im Saugsystem Saugeinheit → Filter.
             * Aus Senderperspektive definiert; Empfänger nutzt ~DirtyAirFlow. */
        out dirtyAirFlow :> ISQSpaceTime::volume;
    }

    port def CleanAirFlow {
        doc /* Gefilterte Luft. Richtung: Saugsystem → Umgebung.
             * Aus Senderperspektive definiert; Empfänger nutzt ~CleanAirFlow. */
        out cleanAirFlow :> ISQSpaceTime::volume;
    }

    // Controller ↔ Saugsystem

    port def FillState {
        doc /* Füllstand des Schmutzbehälters. Richtung: Saugsystem → Controller.
             * Aus Senderperspektive definiert; Empfänger nutzt ~FillState. */
        out fillState : Real;
    }

    port def SuctionLevel {
        doc /* Saugstufe. Richtung: Controller → Saugsystem.
             * Aus Senderperspektive definiert; Empfänger nutzt ~SuctionLevel. */
        out suctionLevel : Real;
    }

    port def BrushRotationLevel {
        doc /* Bürstenstufe. Richtung: Controller → Saugsystem.
             * Aus Senderperspektive definiert; Empfänger nutzt ~BrushRotationLevel. */
        out brushRotationLevel : Real;
    }


    // Interfaces zwischen den Subsystemen

    interface def SuctionLevelInterface {
        doc /* Verbindet die Saugstufe des Controllers mit dem Saugsystem. */
        end supplierPort : SuctionLevel;
        end consumerPort : ~SuctionLevel;

        flow supplierPort.suctionLevel to consumerPort.suctionLevel;
    }

    interface def BrushRotationLevelInterface {
        doc /* Verbindet die Bürstenstufe des Controllers mit dem Saugsystem. */
        end supplierPort : BrushRotationLevel;
        end consumerPort : ~BrushRotationLevel;

        flow supplierPort.brushRotationLevel to consumerPort.brushRotationLevel;
    }

    interface def FillStateInterface {
        doc /* Verbindet die Füllstandsmeldung des Saugsystems mit dem Controller. */
        end supplierPort : FillState;
        end consumerPort : ~FillState;

        flow supplierPort.fillState to consumerPort.fillState;
    }


    // Ports for Energy Supply System

    port def ChargeCommand {
        out cmd : ChargeCmdLiterals;
    }

    enum def ChargeCmdLiterals {
        START_CHARGING; 
        STOP_CHARGING;
    }

    port def EnergyRegulation {
        out attribute volt : Real;
    }

    port def EnergyDistributionCommand {
        // ToDo
    }


}
