package vacuuming_system_filter {
    doc /* Filtersystem: trennt den Schmutz aus der angesaugten Luft und sammelt ihn im Tank. */

    private import ISQ::*;
    private import RobotPortDefs::*;

    port def Debris {
        doc /* Ausgefilterter Schmutz. Richtung: Filter → Tank.
             * Aus Senderperspektive definiert; Empfänger nutzt ~Debris. */
        out debrisVolume :> ISQ::volume;
        out debrisMass :> ISQ::mass;
    }

    interface def DebrisInterface {
        doc /* Verbindet den Schmutzausgang des Filters mit dem Tank. */
        end supplierPort : Debris;
        end consumerPort : ~Debris;

        flow supplierPort.debrisVolume to consumerPort.debrisVolume;
        flow supplierPort.debrisMass to consumerPort.debrisMass;
    }

    part def Filter {
        doc /* Filter: lässt saubere Luft durch und gibt den Schmutz an den Tank ab. */
        port dirtyAirFlowInputPort : ~DirtyAirFlow;
        port cleanAirFlowOutputPort : CleanAirFlow;
        port debrisOutputPort : Debris;
    }

    part def Tank {
        doc /* Schmutzbehälter: sammelt den Schmutz und meldet seinen Füllstand. */
        port debrisInputPort : ~Debris;
        port fillStateOutputPort : FillState;
    }

    part def FilterSystem {
        doc /* Filtersystem aus Filter und Schmutzbehälter. */

        // Außenports
        port dirtyAirFlowInputPort : ~DirtyAirFlow;
        port cleanAirFlowOutputPort : CleanAirFlow;
        port fillStateOutputPort : FillState;

        part filter : Filter;
        part tank : Tank;

        // Delegation Außenports → Innenteile
        bind dirtyAirFlowInputPort  = filter.dirtyAirFlowInputPort;
        bind cleanAirFlowOutputPort = filter.cleanAirFlowOutputPort;
        bind fillStateOutputPort    = tank.fillStateOutputPort;

        // Filter → Tank
        interface : DebrisInterface connect
            supplierPort ::> filter.debrisOutputPort to
            consumerPort ::> tank.debrisInputPort;
    }
}
