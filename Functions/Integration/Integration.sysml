package 'Robotic Vacuum Cleaner'{
	
	import Controller::*;
	import Navigation::*;
	import EnergySupplySystem::*;
	import VacuumingSystem::*;
	import RobotPortDefs::*;
	
	part def RoboticVacuumCleaner{
		part ControllerSystem : controller;
		part NavigationSystem : navigation;
		part EnergySystem : energySupplySystem;
		part VacuumingSystem : vacuumingSystem;

		port driverUnitControlSignal : DriverUnitControlSignal;
		port powerSignal : PowerSignal;
		port dirtyAirFlow : DirtyAirFlow;
		port cleanAirFlow : CleanAirFlow;

		interface : DriverUnitControlInterface connect
			supliertPort ::> ControllerSystem.driverSignalOutputPort to
			consumerPort ::> NavigationSystem.driverUnitControlSignalInputPort;
		
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
package 'Energy Supply System' {
  
  import ScalarValues::*;
  import RoboCleanRequirements::*;
  import PortDef::*;
  import Signals::*;
  import Signals::BatterySignals::BatterySignal;

  doc /*
    =======================================================================
    The following SysML v2 package specifies the battery 
    of the vacuum cleaner robot in a black-box fashion
    =======================================================================
    */  

  part def Battery {
    // Ports
    port requriedEnergy : PowerInOutPort; // in
    port providedEnergy : PowerInOutPort; // out
    port batSig         : BatterySignal; // out

    
    // TOOD: Decompose in individual cells
    
    // TODO: Add battery management such as overcharging protection
  }

  // The Energy supply system provides the electical energy for the robot vacuum cleaner

  attribute def essStatus {
    statusLED : Integer;
    SOC       : Real; 
  }
  
  comment about essStatus 
  /* SOC = State of Charge */
  
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
  
  part def Charger {
    attribute power : Real;
    attribute voltage : Real;
    
    part def Plug;
    part def Converter; // ACDC Converter
    part def batConector;
  }
}package 'BatteryLevelComputer' {

	import Signals::*;
	import ScalarValues::*;
	import ControllerSignals::*;
	import Signals::BatterySignals::BatterySignal;

  /**
   * This part takes a BatterySignal as input and translates it into a 
   * color to be shown by the LED of EnergySupplySystem
   */
	part def BatteryLevelComputer {
     // Ports
     port batSig : BatterySignal; // in
     port ledSig : LEDSignal; // out
  
    // Attributes  
    attribute batteryCapacity : Real = 1000; 
    
    // Behavior
    // Realized through a StateChart which takes inputs from the incoming port 
    // and part attribute. Produces a return value to outgoing port ledSig.
    exhibit state BatteryLevelComputerStates {
      in  ref batCap        = batSig::curBatCapacity;
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

}package EnergySupplyProcessor {  

    import BatteryLevelComputer::BatteryLevelComputer;
    import Signals::BatterySignals::*;

    /**
     * The CPU performs computations of the EnergySupplySystem. To this end
     * it has two parts taking care of battery management and indicating the
     * current battery level to the user.
     */
    part def CPU {
        // Parts
        part blc        : BatteryLevelComputer;
        part bms        : BatteryMangementSystem; // TODO: Needs to be defined and imported properly

        // Ports
        port requriedEnergy : PowerInOutPort; // in
        port batSig         : BatterySignal; // in
        port ledSig         : LEDSignal; // out

        interface : BatterySignalInterface connect
            src ::> batSig to
            tgt ::> bms::batSig;

        interface : BatterySignalInterface connect
            src ::> batSig to
            tgt ::> blc::batSig;

        interface : LEDSignalInterface connect
            src ::> batSig to
            tgt ::> bms::ledSig;
    }

    // just a surrogate
    part def BatteryMangementSystem {
        port batSig         : BatterySignal; 
        port ledSig         : LEDSignal; 
    }
}    package DockingStation {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the charging
    station of the vacuum cleaner robot
    =======================================================================
    */    
    
    import PortDef::*;
    import Signals::*;
    import Signals::ControllerSignals::PowerSignal;
    
    part def Station {
        part charger : Charger;
    }
    
    part def Charger {
        port energy        : PowerInOutPort;
        port emergencyStop : ~BooleanSignal;
        port powerSignal   : ~PowerSignal;
    }
    
    part charger : Charger;
    
}
package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    import PortDef::*;
    import Signals::*;
    import DockingStation::*;
    import BatteryLevelComputer::*;
    import 'Energy Supply System'::*;
    import EnergySupplyProcessor::*;
    import BLI::LED;

    
    /* Part definitions */
    
    part def EnergySupplySystem {
        // Parts
        part bat : Battery;
        part cpu : CPU;
        part led : LED;

        // Ports
        port requiredEnergy : PowerInOutPort; // in

        // Connections
      /*  interface : RequiredEnergyInterface connect
            src ::> requiredEnergy to
            tgt ::> bat::requiredEnergy;*/

        interface : PowerInterface connect
            src ::> bat::providedEnergy to
            tgt ::> cpu::requriedEnergy;        

        interface : PowerInterface connect
            src ::> bat::providedEnergy to
            tgt ::> led::requriedEnergy;

        interface : BatterySignalInterface connect
            src ::> bat::batSig to
            tgt ::> cpu::batSig;

        interface : LEDSignalInterface connect
            src ::> cpu::ledSig to
            tgt ::> led::ledSignal;


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
package 'BLI' {
  import PortDef::*;
  import Signals::*;
  import Signals::ControllerSignals::*;
  import EnergySupplyTypes::*;

  part def LED {   
    // Ports
    port ledSignal 			: LEDSignal; 
    port requriedEnergy : EnergyInOutPort;
  }

	action def setColor{
    in color : LED_COLOR; 
 	  language "Java"
	  /* 
	   * Here, we could pollute our model with actual Java code for a 
	   * robot-specific middleware / implementation. With this being out of 
	   * scope of this example, the body of this opaque method is empty.
	   */
	}
}package DriveUnit{
	// global imports
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    import ISQElectromagnetism::*;
	import partDef::*;
	import PortDef::*;	
    
	    
	part def logicalDriveUnit {

	    part motor1 : dcMotor {
	        part tire1 redefines motorTire[1];
	    }
	    part motor2 : dcMotor {
	        part tire2 redefines motorTire[1];
	    }
	    part drvController : driveController{ 
	        attribute redefines architecture = EeArchitecture::arm; //man muss bei "redefine" keinen neuen Namen vergeben.
	    }
	    part orientation : Lasertower;
	    part collision : Bumber;
	    part psuDetection : timeofFlightController;
	    
	    port powerSupply : DriveUnitPowerSupply;
	    port controlSignal : DriverUnitControlSignal;

	}
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::motor1::psu;
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::motor2::psu;
	    interface : PowerInterface connect supplierPort ::> logicalDriveUnit::powerSupply to consumerPort ::> logicalDriveUnit::orientation::psu;

	//satisfy Beschleunigen by driveUnit; // Funktioniert noch nicht
	}

    package partDef
{
    import portDef::*;

    part def tire {
        attribute diameter : LengthValue; //LengthValue kommt aus dem ISQ-Paket und beinhaltet ein Real und eine Einheit
    }
    
    enum def EeArchitecture {
        enum arm;
        enum arm64;
        enum i386;
        enum amd64;
    }

    part def driveController {
        attribute architecture : EeArchitecture;
        
        part stearingController;
        part orientationController;
    }
    
    part def dcMotor {
        attribute maxTorque :> ISQ::torque; // maximales Drehmoment
        attribute rpm0 : Real; // Nenndrehzahl
        attribute voltage :> ISQ::voltage; // Voltage;
        
        action def ConvertEletricalToMechanicalEnergy {
            in current; 
            in voltage; 
            in rpm0; 
            out mechanicalEnergy;

            calc Torque;
        }
        
        action def ProvideTorque {
            in current; 
            in voltage; 
            in rpm0; 
            out torque:>ISQ::torque;
            
            bind convertEnergy::current = current;
            bind convertEnergy::voltage = voltage;
            bind convertEnergy::rpm0 = rpm0;
            
            action convertEnergy:ConvertEletricalToMechanicalEnergy {in current; in voltage; in rpm0; out mechanicalEnergy;}
            
            bind convertEnergy::mechanicalEnergy = torque;
            
        }
            
        port psu :powerSupplyPort;
        port Torque : torque;
        
        part motorTire : tire [1..2];
        
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

    part def Lasertower {
        attribute distance : LengthValue; // abstand in meter
        attribute distanceAngle : Real; // winkel der zum abstand gemessen wurden
        attribute motor; // für das rotieren
        port position : LaserTowerPosition;
        port psu : powerSupplyPort;
    }

    part def Bumber {
        attribute isContact : Boolean;

        port Contact : contact;
    }

    part def infrarotController{
            // berechnet Abbstand
        //sendet signal
    }
    part def timeOfFlightSensor{
        port i2cSlave : i2c;
    }
    
    part def timeofFlightController{
        part timeOfFlightSensor;
        port psu : powerSupplyPort;
        port i2cMaster : i2c;
        
    }  
}package portDef{
	// global import
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    import ISQElectromagnetism::*;
    	
    port def powerSupplyPort{
        inout attribute power :> ISQElectromagnetism::instantaneousPower; // alias of electricPower
    }
    
    port def mountingPort;
    
    port def externalPowerSupplyPort {
        in attribute power :> ISQ::voltage;
        in attribute ground :> ISQ::voltage;
    }

    port def LaserTowerPosition{
        out attribute angle : Real;
        out attribute distance: Real;
    }

    port def contact;
    port def torque;
    
    port def i2c{
        attribute SDA;
        attribute SCL;
        attribute vin;
        attribute ground;
    }
    
    port def psuSignal{
        attribute isChargingPositioN : Boolean;
    }
    
    port def DriveUnitPowerSupply{
        inout attribute power :> ISQElectromagnetism::instantaneousPower; // alias of electricPower
    }
    
    port def DriverUnitControlSignal{
        // this is an example port, there are other possibilities
        in attribute forwards : Boolean;
        in attribute left : Boolean;
        in attribute right: Boolean;
    }
    	package interfaceDef{
	    import portDef::*;
	    
	    interface def EnergyInterface{
	        end supplierPort {
	            in item energyIn;
	            out item energyOut;
	        }
	        end consumerPort{
	            in item energyIn;
	            out item energyOut;
	        }
	        
	        flow supplierPort::energyOut to consumerPort::energyIn;
	        flow consumerPort::energyOut to supplierPort::energyIn;
	    }
	    
	    interface def PowerInterface{
	        end supplierPort{
	            inout item PowerInOut;
	        }
	        end consumerPort{
	            inout item PowerInOut;
	        }
	        flow supplierPort::PowerInOut to consumerPort::PowerInOut;
	    }
	}   
}
