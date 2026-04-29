package <VRS> VacuumingRoboterSystem {
package <VRSRE> VRS_Requirements;
package <VRSC> VRS_Context;
package <VRSUC> VRS_UseCases;
package <VRSA> VRS_Actors;
package <VRSSA> VRS_SystemArchitecture;
}

package <VRSA> VRS_Actors {

    part def Environment;
    part def Battery;
    part def NavigationSystem;
    part def VacuumingSystem;
    part def Controller;

}

package <VRSRE> VRS_Requirements {

    // Top-level requirement
    requirement def <'r1'> LowBattery{
        doc /*When the robot's battery level falls below 10%,
        it shall automatically navigate to the nearest charging station to recharge*/

        // subject : <Battery of ProblemSpace>
        subject : ESS_Bat::Battery;

        //create actor
        actor : VRSA::Battery;
        
        // Subsystem-specific requirements
        //no def needed for subrequirements
        requirement<'r1.1'> LowBattery_Navigation {
        doc /* The Navigation System shall determine the nearest charging station
               and generate a path to reach it. */
        subject : Navigation::navigation;
        //create actor
        actor : VRSA::NavigationSystem;
    }
    }

package <VRSUC> VRS_UseCases {
    private import 'Robotic Vacuum Cleaner'::*;

    use case def 'Vacuming'{
        subject roboticVacuumCleaner : RoboticVacuumCleaner;

        actor controller : RoboticVacuumCleaner;

        objective{
            doc /*
            The vacuuming robot autonomously cleans the floor by navigating its 
            * environment, 
            * detecting carpets for optimized suction, 
            * and handling low-battery situations by returning to its charging station when necessary.*/
        }

        first start;
        then action doCheckSuctionChamber;
        then action doCheckBatteryCharge;
        then action roboticVacuumCleaner:RoboticVacuumCleaner::doClean;
        //wem gehört die action "doClean" -> Robotic VaccumCleaner
        then action doCleanSuctionChamber;
        then action doRechargeBattery;
        then done; // sysml v1 -> Flow Final
    }
}


    requirement def <'r2'> CarpetDetected{
        doc /* When the robot detects a carpeted surface,
        it shall automatically increase the vacuum speed to its maximum level
         to ensure optimal cleaning performance.*/
    }
}

