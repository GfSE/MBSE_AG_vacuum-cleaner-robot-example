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
}