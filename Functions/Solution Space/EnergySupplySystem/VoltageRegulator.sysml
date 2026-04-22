package ess_reg {

   private import PortDef::*;
   private import robot_port_defs::*;

   part def VoltageRegulator {

     // Ports
     port tgtVoltage : ~EnergyRegulation;
     port batEnergy : PowerInOutPort; // input from battery
     port providedEnergy : PowerInOutPort; // output to other robot components

   }

}