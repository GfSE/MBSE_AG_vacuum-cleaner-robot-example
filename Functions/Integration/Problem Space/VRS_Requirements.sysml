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
        actor : VRSA::NavigationSystem; //falsch?
    }
    }



    requirement def <'r2'> CarpetDetected{
        doc /* When the robot detects a carpeted surface,
        it shall automatically increase the vacuum speed to its maximum level
         to ensure optimal cleaning performance.*/
    }
}