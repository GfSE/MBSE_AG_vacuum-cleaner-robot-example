package EnergySupply {    
    /**
     * The CPU performs computations of the EnergySupplySystem. To this end
     * it has two parts taking care of battery management and indicating the
     * current battery level to the user.
     */
    part def CPU {
        // Parts
        part blc        : BatteryLevelComputer;
        part bms        : BatteryMangementSystem; // TODO: Needs to be imported

        // Ports
        port energy     : PowerInOutPort; // in
        port batSig     : BatterySignal; // in
        port ledSig     : LEDSignal; // out

        interface : BatterySignalInterface connect
            src => batSig to
            tgt => bms::batSig;

        interface : BatterySignalInterface connect
            src => batSig to
            tgt => blc::batSig;

        interface : LEDSignalInterface connect
            src => batSig to
            tgt => bms::ledSig;
    }
}    