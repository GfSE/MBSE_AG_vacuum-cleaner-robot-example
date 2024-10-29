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
		
		part filterCmp : Filter;
		part tank : Tank;
		
		interface def dirtyAirFlowPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowPorts connect
			supplierPort ::> dirtyAirFlow to
			consumerPort ::> filterCmp.dirtyAirFlow;
			
		interface def cleanAirFlowPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirFlowPorts connect
			supplierPort ::> filterCmp.cleanAirFlow to
			consumerPort ::> cleanAirFlow;
			
		connect filterCmp to tank;
		
		interface def debrisPorts {
			end supplierPort : Debris;
			end consumerPort : Debris;
		}
		
		interface: dirtyAirFlowPorts connect
			supplierPort ::> filterCmp.debris to
			consumerPort ::> tank.debris;
			
		interface def fillStatePorts {
			end supplierPort : fillState;
			end consumerPort : fillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> tank.fillState to
			consumerPort ::> fillState;
	}
}