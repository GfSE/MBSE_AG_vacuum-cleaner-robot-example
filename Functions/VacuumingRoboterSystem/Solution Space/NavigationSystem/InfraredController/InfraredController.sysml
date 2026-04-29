package NavigationSystem_InfraredController {
    /* This module implements the InfraredController subsystem
     * The InfraredController is to ensure the position to charging point */

    item def Contact;

    port def ContactCharger {
        out item contact : Contact;
    }

    interface def InfraredControllerInterface {
        end supplierPort : ContactCharger;
        end consumerPort : ~ContactCharger;

        flow supplierPort.contact to consumerPort.contact;
    }

    part def InfraredController {
        port contactChargerOutputPort : ContactCharger;
    }
}
