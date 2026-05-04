package NavigationSystem_Engine {
    /* This package implements the Engine-System 
     * The engine drives the system */

    part def Tire;
    item def Pwm;

    port def PwmPort {
        in item pwm : Pwm;
    }

    interface def PwmControlInterface {
        end supplierPort : PwmPort;
        end consumerPort : ~PwmPort;

        flow supplierPort.pwm to consumerPort.pwm;
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
