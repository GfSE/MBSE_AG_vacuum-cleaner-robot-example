package ess_bat {
  
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
    attribute totCapacity;
    
    part def Cell {
      capacity  : Real;
      voltage   : Real;
    }
    
    part def CellConnector;
    
    attribute def Layout {
      numOfParCells : Integer;
      numOfSerCells : Integer;
    }
  }
      
  part def BMS {  // @Ralf: now instantiated by CPU? 
                  // Maybe move to EnergySupply.sysml
    // Parts
    part def VolSensor;
    part def CurSensor;
    part def TempSensor;
    part def MicroController;
    part def Balancer;

    // Ports
    port batSig : BatterySignal;

  }
  
  comment about BMS 
  /* BMS = Battery Management System */

}