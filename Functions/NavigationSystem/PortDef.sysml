package portDef{
	// global import
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    import ISQElectromagnetism::*;
    	
    port def powerSupplyPort{
        inout attribute power :> ISQElectromagnetism::instantaneousPower; // alias of electricPower
    }
    
    port def mountingPort;
    
    port def externalPowerSupplyPort {
        in attribute power :> ISQ::voltage;
        in attribute ground :> ISQ::voltage;
    }

    port def LaserTowerPosition{
        out attribute angle : Real;
        out attribute distance: Real;
    }

    port def contact;
    port def torque;
    
    port def i2c{
        attribute SDA;
        attribute SCL;
        attribute vin;
        attribute ground;
    }
    
    port def psuSignal{
        attribute isChargingPositioN : Boolean;
    }
    
    port def DriveUnitPowerSupply{
        inout attribute power :> ISQElectromagnetism::instantaneousPower; // alias of electricPower
    }
    
    port def DriverUnitControlSignal{
        // this is an example port, there are other possibilities
        in attribute forwards : Boolean;
        in attribute left : Boolean;
        in attribute right: Boolean;
    }
    	package interfaceDef{
	    import portDef::*;
	    
	    interface def EnergyInterface{
	        end supplierPort {
	            in item energyIn;
	            out item energyOut;
	        }
	        end consumerPort{
	            in item energyIn;
	            out item energyOut;
	        }
	        
	        stream supplierPort::energyOut to consumerPort::energyIn;
	        stream consumerPort::energyOut to supplierPort::energyIn;
	    }
	    
	    interface def PowerInterface{
	        end supplierPort{
	            inout item PowerInOut;
	        }
	        end consumerPort{
	            inout item PowerInOut;
	        }
	        stream supplierPort::PowerInOut to consumerPort::PowerInOut;
	    }
	}   
}
