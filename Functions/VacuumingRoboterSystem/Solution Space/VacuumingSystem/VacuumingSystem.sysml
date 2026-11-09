package vacuuming_system {
    doc /* Saugsystem des Roboters: löst Schmutz mit den Bürsten, saugt ihn mit der
         * Saugeinheit an und trennt ihn im Filtersystem von der Luft. */

    private import RobotPortDefs::*;
    private import vacuuming_system_brush::*;
    private import vacuuming_system_suction_device::*;
    private import vacuuming_system_filter::*;

    interface def DirtyAirFlowInterface {
        doc /* Verbindet die Saugeinheit mit dem Filtersystem (verschmutzte Luft). */
        end supplierPort : DirtyAirFlow;
        end consumerPort : ~DirtyAirFlow;

        flow supplierPort.dirtyAirFlow to consumerPort.dirtyAirFlow;
    }

    part def VacuumingSystem {
        doc /* Saugsystem aus Bürstensystem, Saugeinheit und Filtersystem.
             * Bekommt Saugstufe und Bürstendrehzahl vom Controller und meldet den Füllstand zurück. */

        // Außenports
        port dirtyAirFlowInputPort : ~DirtyAirFlow;
        port cleanAirFlowOutputPort : CleanAirFlow;
        port fillStateOutputPort : FillState;
        port suctionLevelInputPort : ~SuctionLevel;
        port brushRotationLevelInputPort : ~BrushRotationLevel;

        part brushSystem : BrushSystem;
        part suctionDevice : SuctionDevice;
        part filterSystem : FilterSystem;

        // Delegation Außenports → Innenteile
        bind dirtyAirFlowInputPort       = suctionDevice.dirtyAirFlowInputPort;
        bind cleanAirFlowOutputPort      = filterSystem.cleanAirFlowOutputPort;
        bind fillStateOutputPort         = filterSystem.fillStateOutputPort;
        bind suctionLevelInputPort       = suctionDevice.suctionLevelInputPort;
        bind brushRotationLevelInputPort = brushSystem.brushRotationLevelInputPort;

        // Saugeinheit → Filtersystem
        interface : DirtyAirFlowInterface connect
            supplierPort ::> suctionDevice.dirtyAirFlowOutputPort to
            consumerPort ::> filterSystem.dirtyAirFlowInputPort;
    }
}
