package 'DriveUnit' { //Spaces lead to problems in %show
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    
    
    package Requirements {
        
        requirement def id 'Req001' MaximaleMasse {
        
            doc /* This is a textual requirement */
            
            attribute masseIST:MassValue; // MassValue comes from imported ISQ package
            attribute masseSOLL:MassValue; 
            
            require constraint {masseIST <= masseSOLL}
        }
        
        requirement def id 'Req002' Lenken {
        
            doc /* Das System muss in der Lage sein die Richtung zu wechseln */
            
            attribute lenkwinkel:Real;
                        
        }
        
        requirement def id 'Req003' Beschleunigen {
        
            doc /* Das System muss in der Lage sein zu beschleunigen und mit mindestens 0,5 km/h und maximal 1km/h zu fahren */
            
            attribute maximaleBeschleunigung:Real;
            attribute maximaleGeschwindigkeit:Real;
            
            subject motor;
                        
        }
                
    }
    
    package systemsEngineeringDomain {
        
        package ports {
         
            port def FMatter {
                in item matterIn;
                out item matterOut;
            }

            port def FEnergy {
                in item energyIn;
                out item energyOut;
            }

            port def FSignal {
                in item signalIn;
                out item signalOut;
            }
            
        }
            
        package seAbstractionLayers {

            part def Function {
                port FMatter;
                port FEnergy;
                port FSignal;
            }
            
            part def logicalThing {
                port FMatter;
                port FEnergy;
                port FSignal;
            }
            
            part def physicalThing {
                attribute cdb_object_id;
            }
        }
    }
    
    package functionalArchitecture {
        import systemsEngineeringDomain::*;
        import systemsEngineeringDomain::seAbstractionLayers::*;
        import systemsEngineeringDomain::ports::*;
        
        interface def energySupply {
            end supplierPort : FEnergy;
            end consumerPort : FEnergy;
        }
        
        part functionalArchitecture {

            part Beschleunigen : Function {
                port redefines FEnergy;
            }

            part EnergieSpeichern : Function {
                port redefines FEnergy;
            }
            
            interface : energySupply connect supplierPort => EnergieSpeichern::FEnergy to consumerPort => Beschleunigen::FEnergy;
        }
    }

    package calculationDefinition{
        calc def Torque (current:>SI::A, voltage:>ISQ::voltage, rpm0:>ISQ::frequency):> ISQ::torque {
                attribute POut = 0.95 * current * voltage;
                attribute omega = 2 * 3.14 * rpm0;

                POut / omega // return value
        }
    }

    package portDef{
        port def powerSupplyPort{
                out attribute power :> ISQ::voltage;
                out attribute ground :> ISQ::voltage;
        }

        port def LaserTowerPosition{
                out attribute angle : Real;
                out attribute distance: Real;
            }

        port def contact;
        port def torque;
    }

    package partDef
    {
        import portDef::*;

        part def tire {
            attribute diameter : LengthValue; //LengthValue kommt aus dem ISQ-Paket und beinhaltet ein Real und eine Einheit
        }
        
        enum def EeArchitecture {
            enum arm;
            enum arm64;
            enum i386;
            enum amd64;
        }

        part def driveController {
            attribute architecture : EeArchitecture;
            
            part stearingController;
            part orientationController;
        }
        
        part def dcMotor {
            attribute maxTorque :> ISQ::torque; // maximales Drehmoment
            attribute rpm0 : Real; // Nenndrehzahl
            attribute voltage :> ISQ::voltage; // Voltage;
            
            action def ConvertEletricalToMechanicalEnergy (in current, in voltage, in rpm0, out mechanicalEnergy) {
                calc Torque;
            }
            
            action def ProvideTorque (in current, in voltage, in rpm0, out torque:>ISQ::torque) {
                
                bind convertEnergy::current = current;
                bind convertEnergy::voltage = voltage;
                bind convertEnergy::rpm0 = rpm0;
                
                action convertEnergy:ConvertEletricalToMechanicalEnergy (in current, in voltage, in rpm0, out mechanicalEnergy);
                
                bind convertEnergy::mechanicalEnergy = torque;
                
            }
                
            port psu :powerSupplyPort;
            port Torque : torque;
            
            part motorTire : tire [1..2];
            
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

        part def Lasertower {
            attribute distance : LengthValue; // abstand in meter
            attribute distanceAngle : Real; // winkel der zum abstand gemessen wurden
            attribute motor; // für das rotieren
            port position : LaserTowerPosition;
            port psu : powerSupplyPort;
        }

        part def Bumber {
            attribute isContact : Boolean;

            port Contact : contact;
        }

        part def infrarotController{
                // berechnet Abbstand
            //sendet signal
        }

        part def Infrarotdiode {
            attribute isPSU : Boolean; // wir fahren gerade auf die powersupply zu
            attribute psuDistance : LengthValue;
            part InfrarotController;
            port infrared{
                out attribute signalOut;
                in attribute signalIn;
            }
            port psu :powerSupplyPort;
        }  
    }
        
    package logicalArchitecture {
        
        import ScalarValues::*;
        import ISQ::*;
        //import ISQ::Electromagnetism::*; // Für import von voltage
        import SI::*; 
        import Requirements::*;
        import functionalArchitecture::*;
        import calculationDefinition::*;
        import partDef::*;
        
        
        //part def testInheritance :> dcMotor; // Dies ist eine echte Vererbung
        
        part def logicalDriveUnit {

            part motor1 : dcMotor {
                part tire1 redefines motorTire[1];
            }
            part motor2 : dcMotor {
                part tire2 redefines motorTire[1];
            }
            part drvController : driveController{ 
                attribute redefines architecture = EeArchitecture::arm; //man muss bei "redefine" keinen neuen Namen vergeben.
            }
            part orientation : Lasertower;
            part collision : Bumber;
            part psuDetection : Infrarotdiode;
        }
        //satisfy Beschleunigen by driveUnit; // Funktioniert noch nicht
    }
    
    package systemContext{
        import logicalArchitecture::*;
        import portDef::*;

        part def driveUnit{
            part driver : logicalDriveUnit;
            port psu :powerSupplyPort;
            
            }
        }
    }
}
