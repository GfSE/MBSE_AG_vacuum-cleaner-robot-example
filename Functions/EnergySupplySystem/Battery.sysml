package 'Energy Supply System' {
  
  import ScalarValues::*;
  import RoboCleanRequirements::*;

  doc /*
    =======================================================================
    The following SysML v2 package specifies the battery 
    of the vacuum cleaner robot in a black-box fashion
    =======================================================================
    */  

  part def Battery {
    // ports
    port energy : PowerInOutPort;

    // data flows
    // OLD: port batterySignal : RelativeBatteryLevelPort;
    port batSig : BatterySignal;

    
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
}