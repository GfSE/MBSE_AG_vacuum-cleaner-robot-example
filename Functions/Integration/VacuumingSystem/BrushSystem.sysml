package BrushSystem {
	import Ports::*;
	import ISQSpaceTime::*;
	
	calc def calcSetpointRPM {
		in rotationLevel : Real;
        in maxRPM :> ISQSpaceTime::rotationalFrequency;
		return : ISQSpaceTime::rotationalFrequency;

        rotationLevel * maxRPM 
    }
	
	part def MainBrush {
		port rotationSpeed : ~BrushRotationSpeed;
	}
	
	part def SmallBrush {
		port rotationSpeed : ~BrushRotationSpeed;
	}
	
	part def BrushController {
		port rotationSpeed : BrushRotationSpeed = setpointRPM.rotSpeed;
		port brushRotationLevel : ~BrushRotationLevel;
		
		attribute parMaxRPM :> ISQSpaceTime::rotationalFrequency;
	
		calc setpointRPM : calcSetpointRPM {
			in rotationLevel = brushRotationLevel::brushRotationLevel;
			in maxRPM = parMaxRPM;
    		return rotSpeed;
		}
		
	}
	
	part def brushSystem{
		part mb : MainBrush;
		part sb : SmallBrush[2];
		part bc : BrushController{
			attribute redefines parMaxRPM = 167; // 10000 rpm is a common rotational speed of the brushes, recalculation because rotationalFrequency is [1/s]
		}
		
		port brushRotationLevel : ~BrushRotationLevel;
		
		connect bc to mb;
		
		interface def rotationSetPointMainPorts {
			end supplierPort : BrushRotationSpeed;
			end consumerPort : BrushRotationSpeed;
		}
		
		interface: rotationSetPointMainPorts connect
			supplierPort ::> bc.brushRotationSpeed;
			consumerPort ::> mb.brushRotationSpeed;
		
		connect bc to sb;
		
		interface def rotationSetPointSmallPorts {
			end supplierPort : BrushRotationSpeed;
			end consumerPort : BrushRotationSpeed;
		}
		
		interface: rotationSetPointSmallPorts connect
			supplierPort ::> bc.brushRotationSpeed;
			consumerPort ::> sb.brushRotationSpeed;
	
    }
}
		
	