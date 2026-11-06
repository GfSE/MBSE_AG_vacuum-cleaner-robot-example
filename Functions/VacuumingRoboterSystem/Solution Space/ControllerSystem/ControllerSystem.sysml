package ControllerSystem_Controller {
    doc /* Zentrale Steuerung des Roboters: gibt Fahrbefehle an die Navigation,
         * Saugstufe und Bürstendrehzahl an das Saugsystem und überwacht den Füllstand. */

    private import ScalarValues::*;
    private import RobotPortDefs::*;

    port def DriverUnitControlPort {
        doc /* Fahrbefehl. Richtung: Controller → Navigation.
             * Aus Senderperspektive definiert; Empfänger nutzt ~DriverUnitControlPort. */
        out attribute forward : Boolean;
        out attribute left : Boolean;
        out attribute right : Boolean;
    }

    interface def DriverUnitControlInterface {
        doc /* Verbindet den Fahrbefehlsausgang des Controllers mit der Navigation. */
        end supplierPort : DriverUnitControlPort;
        end consumerPort : ~DriverUnitControlPort;

        flow supplierPort.forward to consumerPort.forward;
        flow supplierPort.left to consumerPort.left;
        flow supplierPort.right to consumerPort.right;
    }

    part def Controller {
        doc /* Steuergerät des Roboters. Entscheidet, wohin gefahren und wie stark gesaugt wird. */

        // Zur Navigation
        port driverUnitControlOutputPort : DriverUnitControlPort;

        // Zum Saugsystem
        port suctionLevelOutputPort : SuctionLevel;
        port brushRotationLevelOutputPort : BrushRotationLevel;

        // Vom Saugsystem
        port fillStateInputPort : ~FillState;

        // Versorgung
        port powerInputPort : ~PowerSignal;
    }
}
