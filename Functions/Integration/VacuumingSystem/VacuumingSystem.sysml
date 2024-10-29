package VacuumingSystem{
	import BrushSystem::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import Ports::*;

	part def vacuumingSystem{
		part bs : brushSystem;
		part sd : suctionDevice;
		part fs : filterSystem;
		
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;
		port debris : Debris;
		port fillState : FillState;
		port suctionLevel : ~SuctionLevel;
		port brushRotationLevel : ~BrushRotationLevel;
		
		interface def rotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: rotationLevelPorts connect
			supplierPort ::> brushRotationLevel to
			consumerPort ::> bs.brushRotationLevel;	
			
		interface def externalDirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: externalDirtyAirPorts connect
			supplierPort ::> dirtyAirFlow to
			consumerPort ::> sd.dirtyAirFlowIn;	
			
		connect sd to fs;
		
		interface def internalDirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: internalDirtyAirPorts connect
			supplierPort ::> sd.dirtyAirFlowOut to
			consumerPort ::> fs.dirtyAirFlow;	
			
		interface def cleanAirPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirPorts connect
			supplierPort ::> fs.cleanAirFlow to
			consumerPort ::> cleanAirFlow;
			
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> suctionLevel to
			consumerPort ::> sd.suctionLevel;
			
		interface def fillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> fs.fillState to
			consumerPort ::> fillState;
	}
}