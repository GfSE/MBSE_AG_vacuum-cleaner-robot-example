package NavigationSystem_Engine {
    doc /* Antriebsmotor des Roboters: PWM-gesteuert, treibt ein Rad an. */

    private import RobotPortDefs::*;

    part def Tire {
        doc /* Rad, das vom Motor angetrieben wird. */
    }

    item def Pwm {
        doc /* Pulsweitenmoduliertes Steuersignal für einen Motor. */
    }

    port def PwmPort {
        doc /* Richtung: DriveController → Engine.
             * Aus Senderperspektive definiert; Empfänger nutzt ~PwmPort. */
        out item pwm : Pwm;
    }

    interface def PwmControlInterface {
        doc /* Verbindet einen PWM-Ausgang des DriveControllers mit einem Motor. */
        end supplierPort : PwmPort;
        end consumerPort : ~PwmPort;

        flow supplierPort.pwm to consumerPort.pwm;
    }

    part def Engine {
        doc /* Elektromotor, gesteuert über ein PWM-Signal und versorgt über einen Stromeingang. */
        port pwmInputPort : ~PwmPort;
        port powerInputPort : ~PowerSignal;

        exhibit state motorDirection : MotorDirection;
    }

    state def MotorDirection {
        doc /* Drehrichtungszustände des Motors. Trigger folgen mit dem Verhalten. */
        entry; then idle;

        state idle;
        state left;
        state right;

        transition idle_to_left  first idle  then left;
        transition left_to_idle  first left  then idle;
        transition idle_to_right first idle  then right;
        transition right_to_idle first right then idle;
    }
}