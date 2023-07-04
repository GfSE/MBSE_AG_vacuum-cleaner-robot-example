package LaserTower{
	/* This package implements the LaserTower-System 
	 * The LaserTower finds the relative position to other objects*/
	
	item def angle;
	item def distance;
	
    port def laserTowerPosition{
        out item Angle : angle;
        out item Distance : distance;
        }

    interface def laserTowerInterface {
		end supplierPort : laserTowerPosition;
		end consumerPort : ~laserTowerPosition;

		flow supplierPort.Angle to consumerPort.Angle;
		flow supplierPort.Distance to consumerPort.Distance;
	    }
	    
    interface def laserTowerPassThroughInterface {
		end supplierPort : ~laserTowerPosition;
		end consumerPort : ~laserTowerPosition;

		flow supplierPort.Angle to consumerPort.Angle;
		flow supplierPort.Distance to consumerPort.Distance;
	    }

    part def laserTower {
        port LaserTowerPositionOutputPort : laserTowerPosition;
        }
}