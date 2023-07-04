package InfraredController{
/*This module implements the InfrarotControler subsystem
 * The InfrarotControler is to ensure the position to charging point */

	item def contact;

	port def contactCharger{
		out item Contact : contact;
	}
	
	interface def infraredControllerInterface{
		end supplierPort : contactCharger;
    	end consumerPort : ~contactCharger;
    	
    	flow supplierPort.Contact to consumerPort.Contact;
	}
	
    interface def infraredControllerPassThroughInterface{
    	end supplierPort : ~contactCharger;
    	end consumerPort : ~contactCharger;
    	
    	flow supplierPort.Contact to consumerPort.Contact;
    }

	part def infraredController{
		port IsAllignedPort : contactCharger;
    } 
}