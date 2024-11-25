package 'Robotic Vacuum Cleaner'{
	
	private import Controller::*;
	private import Navigation::*;
	private import EnergySupply::*;
	private import VacuumingSystem::*;
	private import RobotPortDefs::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : EnergySupplySystem;
		part VacuumingSystem : vacuumingSystem;

		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;

		/*interface : DriverUnitControlInterface connect
			supliertPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;
		*/
		// Interfaces to/from Vaccuming System
		connect ControllerSystem to VacuumingSystem;
				
		// Control signal for level of suction intesity
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> ControllerSystem.suctionLevel to
			consumerPort ::> VacuumingSystem.suctionLevel;
			
		// Control signal for brush rotation level
		interface def brushRotationLevelPorts {
			end supplierPort : BrushRotationLevel;
			end consumerPort : BrushRotationLevel;
		}
		
		interface: brushRotationLevelPorts connect
			supplierPort ::> ControllerSystem.brushRotationLevel to
			consumerPort ::> VacuumingSystem.bs.brushRotationLevel;
		
		// Current fill state of debris container
		interface def fillStatePorts {
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> VacuumingSystem.fillState to
			consumerPort ::> ControllerSystem.fillState;
		
		// Dirty air flow
		interface def dirtyAirPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirPorts connect
			supplierPort ::> dirtyAirFlow to
			consumerPort ::> VacuumingSystem.dirtyAirFlow;
			
		// Clean air flow
		interface def cleanAirPorts {
			end supplierPort : CleanAirFlow;
			end consumerPort : CleanAirFlow;
		}
		
		interface: cleanAirPorts connect
			supplierPort ::> VacuumingSystem.cleanAirFlow to
			consumerPort ::> cleanAirFlow;
		
	}
}
package PortDef {
    doc /*
    =======================================================================
    The following SysML v2 package DEFINES
    a power port
    R. Schuler, June 2021 
    =======================================================================
    */    
    
    private import ISQ::*;
    
    port def PowerInOutPort{
        inout attribute power :> ISQElectromagnetism::instantaneousPower;
    }

  	interface def PowerInterface {
  	    end supplierPort : PowerInOutPort;
  	    end consumerPort : PowerInOutPort;
  	}
}package Signals {
    doc /*
    =======================================================================
    The following SysML v2 package DEFINES
    multiple signal ports and interfaces
    =======================================================================
    */  
    
    private import ScalarValues::*;
    private import ISQ::*;
    
    /* Primitive and basic signals */
    
    port def BooleanSignal {
        out attribute val : Boolean;
    }
    
    interface def BooleanSignalInterface {
        end src : BooleanSignal;
        end tgt : ~BooleanSignal;
    }
    
    port def NumericSignal {
        out attribute val : Real;
    }
    
    interface def NumericSignalInterface {
        end src : NumericSignal;
        end tgt : ~NumericSignal;
    }
    
    
    /* Customized and advanced signals of the different sub-systems */
    
    package ControllerSignals {

        port def PowerSignal {
            out attribute constantCurrent :> totalCurrent;
            out attribute constantVoltage :> voltage;
        }

        interface def PowerSignalInterface {
            end src : PowerSignal;
            end tgt : ~PowerSignal;
        }

        port def DriverUnitControlSignal {
            out attribute forwards : Boolean;
            out attribute left : Boolean;
            out attribute right : Boolean;
        }
    
        interface def DriverUnitControlInterface {
            end src : DriverUnitControlSignal;
            end tgt : ~DriverUnitControlSignal;
        }
        
        port def LEDSignal {
            out color : LED_COLOR;
        }

        interface def LEDInterface {
            end src : LEDSignal;
            end tgt : ~LEDSignal;
        }

        enum def LED_COLOR {
            RED;
            YELLOW;
            GREEN;
        }

    }
    
    package BatterySignals {

        private import Signals::ControllerSignals::*;
        
        port def PowerInOutPort{
            inout attribute :> ISQMechanics::power; 
        }

        interface def PowerInterface {
            end supplierPort : PowerInOutPort;
            end consumerPort : PowerInOutPort;
        }
        
        /* wurde in "out" umbenannt, da konjugation sinnvoller ist*/
        port def VacuumSystemPowerOutPort {
            out attribute suctionPower :> ISQMechanics::power;
            out attribute brushPower :> ISQMechanics::power; 
        }
        
        interface def VacuumSystemPowerInterface {
            end supplierPort : VacuumSystemPowerOutPort;
            end consumerPort : VacuumSystemPowerOutPort;
        }

        port def LEDSignal {
            inout attribute color : LED_COLOR;
        }

        interface def LEDSignalInterface {
            end supplierPort : LEDSignal;
            end consumerPort : LEDSignal;
        }

        port def BatterySignal { // @Ralf: hier bitte ergänzen
            // current capactity of battery
            inout attribute curBatCapacity : Real; 

        }

        interface def BatterySignalInterface {
            end supplierPort : BatterySignal;
            end consumerPort : BatterySignal;
        }
    }
    
    
    

}
package Navigation{
/*This module implements the Navigation-System
 * The Navigation-System is used for navigating the system
 */
	private import RobotPortDefs::*;
	
	private import Controller::*;
	private import Bumber::*;
	private import Engine::*;
	private import LaserTower::*;
	private import DriveController::*;
	private import InfraredController::*;


	part def navigation{
		part DriveController : driveController;
		part Engine[2] : engine;
		part LaserTower : laserTower;
		part Bumber : bumber;
		part InfraredController : infraredController;

		port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		port powerSignal : PowerSignal;

		bind driverUnitControlSignalInputPort = DriveController.driverUnitControlSignalInputPort;

     	interface : bumberInterface connect
			suppliertPort ::> Bumber.CollisionOutputPort to
			consumerPort ::> DriveController.CollisionInputPort;	    	

	    interface : laserTowerInterface connect
	    	supplierPort ::> LaserTower.LaserTowerPositionOutputPort to
	    	consumerPort ::> DriveController.LaserTowerInputPort;

    	interface : infraredControllerInterface connect
    		supplierPort ::> InfraredController.ContactChargerOutputPort to
	    	consumerPort ::> DriveController.ContactChargerInputPort;    	

	    interface : pwmControllInterface connect
			suppliertPort ::> Engine.PwmInputPort to
			consumerPort ::> DriveController.PwmOutputPort;

	}
}package Controller{
	private import RobotPortDefs::*;
	private import Signals::ControllerSignals::*;
	
	port def DriverUnitControlSignal {
            out attribute forward;
            out attribute left;
            out attribute right;
    }
    
    interface def DriverUnitControlInterface{
    	end supplierPort : DriverUnitControlSignal;
    	end consumerPort : ~DriverUnitControlSignal;
    	
    	flow supplierPort.forward to consumerPort.forward;
    	flow supplierPort.left to consumerPort.left;
    	flow supplierPort.right to consumerPort.right;
    }
	
	part def controller{
		port driverSignalOutputPort : DriverUnitControlSignal;
		port powerSignal : ~PowerSignal;
		
		// To Vacuuming System
		port suctionLevel : SuctionLevel;
		port brushRotationLevel : BrushRotationLevel;
		
		// From Vacuuming System
		port fillState : ~FillState;
	}
}
package BrushSystem {
	private import ScalarValues::*;
	private import RobotPortDefs::*;
	private import ISQSpaceTime::*;
	/*
	calc def calcSetpointRPM {
		in rotationLevel : Real;
        in maxRPM :> ISQSpaceTime::rotationalFrequency;
		return : ISQSpaceTime::rotationalFrequency;

        rotationLevel * maxRPM 
    }
	*/
	part def MainBrush {
		port rotationSpeed : ~BrushRotationSpeed;
	}
	
	part def SmallBrush {
		port rotationSpeed : ~BrushRotationSpeed;
	}
	
	part def BrushController {
		//port rotationSpeed : BrushRotationSpeed = setpointRPM.rotSpeed;
		port brushRotationLevel : ~BrushRotationLevel;
		
		attribute parMaxRPM :> ISQSpaceTime::rotationalFrequency;
	/*
		calc setpointRPM : calcSetpointRPM {
			in rotationLevel = brushRotationLevel::brushRotationLevel;
			in maxRPM = parMaxRPM;
    		return rotSpeed;
		}
	*/	
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
		/*
		interface: rotationSetPointMainPorts connect
			supplierPort ::> bc.rotationSpeed to
			consumerPort ::> mb.rotationSpeed;
		
		connect bc to sb;
		*/
		interface def rotationSetPointSmallPorts {
			end supplierPort : BrushRotationSpeed;
			end consumerPort : BrushRotationSpeed;
		}
		/*
		interface: rotationSetPointSmallPorts connect
			supplierPort ::> bc.rotationSpeed to
			consumerPort ::> sb.rotationSpeed;
	*/
    }
}
		
	package FilterSystem {

	private import RobotPortDefs::*;
	
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
			end supplierPort : FillState;
			end consumerPort : FillState;
		}
		
		interface: fillStatePorts connect
			supplierPort ::> tank.fillState to
			consumerPort ::> fillState;
	}
}package SuctionDevice {

	private import RobotPortDefs::*;
	private import Ports::*;
	private import ISQ::*;
	private import ISQMechanics::*;
	private import ISQSpaceTime::*;
	private import ScalarValues::*;
/*
	calc def calcActualPower {
      	in powerLevel : Real;
		in maxPower : PowerValue;
		
		return PowerValue = powerLevel * maxPower;
  	}
        
    calc def calcVolFlow {
		in setpointPower :> ISQ::power;
		in diffPressure :> ISQ::pressure;

		return : ISQMechanics::volumeFlowRate = setpointPower / diffPressure;
	}
			
	calc def calcFlowRate {
		in inFlow :> ISQSpaceTime::volume;
		in volFlow :> ISQMechanics::volumeFlowRate;

		return : ISQSpaceTime::volume;
		// not sure how to model without time steps
		
	}*/

	part def SuctionMotor {
		port suctionLevel : ~SuctionLevel;
		port suctionPower : SuctionPower {
			//suctionPower = powerOut.res;
		}
			
		attribute parMaxPower :> ISQ::power;
		/*	
		calc powerOut : calcActualPower {
			in powerLevel = suctionLevel::suctionLevel;
			in maxPower = parMaxPower;
		    return res;
		
		}*/
			
	}
			
	part def SuctionChamber {
		port dirtyAirFlowIn : DirtyAirFlow;
		port dirtyAirFlowOut : ~DirtyAirFlow {
			//dirtyAirFlow = flowRate.currentFlowRate;
		}
		port suctionPower : ~SuctionPower;
				
		attribute parDiffPressure :> ISQ::pressure;
		/*		
		calc flowRate : calcFlowRate {
			in inFlow = dirtyAirFlowIn::dirtyAirFlow;
			in volFlow = calcVolFlow(suctionPower::suctionPower, parDiffPressure);
		    return currentFlowRate;
		}*/
	}
		
	part def suctionDevice { 
		part sm : SuctionMotor;
		part sc : SuctionChamber {
			attribute redefines parDiffPressure = 25000; // 25kPa is a common pressure difference for suction devices
		}
		
		port dirtyAirFlowIn : DirtyAirFlow;
		port dirtyAirFlowOut : ~DirtyAirFlow;
		port suctionLevel : ~SuctionLevel;

		interface def dirtyAirFlowInPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowInPorts connect
			supplierPort ::> dirtyAirFlowIn to
			consumerPort ::> sc.dirtyAirFlowIn;
		
		interface def dirtyAirFlowOutPorts {
			end supplierPort : DirtyAirFlow;
			end consumerPort : DirtyAirFlow;
		}
		
		interface: dirtyAirFlowOutPorts connect
			supplierPort ::> sc.dirtyAirFlowOut to
			consumerPort ::> dirtyAirFlowOut;
			
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
		interface: suctionLevelPorts connect
			supplierPort ::> suctionLevel to
			consumerPort ::> sm.suctionLevel;

		connect sm to sc;

		interface def suctionPowerPorts {
			end supplierPort : SuctionPower;
			end consumerPort : SuctionPower;
		}
		
		interface: suctionPowerPorts connect
			supplierPort ::> sm.suctionPower to
			consumerPort ::> sc.suctionPower;	
	}
}package VacuumingSystem{
	private import BrushSystem::*;
	private import SuctionDevice::*;
	private import FilterSystem::*;
	private import Ports::*;
	private import RobotPortDefs::*;

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
}package Bumber{
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
}package DriveController{
/* This package implements the DriveContoller-System 
 * The DriveController drives the system*/

	private import Controller::*;
	private import Bumber::*;
	private import Engine::*;
	private import LaserTower::*;
	private import InfraredController::*;
	private import InfraredController::infraredController;


    part def stearingController{
		port PwmOutputPort : ~pwmPort;
    	port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
    }

    part def orienttationController{
    	port CollisionInputPort : ~collision;
    	port LaserTowerInputPort : ~laserTowerPosition;
    	port ContactChargerInputPort : ~contactCharger;
    }

    part def driveController {
    	port CollisionInputPort : ~collision;
    	port LaserTowerInputPort : ~laserTowerPosition;
    	port PwmOutputPort : ~pwmPort;
    	port ContactChargerInputPort : ~contactCharger;
    	port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		
        part StearingController : stearingController;
        part OrientationController : orienttationController;
        
        bind CollisionInputPort = OrientationController.CollisionInputPort;
        bind PwmOutputPort = StearingController.PwmOutputPort;
        bind LaserTowerInputPort = OrientationController.LaserTowerInputPort;
        bind driverUnitControlSignalInputPort = StearingController.driverUnitControlSignalInputPort;

	}
}package Engine{
	/* This package implements the Engine-System 
	 * The engine drives the system*/

    part def Tire;
    item def pwm;
    
    port def pwmPort{
    	in item PWM : pwm;
    	}
    
    interface def pwmControllInterface{
    	end supplierPort : pwmPort;
    	end consumerPort : ~pwmPort;
    	
    	flow supplierPort.PWM to consumerPort.PWM;
    }

    part def engine {
        
        part motorTire : Tire [2];
        
        port PwmInputPort : pwmPort;
        
        state def motorDirection {
            entry; then idle;
            
            state idle;
           
            transition idle_to_left
                first idle
                then left;
            
            transition idle_to_right
                first idle
                then right;
             
            state left;               
            
            transition left_to_idle
                first left
                then idle;
            
            state right;
            
            transition right_to_idle
                first right
                then idle;               
            }
        }
}package InfraredController{
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

	part def infraredController{
		port ContactChargerOutputPort : contactCharger;
    } 
}package LaserTower{
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


    part def laserTower {
        port LaserTowerPositionOutputPort : laserTowerPosition;
        }
}