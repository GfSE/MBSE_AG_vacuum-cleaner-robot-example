package NavigationSystem_Bumper { 
    /* This package implements the Bumper-System 
     * The Bumper detects collision */

    item def CollisionDetection;

    port def CollisionPort {
        out item collisionDetection : CollisionDetection;
    }

    interface def BumberInterface {
        end supplierPort : CollisionPort;
        end consumerPort : ~CollisionPort;

        flow supplierPort.collisionDetection to consumerPort.collisionDetection;
    }

    part def Bumper {
        port collisionOutputPort : CollisionPort;
    }
}
