package vacuuming_system_brush {
    doc /* Bürstensystem: eine Hauptbürste und zwei Seitenbürsten, angesteuert von einem Bürstencontroller. */

    private import RobotPortDefs::*;

    port def BrushRotationSpeed {
        doc /* Solldrehzahl einer Bürste. Richtung: BrushController → Bürste.
             * Aus Senderperspektive definiert; Empfänger nutzt ~BrushRotationSpeed. */
        out brushRotationSpeed :> ISQSpaceTime::rotationalFrequency;
    }

    interface def BrushRotationSpeedInterface {
        doc /* Verbindet den Drehzahlausgang des Bürstencontrollers mit einer Bürste. */
        end supplierPort : BrushRotationSpeed;
        end consumerPort : ~BrushRotationSpeed;

        flow supplierPort.brushRotationSpeed to consumerPort.brushRotationSpeed;
    }

    part def MainBrush {
        doc /* Hauptbürste unter dem Roboter: löst Schmutz vom Boden. */
        port rotationSpeedInputPort : ~BrushRotationSpeed;
    }

    part def SmallBrush {
        doc /* Seitenbürste: kehrt Schmutz aus Ecken und Kanten zur Hauptbürste. */
        port rotationSpeedInputPort : ~BrushRotationSpeed;
    }

    part def BrushController {
        doc /* Setzt die Bürstenstufe vom Controller in eine Solldrehzahl für die Bürsten um. */
        port brushRotationLevelInputPort : ~BrushRotationLevel;
        port rotationSpeedOutputPort : BrushRotationSpeed;

        attribute parMaxRPM :> ISQSpaceTime::rotationalFrequency;
    }

    part def BrushSystem {
        doc /* Bürstensystem aus Hauptbürste, zwei Seitenbürsten und Bürstencontroller. */

        // Außenport
        port brushRotationLevelInputPort : ~BrushRotationLevel;

        part mainBrush : MainBrush;
        part smallBrush : SmallBrush[2];
        part brushController : BrushController {
            // 10000 rpm sind eine übliche Bürstendrehzahl; rotationalFrequency ist in 1/s, daher 167
            attribute redefines parMaxRPM = 167;
        }

        // Delegation Außenport → Innenteil
        bind brushRotationLevelInputPort = brushController.brushRotationLevelInputPort;

        // Bürstencontroller → Bürsten
        interface : BrushRotationSpeedInterface connect
            supplierPort ::> brushController.rotationSpeedOutputPort to
            consumerPort ::> mainBrush.rotationSpeedInputPort;

        interface : BrushRotationSpeedInterface connect
            supplierPort ::> brushController.rotationSpeedOutputPort to
            consumerPort ::> smallBrush.rotationSpeedInputPort;
    }
}
