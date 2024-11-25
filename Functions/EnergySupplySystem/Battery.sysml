package 'ESS::Bat' {
  
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
  

}