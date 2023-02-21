package FilterSystem {

	import Ports::*;
	
	part def Tank {
		port debris : ~Debris;
		port fillState : FillState;
		
		// Missing State Machine
	}
	
	part def Filter {
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;
		port debris : Debris;
	}

	part def filterSystem {
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;
		port fillState : FillState;
		
		part filter : Filter;
		part tank : Tank;
		
		interface def dirtyAirFlowPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowPorts connect
			supplierPort ::> dirtyAirFlow;
			consumerPort ::> filter.dirtyAirFlow;
			
		interface def cleanAirFlowPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirFlowPorts connect
			supplierPort ::> filter.cleanAirFlow;
			consumerPort ::> cleanAirFlow;
			
		connect filter to tank;
		
		interface def debrisPorts {
			end supplierPort : Debris;
			end consumerPort : Debris;
		}
		
		interface: dirtyAirFlowPorts connect
			supplierPort ::> filter.debris;
			consumerPort ::> tank.debris;
			
		interface def fillStatePorts {
			end supplierPort : fillState;
			end consumerPort : fillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> tank.fillState;
			consumerPort ::> fillState;
	}
}