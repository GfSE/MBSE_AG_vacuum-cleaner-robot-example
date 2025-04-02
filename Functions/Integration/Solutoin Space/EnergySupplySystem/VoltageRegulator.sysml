package ESS_Reg {

   private import PortDef::*;
   private import RobotPortDefs::*;

   part def VoltageRegulator {

     // Ports
     port tgtVoltage : ~EnergyRegulation;
     port batEnergy : PowerInOutPort; // input from battery
     port providedEnergy : PowerInOutPort; // output to other robot components

   }

}