package <VRSC> VRS_Context {
    part def VRS_Context{
        part system :'Robotic Vacuum Cleaner'::RoboticVacuumCleaner;
        part environment : VRS_Actors::Environment;
        part battery : VRS_Actors::Battery;
        part navigation : VRS_Actors::NavigationSystem;
        part vacuuming : VRS_Actors::VacuumingSystem;
        part controller : VRS_Actors::Controller;
        
        connect environment to system;
        connect battery to system;
        connect navigation to system;
        connect vacuuming to system;
    }
}

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

		action def doClean;

		interface : DriverUnitControlInterface connect
			supplierPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		interface : DriverUnitControlInterface connect
			supplierPort ::> NavigationSystem.driverUnitControlSignalInputPort to
			consumerPort ::> NavigationSystem.DriveController.driverUnitControlSignalInputPort;

		interface : DriverUnitControlInterface connect
			supplierPort ::> NavigationSystem.DriveController.driverUnitControlSignalInputPort to
			consumerPort ::> NavigationSystem.DriveController.StearingController.driverUnitControlSignalInputPort;
		
		interface : VacuumingSystem::suctionLevelPorts connect
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
package <VRSSA> VRS_SystemArchitecture{

    private import 'Robotic Vacuum Cleaner'::*;
    private import VRSRE::*;
    private import VRSUC::*;

    // Usage of RoboticVacuumCleaner
    part System : RoboticVacuumCleaner{
        requirement req1 : LowBattery;
        satisfy req1 by EnergySystem.bat;
        satisfy req1.LowBattery_Navigation by NavigationSystem;

        use case UC1 : Vacuming{
            subject :>> roboticVacuumCleaner = self;
        }

        //wenn die Satisfy beziehung dem NavigationSystem gehört
        part :>>NavigationSystem {
            satisfy req1.LowBattery_Navigation;
        }

    }
}package RobotPortDefs {

    private import ScalarValues::*;
    private import ISQ::*;

    // Ports for Navigation System
    
    port def PowerSignal {
        out constantCurrent :> totalCurrent;
        out constantVoltage :> voltage;
    }

    // Ports for Vacuuming System

    port def DirtyAirFlow {
        out dirtyAirFlow :> ISQSpaceTime::volume;
    }

    port def CleanAirFlow {
        out cleanAirFlow :> ISQSpaceTime::volume;
    }

    port def Debris {
        out debrisVolume :> SI::'m³';
        out debrisMass :> SI::kg;
    }

    port def FillState {
        out fillState : Real;
    }

    port def SuctionLevel {
        out suctionLevel : Real;
    }

    port def SuctionPower {
        out suctionPower :> ISQ::power;
    }

    port def BrushRotationLevel {
        out brushRotationLevel : Real;
    }

    port def BrushRotationSpeed {
        out brushRotationSpeed :> ISQSpaceTime::rotationalFrequency;
    }


    // Ports for Energy Supply System

    port def ChargeCommand {
        out cmd : ChargeCmdLiterals;
    }

    enum def ChargeCmdLiterals {
        START_CHARGING; 
        STOP_CHARGING;
    }

    port def EnergyRegulation {
        out attribute volt : Real;
    }

    port def EnergyDistributionCommand {
        // ToDo
    }


}package ESS_Bat {
  
  private import ScalarValues::*;
  private import RoboCleanRequirements::*;
  private import PortDef::*;
  private import Signals::*;
  private import Signals::BatterySignals::BatterySignal;

  doc /*
    =======================================================================
    The following SysML v2 package specifies the battery 
    of the vacuum cleaner robot in a black-box fashion
    =======================================================================
    */  

  part def Battery {
    
    // current charge
    attribute capacity :> activeEnergy; 
    attribute totCapacity :> activeEnergy;

    // Ports
    port requriedEnergy : PowerInOutPort; // input from charging station
    port providedEnergy : PowerInOutPort; // output to other robot components

  }



  
  part def Accumulator {
    item def Energy;
    attribute mass : Real;
    // attribute TotCapacity : ActiveEnergyValue;
    attribute TotCapacity;
    
    part def cell {
      Capacity  : Real;
      Voltage   : Real;
    }
    
    part def cellConnector;
    
    attribute def layout {
      numOfParCells : Integer;
      numOfSerCells : Integer;
    }
  }
      
  part def BMS {  // @Ralf: now instantiated by CPU? 
                  // Maybe move to EnergySupply.sysml
    // Parts
    part def volSensor;
    part def curSensor;
    part def tempSensor;
    part def microController;
    part def Balancer;

    // Ports
    port batSig : BatterySignal;

  }
  
  comment about BMS 
  /* BMS = Battery Management System */
  

}package ESS_Processor {

	private import Signals::*;
	private import ScalarValues::*;
	private import ControllerSignals::*;
	private import Signals::BatterySignals::BatterySignal;
	private import RobotPortDefs::*;

  /**
   * This part takes a BatterySignal as input and translates it into a 
   * color to be shown by the LED of EnergySupplySystem
   */
	part def BatteryLevelComputer {
     
	  // Ports
      port energyDemand : ~EnergyDistributionCommand; // in
      port chargeCmd : ChargeCommand; // out
	  port energyLevel : EnergyRegulation; // out

    // Attributes  
    attribute batteryCapacity : Real = 1000; 
    
    // Behavior
    // Realized through a StateChart which takes inputs from the incoming port 
    // and part attribute. Produces a return value to outgoing port ledSig.
    exhibit state BatteryLevelComputerStates {
      in  ref maxBatCap     = batteryCapacity; // 'this' would be nice
      //out ref ledSig {color = computedColor;}
    }
    
	}
	
	/**
	 * As actions need to be instnatiated somewhere, we leverage a very small
	 * statechart to perform the actual computations.
	 */
	state def BatteryLevelComputerStates {
	  entry; then x;  // Initial state x
	  
	  // Definition of state x instantiates action 
	  state x { 
	    entry act {batCap; maxBatCap; computedColor;}
	  }  
	}

	action act : ComputeBatteryInfo{batCap; maxBatCap; computedColor;}
	
	/**
	 * The action ComputeBatteryInfo delegates to the calculation CalcBatteryLevel
	 */
	action def ComputeBatteryInfo{in  batteryCapacity    : Real;
	                              in  maxBatteryCapacity : Real;
	                              out batteryColor       : LED_COLOR = CalcBatteryLevel(batteryCapacity, maxBatteryCapacity);
	}
	
	calc def CalcBatteryLevel{
		in energy : Real; 
		in capacity : Real; 
        
		energy / capacity
    }

}package ESS_Charge {

  private import ScalarValues::*;
  private import PortDef::*;
  private import RobotPortDefs::*;

  part def Charger {

    attribute doCharge : Boolean;

    port chargeCmd : ~ChargeCommand;

    port statPlug : PowerInOutPort;
    port batPlug : PowerInOutPort;
  }

}package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    private import PortDef::*;
    private import Signals::*;

    private import ESS_Processor::*;
    private import ESS_Bat::Battery;
    private import ESS_Reg::*;
    private import ESS_Charge::*;
  	private import Signals::BatterySignals::BatterySignal;
    private import RobotPortDefs::*;

    
    /* Part definitions */
    // The Energy supply system provides the electical energy for the robot vacuum cleaner
    part def EnergySupplySystem {
        //signals
        attribute def LowBatterySignal;
        attribute def CharingSignal;
        attribute def ContinueVacuumingSingal;
        
        // Parts
        part chr : Charger;
        part bat : Battery;
        part cpu : BatteryLevelComputer;
        part reg : VoltageRegulator;

        // Ports
        port sig : ~EnergyDistributionCommand; // in
        port requiredEnergy : PowerInOutPort; // in
        port providedEnergy : PowerInOutPort; // out
        
       

        // Connections
        interface connect
            src ::> requiredEnergy to
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> sig to
            tgt ::> cpu.energyDemand;   

        interface connect
            src ::> reg.providedEnergy to
            tgt ::> providedEnergy;   

        // connect sub-components
        interface connect
            src ::> cpu.chargeCmd to
            tgt ::> chr.chargeCmd;   

        interface connect
            src ::> cpu.energyLevel to
            tgt ::> reg.tgtVoltage;   

        interface connect
            src ::> chr.batPlug to  
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> bat.providedEnergy to 
            tgt ::> reg.batEnergy;   

    }
    
}
package 'EnergySupplyTypes' {

	import ScalarValues::*;
  import Signals::ControllerSignals::*;

  doc /*
    =======================================================================
    This package defines basic datatypes used throughout the EnergySupply
    and related components
    =======================================================================
    */  


  // TODO: Should we use SI units?

  /// DATA TYPES ///////////////////////////////////////////////////////////////
  
  item def ElectricalEnergy;

	/// PORTS ////////////////////////////////////////////////////////////////////
	
	port def EnergyInOutPort {
	  inout item e : ElectricalEnergy; // TODO: units?
	}
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real;
    // TODO: Muss es hier ein flow feature geben
    // in ??? wert : Real; 
  }
  
  port def BatteryLevelColorPort {
    attribute color : LED_COLOR;
  }

 /// CONNECTIONS ///////////////////////////////////////////////////////////////
  
  connection def WhySoComplicated {
    end : ScalarValues::Real;
    end : ScalarValues::Real;
  }
    
  connection def EnergyToEnergy {
    end : ElectricalEnergy;
    end : ElectricalEnergy;
  }

}
package ESS_Reg {

   private import PortDef::*;
   private import RobotPortDefs::*;

   part def VoltageRegulator {

     // Ports
     port tgtVoltage : ~EnergyRegulation;
     port batEnergy : PowerInOutPort; // input from battery
     port providedEnergy : PowerInOutPort; // output to other robot components

   }

}package Navigation{
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
		action def DoNavigate;
		action def FindHome;

		part DriveController : driveController;
		part Engine[2] : engine;
		part LaserTower : laserTower;
		part Bumber : bumber;
		part InfraredController : infraredController;

		port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		port powerSignal : PowerSignal;

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
		action def IsCarpet;
		attribute def StartVacuumingSignal;
		attribute def StopVacuumingSignal;
		attribute def IdleVacuumingSignal;


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
		
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
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
			
		//connect sd to fs;
		
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
}package 'Robotic Vacuum Cleaner'{
	
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

		action def doClean;

		interface : DriverUnitControlInterface connect
			supplierPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;

		interface : DriverUnitControlInterface connect
			supplierPort ::> NavigationSystem.driverUnitControlSignalInputPort to
			consumerPort ::> NavigationSystem.DriveController.driverUnitControlSignalInputPort;

		interface : DriverUnitControlInterface connect
			supplierPort ::> NavigationSystem.DriveController.driverUnitControlSignalInputPort to
			consumerPort ::> NavigationSystem.DriveController.StearingController.driverUnitControlSignalInputPort;
		
		interface : VacuumingSystem::suctionLevelPorts connect
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
package <VRSSA> VRS_SystemArchitecture{

    private import 'Robotic Vacuum Cleaner'::*;
    private import VRSRE::*;
    private import VRSUC::*;

    // Usage of RoboticVacuumCleaner
    part System : RoboticVacuumCleaner{
        requirement req1 : LowBattery;
        satisfy req1 by EnergySystem.bat;
        satisfy req1.LowBattery_Navigation by NavigationSystem;

        use case UC1 : Vacuming{
            subject :>> roboticVacuumCleaner = self;
        }

        //wenn die Satisfy beziehung dem NavigationSystem gehört
        part :>>NavigationSystem {
            satisfy req1.LowBattery_Navigation;
        }

    }
}package RobotPortDefs {

    private import ScalarValues::*;
    private import ISQ::*;

    // Ports for Navigation System
    
    port def PowerSignal {
        out constantCurrent :> totalCurrent;
        out constantVoltage :> voltage;
    }

    // Ports for Vacuuming System

    port def DirtyAirFlow {
        out dirtyAirFlow :> ISQSpaceTime::volume;
    }

    port def CleanAirFlow {
        out cleanAirFlow :> ISQSpaceTime::volume;
    }

    port def Debris {
        out debrisVolume :> SI::'m³';
        out debrisMass :> SI::kg;
    }

    port def FillState {
        out fillState : Real;
    }

    port def SuctionLevel {
        out suctionLevel : Real;
    }

    port def SuctionPower {
        out suctionPower :> ISQ::power;
    }

    port def BrushRotationLevel {
        out brushRotationLevel : Real;
    }

    port def BrushRotationSpeed {
        out brushRotationSpeed :> ISQSpaceTime::rotationalFrequency;
    }


    // Ports for Energy Supply System

    port def ChargeCommand {
        out cmd : ChargeCmdLiterals;
    }

    enum def ChargeCmdLiterals {
        START_CHARGING; 
        STOP_CHARGING;
    }

    port def EnergyRegulation {
        out attribute volt : Real;
    }

    port def EnergyDistributionCommand {
        // ToDo
    }


}package ESS_Bat {
  
  private import ScalarValues::*;
  private import RoboCleanRequirements::*;
  private import PortDef::*;
  private import Signals::*;
  private import Signals::BatterySignals::BatterySignal;

  doc /*
    =======================================================================
    The following SysML v2 package specifies the battery 
    of the vacuum cleaner robot in a black-box fashion
    =======================================================================
    */  

  part def Battery {
    
    // current charge
    attribute capacity :> activeEnergy; 
    attribute totCapacity :> activeEnergy;

    // Ports
    port requriedEnergy : PowerInOutPort; // input from charging station
    port providedEnergy : PowerInOutPort; // output to other robot components

  }



  
  part def Accumulator {
    item def Energy;
    attribute mass : Real;
    // attribute TotCapacity : ActiveEnergyValue;
    attribute TotCapacity;
    
    part def cell {
      Capacity  : Real;
      Voltage   : Real;
    }
    
    part def cellConnector;
    
    attribute def layout {
      numOfParCells : Integer;
      numOfSerCells : Integer;
    }
  }
      
  part def BMS {  // @Ralf: now instantiated by CPU? 
                  // Maybe move to EnergySupply.sysml
    // Parts
    part def volSensor;
    part def curSensor;
    part def tempSensor;
    part def microController;
    part def Balancer;

    // Ports
    port batSig : BatterySignal;

  }
  
  comment about BMS 
  /* BMS = Battery Management System */
  

}package ESS_Processor {

	private import Signals::*;
	private import ScalarValues::*;
	private import ControllerSignals::*;
	private import Signals::BatterySignals::BatterySignal;
	private import RobotPortDefs::*;

  /**
   * This part takes a BatterySignal as input and translates it into a 
   * color to be shown by the LED of EnergySupplySystem
   */
	part def BatteryLevelComputer {
     
	  // Ports
      port energyDemand : ~EnergyDistributionCommand; // in
      port chargeCmd : ChargeCommand; // out
	  port energyLevel : EnergyRegulation; // out

    // Attributes  
    attribute batteryCapacity : Real = 1000; 
    
    // Behavior
    // Realized through a StateChart which takes inputs from the incoming port 
    // and part attribute. Produces a return value to outgoing port ledSig.
    exhibit state BatteryLevelComputerStates {
      in  ref maxBatCap     = batteryCapacity; // 'this' would be nice
      //out ref ledSig {color = computedColor;}
    }
    
	}
	
	/**
	 * As actions need to be instnatiated somewhere, we leverage a very small
	 * statechart to perform the actual computations.
	 */
	state def BatteryLevelComputerStates {
	  entry; then x;  // Initial state x
	  
	  // Definition of state x instantiates action 
	  state x { 
	    entry act {batCap; maxBatCap; computedColor;}
	  }  
	}

	action act : ComputeBatteryInfo{batCap; maxBatCap; computedColor;}
	
	/**
	 * The action ComputeBatteryInfo delegates to the calculation CalcBatteryLevel
	 */
	action def ComputeBatteryInfo{in  batteryCapacity    : Real;
	                              in  maxBatteryCapacity : Real;
	                              out batteryColor       : LED_COLOR = CalcBatteryLevel(batteryCapacity, maxBatteryCapacity);
	}
	
	calc def CalcBatteryLevel{
		in energy : Real; 
		in capacity : Real; 
        
		energy / capacity
    }

}package ESS_Charge {

  private import ScalarValues::*;
  private import PortDef::*;
  private import RobotPortDefs::*;

  part def Charger {

    attribute doCharge : Boolean;

    port chargeCmd : ~ChargeCommand;

    port statPlug : PowerInOutPort;
    port batPlug : PowerInOutPort;
  }

}package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    private import PortDef::*;
    private import Signals::*;

    private import ESS_Processor::*;
    private import ESS_Bat::Battery;
    private import ESS_Reg::*;
    private import ESS_Charge::*;
  	private import Signals::BatterySignals::BatterySignal;
    private import RobotPortDefs::*;

    
    /* Part definitions */
    // The Energy supply system provides the electical energy for the robot vacuum cleaner
    part def EnergySupplySystem {
        //signals
        attribute def LowBatterySignal;
        attribute def CharingSignal;
        attribute def ContinueVacuumingSingal;
        
        // Parts
        part chr : Charger;
        part bat : Battery;
        part cpu : BatteryLevelComputer;
        part reg : VoltageRegulator;

        // Ports
        port sig : ~EnergyDistributionCommand; // in
        port requiredEnergy : PowerInOutPort; // in
        port providedEnergy : PowerInOutPort; // out
        
       

        // Connections
        interface connect
            src ::> requiredEnergy to
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> sig to
            tgt ::> cpu.energyDemand;   

        interface connect
            src ::> reg.providedEnergy to
            tgt ::> providedEnergy;   

        // connect sub-components
        interface connect
            src ::> cpu.chargeCmd to
            tgt ::> chr.chargeCmd;   

        interface connect
            src ::> cpu.energyLevel to
            tgt ::> reg.tgtVoltage;   

        interface connect
            src ::> chr.batPlug to  
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> bat.providedEnergy to 
            tgt ::> reg.batEnergy;   

    }
    
}
package 'EnergySupplyTypes' {

	import ScalarValues::*;
  import Signals::ControllerSignals::*;

  doc /*
    =======================================================================
    This package defines basic datatypes used throughout the EnergySupply
    and related components
    =======================================================================
    */  


  // TODO: Should we use SI units?

  /// DATA TYPES ///////////////////////////////////////////////////////////////
  
  item def ElectricalEnergy;

	/// PORTS ////////////////////////////////////////////////////////////////////
	
	port def EnergyInOutPort {
	  inout item e : ElectricalEnergy; // TODO: units?
	}
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real;
    // TODO: Muss es hier ein flow feature geben
    // in ??? wert : Real; 
  }
  
  port def BatteryLevelColorPort {
    attribute color : LED_COLOR;
  }

 /// CONNECTIONS ///////////////////////////////////////////////////////////////
  
  connection def WhySoComplicated {
    end : ScalarValues::Real;
    end : ScalarValues::Real;
  }
    
  connection def EnergyToEnergy {
    end : ElectricalEnergy;
    end : ElectricalEnergy;
  }

}
package ESS_Reg {

   private import PortDef::*;
   private import RobotPortDefs::*;

   part def VoltageRegulator {

     // Ports
     port tgtVoltage : ~EnergyRegulation;
     port batEnergy : PowerInOutPort; // input from battery
     port providedEnergy : PowerInOutPort; // output to other robot components

   }

}package Navigation{
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
		action def DoNavigate;
		action def FindHome;

		part DriveController : driveController;
		part Engine[2] : engine;
		part LaserTower : laserTower;
		part Bumber : bumber;
		part InfraredController : infraredController;

		port driverUnitControlSignalInputPort : ~DriverUnitControlSignal;
		port powerSignal : PowerSignal;

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
		action def IsCarpet;
		attribute def StartVacuumingSignal;
		attribute def StopVacuumingSignal;
		attribute def IdleVacuumingSignal;


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
		
		interface def suctionLevelPorts {
			end supplierPort : SuctionLevel;
			end consumerPort : SuctionLevel;
		}
		
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
			
		//connect sd to fs;
		
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