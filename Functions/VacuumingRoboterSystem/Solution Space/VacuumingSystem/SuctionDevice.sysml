package vacuuming_system_suction_device {
    doc /* Saugeinheit: Der Saugmotor erzeugt Saugleistung, mit der die Saugkammer
         * die verschmutzte Luft ansaugt und weiterleitet. */

    private import ISQ::*;
    private import RobotPortDefs::*;

    port def SuctionPower {
        doc /* Saugleistung. Richtung: SuctionMotor → SuctionChamber.
             * Aus Senderperspektive definiert; Empfänger nutzt ~SuctionPower. */
        out suctionPower :> ISQ::power;
    }

    interface def SuctionPowerInterface {
        doc /* Verbindet den Saugmotor mit der Saugkammer. */
        end supplierPort : SuctionPower;
        end consumerPort : ~SuctionPower;

        flow supplierPort.suctionPower to consumerPort.suctionPower;
    }

    part def SuctionMotor {
        doc /* Saugmotor: erzeugt abhängig von der Saugstufe die Saugleistung. */
        port suctionLevelInputPort : ~SuctionLevel;
        port suctionPowerOutputPort : SuctionPower;

        attribute parMaxPower :> ISQ::power;
    }

    part def SuctionChamber {
        doc /* Saugkammer: saugt mit der Saugleistung verschmutzte Luft an und gibt sie an den Filter weiter. */
        port dirtyAirFlowInputPort : ~DirtyAirFlow;
        port dirtyAirFlowOutputPort : DirtyAirFlow;
        port suctionPowerInputPort : ~SuctionPower;

        attribute parDiffPressure :> ISQ::pressure;
    }

    part def SuctionDevice {
        doc /* Saugeinheit aus Saugmotor und Saugkammer. */

        // Außenports
        port dirtyAirFlowInputPort : ~DirtyAirFlow;
        port dirtyAirFlowOutputPort : DirtyAirFlow;
        port suctionLevelInputPort : ~SuctionLevel;

        part suctionMotor : SuctionMotor;
        part suctionChamber : SuctionChamber {
            // 25 kPa sind eine übliche Druckdifferenz für Saugeinheiten
            attribute redefines parDiffPressure = 25000;
        }

        // Delegation Außenports → Innenteile
        bind dirtyAirFlowInputPort  = suctionChamber.dirtyAirFlowInputPort;
        bind dirtyAirFlowOutputPort = suctionChamber.dirtyAirFlowOutputPort;
        bind suctionLevelInputPort  = suctionMotor.suctionLevelInputPort;

        // Saugmotor → Saugkammer
        interface : SuctionPowerInterface connect
            supplierPort ::> suctionMotor.suctionPowerOutputPort to
            consumerPort ::> suctionChamber.suctionPowerInputPort;
    }
}
