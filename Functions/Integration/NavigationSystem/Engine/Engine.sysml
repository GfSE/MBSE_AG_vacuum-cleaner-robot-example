package Engine{
	/* This package implements the Engine-System 
	 * The engine drives the system*/

    part def Tire;
    item def pwm;
    
    port def pwmPort{
    	in item PWM : pwm;
    	}
    
    interface def pwmControllInterface{
    	end supplierPort : pwmPort;
    	end consumerPort : ~pwmPort;
    	
    	flow supplierPort.PWM to consumerPort.PWM;
    }

    part def engine {
        
        part motorTire : Tire [2];
        
        port PwmInputPort : pwmPort;
        
        state def motorDirection {
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
}