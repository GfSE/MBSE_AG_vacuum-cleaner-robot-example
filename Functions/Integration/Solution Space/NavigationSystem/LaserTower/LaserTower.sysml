package NavigationSystem_LaserTower {
    /* This package implements the LaserTower-System 
     * The LaserTower finds the relative position to other objects */

    item def Angle;
    item def Distance;

    port def LaserTowerPosition {
        out item angle : Angle;
        out item distance : Distance;
    }

    interface def LaserTowerInterface {
        end supplierPort : LaserTowerPosition;
        end consumerPort : ~LaserTowerPosition;

        flow supplierPort.angle to consumerPort.angle;
        flow supplierPort.distance to consumerPort.distance;
    }

    part def LaserTower {
        port laserTowerPositionOutputPort : LaserTowerPosition;
    }
}
