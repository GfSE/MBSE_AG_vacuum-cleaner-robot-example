package Bumber{
	/* This package implements the Bumber-System 
	 * The Bumber detects collision*/

	item def collisionDetection;
	
	port def collision {
		out item CollisionDetection : collisionDetection;
	}
    
    interface def bumberInterface{
    	end supplierPort : collision;
    	end consumerPort : ~collision;
    	
    	flow supplierPort.CollisionDetection to consumerPort.CollisionDetection;
    }
   
	part def bumber {
        port CollisionOutputPort : collision;
    }
}