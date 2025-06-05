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
