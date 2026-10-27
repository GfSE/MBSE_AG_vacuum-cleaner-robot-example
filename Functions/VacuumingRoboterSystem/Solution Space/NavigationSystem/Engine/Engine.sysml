package NavigationSystem_Engine {
    /* This package implements the Engine-System 
     * The engine drives the system */

    part def Tire {
        doc /* Rad, das vom Motor angetrieben wird. */
    }
    item def Pwm {
        doc /* Pulsweitenmoduliertes Steuersignal für einen Motor. */
    }

    // Port aus Senderperspektive: Der DriveController liefert PWM.
    port def PwmPort {
        doc /* Überträgt ein PWM-Signal vom Steuergerät zum Motor. */
        out item pwm : Pwm;
    }

    interface def PwmControlInterface {
        end supplierPort : PwmPort;
        end consumerPort : ~PwmPort;

        flow supplierPort.pwm to consumerPort.pwm;
    }

    part def Engine {
        doc /* Elektromotor, gesteuert über ein PWM-Signal. */
        port pwmInputPort : ~PwmPort;

        exhibit state motorDirection : MotorDirection;
    }

    state def MotorDirection {
    entry; then idle;

    state idle;

    transition idle_to_left
        first idle
        then left;

    transition idle_to_right
        first idle
        then right;

    state left;

    transition left_to_idle
        first left
        then idle;

    state right;

    transition right_to_idle
        first right
        then idle;
}
}
