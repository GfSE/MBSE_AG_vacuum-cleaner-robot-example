package 'BatteryTerminology' {
    // Introduces domain specific types 
    // which is to support a terminology aligned in the project.

    public import Metaobjects::*;
    public import ISQ::*;

    package CustomTypes {
        private import ScalarValues::*;

        // Percentage from 0 to 100
        attribute def Percentage :> Real {
            assert constraint { that >= 0.0 and that <= 100.0 }
            // 'that' refers to an instance of the attribute that is evaluated
        }
    }

    // A. Applies to *many* parts 
    // (Candidate for a package 'ProjectTerminology'?)
    // enum def AsilLevel {
       // enum QM;
       // enum ASIL_A;
       // enum ASIL_B;
       // enum ASIL_C;
       // enum ASIL_D;
    // }

    // metadata def SafetyCriticality specializes SemanticMetadata {
       // attribute asilLevel : AsilLevel;
    // }

    // B. Applies to *one* part, the battery. Applies to the life span of the battery,
    // starting with the supply from the battery factory, ending with withdrawal.
    metadata def BatteryTechnicalSpecification {
        attribute nominalVoltage : ElectricPotentialDifferenceValue;
        attribute cutOffVoltage : ElectricPotentialDifferenceValue;
    }

    // A user of this package may want to say ..
    // package 'MyPackage' {
    //    public import 'BatteryTerminology'::*;
    //    public import 'CustomTypes'::*;
}
