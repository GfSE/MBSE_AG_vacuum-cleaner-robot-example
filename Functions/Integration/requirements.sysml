package Requirement {

    requirement def <r1> LowBattery{
        doc /*When the robot's battery level falls below 10%,
        it shall automatically navigate to the nearest charging station to recharge*/
    }
    
    requirement def <r2> CarpetDetected{
        doc /*•	When the robot detects a carpeted surface,
        it shall automatically increase the vacuum speed to its maximum level
         to ensure optimal cleaning performance.*/
    }
}