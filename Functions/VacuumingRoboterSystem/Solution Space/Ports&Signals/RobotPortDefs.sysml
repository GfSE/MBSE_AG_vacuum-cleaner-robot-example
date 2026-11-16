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


    // Controller ↔ Navigation

    enum def DriveMode {
        doc /* Fahrauftrag des Controllers an die Navigation. */
        enum cleanRoom;      // Raum abfahren
        enum returnToDock;   // zur Ladestation fahren
        enum stop;           // anhalten
    }

    port def DriveTask {
        doc /* Fahrauftrag: wohin die Navigation fahren soll. Richtung: Controller → Navigation.
             * Aus Senderperspektive definiert; Empfänger nutzt ~DriveTask. */
        out attribute driveMode : DriveMode;
    }

    port def NavigationStatus {
        doc /* Zustand der Fahrt. Richtung: Navigation → Controller.
             * Aus Senderperspektive definiert; Empfänger nutzt ~NavigationStatus. */
        out attribute roomCovered : Boolean;   // Raum vollständig abgefahren
        out attribute docked : Boolean;        // an der Ladestation angedockt
        out attribute driveFault : Boolean;    // Fahrt nicht möglich (z. B. festgefahren)
    }

    // Controller ↔ Energieversorgung

    port def BatteryLevel {
        doc /* Ladezustand der Batterie, 0 = leer, 1 = voll. Richtung: Energieversorgung → Controller.
             * Aus Senderperspektive definiert; Empfänger nutzt ~BatteryLevel. */
        out attribute stateOfCharge : Real;
    }


    // Interfaces zwischen den Subsystemen

    interface def DriveTaskInterface {
        doc /* Verbindet den Fahrauftrag des Controllers mit der Navigation. */
        end supplierPort : DriveTask;
        end consumerPort : ~DriveTask;

        flow supplierPort.driveMode to consumerPort.driveMode;
    }

    interface def NavigationStatusInterface {
        doc /* Verbindet die Statusmeldung der Navigation mit dem Controller. */
        end supplierPort : NavigationStatus;
        end consumerPort : ~NavigationStatus;

        flow supplierPort.roomCovered to consumerPort.roomCovered;
        flow supplierPort.docked to consumerPort.docked;
        flow supplierPort.driveFault to consumerPort.driveFault;
    }

    interface def BatteryLevelInterface {
        doc /* Verbindet den Ladezustand der Energieversorgung mit dem Controller. */
        end supplierPort : BatteryLevel;
        end consumerPort : ~BatteryLevel;

        flow supplierPort.stateOfCharge to consumerPort.stateOfCharge;
    }


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
