package vacuuming_system{
	private import BrushSystem::*;
	private import SuctionDevice::*;
	private import FilterSystem::*;
	private import Ports::*;
	private import robot_port_defs::*;

	part def VacuumingSystem{
		part bs : BrushSystem;
		part sd : SuctionDevice;
		part fs : FilterSystem;
		
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;
		port debris : Debris;
		port fillState : FillState;
		port suctionLevel : ~SuctionLevel;
		port brushRotationLevel : ~BrushRotationLevel;
		
		interface def SuctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface def RotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: rotationLevelPorts connect
			supplierPort ::> brushRotationLevel to
			consumerPort ::> bs.brushRotationLevel;	
			
		interface def ExternalDirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: externalDirtyAirPorts connect
			supplierPort ::> dirtyAirFlow to
			consumerPort ::> sd.dirtyAirFlowIn;	
			
		//connect sd to fs;
		
		interface def InternalDirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: internalDirtyAirPorts connect
			supplierPort ::> sd.dirtyAirFlowOut to
			consumerPort ::> fs.dirtyAirFlow;	
			
		interface def CleanAirPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirPorts connect
			supplierPort ::> fs.cleanAirFlow to
			consumerPort ::> cleanAirFlow;
			
		
		
		interface: uctionLevelPorts connect
			supplierPort ::> suctionLevel to
			consumerPort ::> sd.suctionLevel;
			
		interface def FillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> fs.fillState to
			consumerPort ::> fillState;
	}
}