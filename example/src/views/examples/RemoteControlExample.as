package views.examples {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.animation.Action;
import com.tuarua.arane.animation.Transaction;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.display.NativeButton;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.shapes.Model;

import flash.display.Bitmap;
import flash.events.MouseEvent;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

import starling.core.Starling;

public class RemoteControlExample {
    private var arkit:ARANE;
    private var helicopterNode:Node;

    [Embed(source="../../up-arrow.png")]
    private static const UpButton:Class;

    [Embed(source="../../down-arrow.png")]
    private static const DownButton:Class;

    private var upButtonBmp:Bitmap = new UpButton() as Bitmap;
    private var upButton:NativeButton = new NativeButton(upButtonBmp.bitmapData);

    private var downButtonBmp:Bitmap = new DownButton() as Bitmap;
    private var downButton:NativeButton = new NativeButton(downButtonBmp.bitmapData);

    public function RemoteControlExample(arkit:ARANE) {
        this.arkit = arkit;

        upButton.x = (Starling.current.stage.stageWidth / 2) - 187;
        downButton.x = (Starling.current.stage.stageWidth / 2) + 100;
        upButton.y = downButton.y = Starling.current.stage.stageHeight - 300;
        upButton.addEventListener(MouseEvent.CLICK, onUpClick);
        downButton.addEventListener(MouseEvent.CLICK, onDownClick);

    }

    private function onDownClick(event:MouseEvent):void {
        moveDroneUpDown(false);
    }

    private function onUpClick(event:MouseEvent):void {
        moveDroneUpDown();
    }

    public function run():void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.showsStatistics = true;
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);



    }

    private function addModel():void {
        var model:Model = new Model("objects/Drone.scn", "helicopter");
        helicopterNode = model.rootNode;

        if (helicopterNode) {
            var matrix:Matrix3D = new Matrix3D();
            matrix.appendRotation(-90, Vector3D.X_AXIS);
            helicopterNode.transform = matrix;
            helicopterNode.position = new Vector3D(helicopterNode.position.x, helicopterNode.position.y,
                    helicopterNode.position.z - 1);

            var blade1:Node = helicopterNode.childNode("Rotor_R_2");
            var blade2:Node = helicopterNode.childNode("Rotor_L_2");
            var rotorR:Node = blade1.childNode("Rotor_R");
            var rotorL:Node = blade2.childNode("Rotor_L");

            var bodyMaterial:Material = new Material();
            bodyMaterial.diffuse.contents = ColorARGB.BLACK;

            helicopterNode.geometry.materials = new <Material>[bodyMaterial];

            var bladeMaterial:Material = new Material();
            bladeMaterial.diffuse.contents = ColorARGB.DARK_GREY;
            var rotorMaterial:Material = new Material();
            rotorMaterial.diffuse.contents = ColorARGB.GREY;
            var bladeMaterials:Vector.<Material> = new <Material>[bladeMaterial];
            var rotorMaterials:Vector.<Material> = new <Material>[rotorMaterial];

            blade1.geometry.materials = bladeMaterials;
            blade2.geometry.materials = bladeMaterials;
            rotorL.geometry.materials = rotorMaterials;
            rotorR.geometry.materials = rotorMaterials;

            arkit.view3D.scene.rootNode.addChildNode(helicopterNode);

            var rotate:Action = new Action();
            rotate.rotateBy(0, 0, 200, 0.5);
            rotate.repeatForever();
            rotorL.runAction(rotate);
            rotorR.runAction(rotate);

        }
        arkit.addChild(upButton);
        arkit.addChild(downButton);

    }

    private function moveDroneUpDown(up:Boolean = true):void {
        if (!helicopterNode) return;
        Transaction.begin();
        Transaction.animationDuration = 1.0;
        var value:Number = helicopterNode.position.y;
        if (up) {
            value = value + 0.1;
        } else {
            value = value - 0.1;
        }

        trace("up",up);
        trace("value",value);

        helicopterNode.position = new Vector3D(helicopterNode.position.x, value, helicopterNode.position.z);
        Transaction.commit();
    }

    private function stopRotors():void {
        var blade1:Node = helicopterNode.childNode("Rotor_R_2");
        var rotorR:Node = blade1.childNode("Rotor_R");

        var blade2:Node = helicopterNode.childNode("Rotor_L_2");
        var rotorL:Node = blade2.childNode("Rotor_L");
        if (!rotorL || !rotorR) return;
        rotorL.removeAllActions();
        rotorR.removeAllActions();
    }

    private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
        switch (event.state) {
            case TrackingState.limited:
                switch (event.reason) {
                    case TrackingStateReason.initializing:
                        addModel();
                        break;
                }
                break;
        }
    }

    public function dispose():void {
        arkit.removeEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.removeChild(upButton);
        arkit.removeChild(downButton);
        arkit.view3D.dispose();
    }

}
}
