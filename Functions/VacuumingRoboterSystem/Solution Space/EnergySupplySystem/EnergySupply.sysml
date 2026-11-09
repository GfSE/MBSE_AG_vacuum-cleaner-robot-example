package energy_supply {
    doc /* Energieversorgung des Roboters: lädt die Batterie an der Ladestation,
         * überwacht den Ladezustand und stellt den anderen Subsystemen Energie bereit. */

    private import PortDef::*;
    private import RobotPortDefs::*;
    private import ess_processor::*;
    private import ess_bat::Battery;
    private import ess_reg::*;
    private import ess_charge::*;

    interface def ChargeCommandInterface {
        doc /* Verbindet den Ladebefehl des BatteryLevelComputers mit dem Ladegerät. */
        end supplierPort : ChargeCommand;
        end consumerPort : ~ChargeCommand;

        flow supplierPort.cmd to consumerPort.cmd;
    }

    interface def EnergyRegulationInterface {
        doc /* Verbindet die Sollspannung des BatteryLevelComputers mit dem Spannungsregler. */
        end supplierPort : EnergyRegulation;
        end consumerPort : ~EnergyRegulation;

        flow supplierPort.volt to consumerPort.volt;
    }

    part def EnergySupplySystem {
        doc /* Energieversorgung aus Ladegerät, Batterie, BatteryLevelComputer und Spannungsregler. */

        // Außenports
        port energyDistributionCommandInputPort : ~EnergyDistributionCommand;
        port stationEnergyInputPort : PowerInOutPort;   // von der Ladestation
        port energyOutputPort : PowerInOutPort;         // an die anderen Subsysteme

        part charger : Charger;
        part battery : Battery;
        part batteryLevelComputer : BatteryLevelComputer;
        part voltageRegulator : VoltageRegulator;

        // Delegation Außenports → Innenteile
        bind stationEnergyInputPort             = charger.stationEnergyInputPort;
        bind energyDistributionCommandInputPort = batteryLevelComputer.energyDemand;
        bind energyOutputPort                   = voltageRegulator.energyOutputPort;

        // BatteryLevelComputer → Ladegerät und Spannungsregler
        interface : ChargeCommandInterface connect
            supplierPort ::> batteryLevelComputer.chargeCmd to
            consumerPort ::> charger.chargeCommandInputPort;

        interface : EnergyRegulationInterface connect
            supplierPort ::> batteryLevelComputer.energyLevel to
            consumerPort ::> voltageRegulator.targetVoltageInputPort;

        // Energiefluss: Ladegerät → Batterie → Spannungsregler
        interface : PowerInterface connect
            supplierPort ::> charger.batteryEnergyOutputPort to
            consumerPort ::> battery.energyInputPort;

        interface : PowerInterface connect
            supplierPort ::> battery.energyOutputPort to
            consumerPort ::> voltageRegulator.batteryEnergyInputPort;
    }
}
