package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.physics.PhysicsBody;
import com.tuarua.arane.shapes.Model;

import flash.display.BitmapData;

import flash.geom.Vector3D;
import flash.utils.setTimeout;


public class PhysicsExample {
    private var arkit:ARANE;
    private var rocketNode:Node;

    public function PhysicsExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
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

    private function addModel():void {
        var model:Model = new Model("objects/rocketship.scn", "rocketship", true);
        rocketNode = model.rootNode;
        if (!rocketNode) return;

        var physicsBody:PhysicsBody = PhysicsBody.dynamic();
        physicsBody.isAffectedByGravity = false;
        physicsBody.damping = 0;
        rocketNode.physicsBody = physicsBody;
        arkit.view3D.scene.rootNode.addChildNode(rocketNode);
        rocketNode.position = new Vector3D(0, -1, -4.0);

        setTimeout(function ():void {
            takeOff();
        }, 5000);
    }

    private function takeOff():void {
        var direction:Vector3D = new Vector3D(0, 1, 0);
        rocketNode.physicsBody.applyForce(direction, true);
    }

    public function dispose():void {
        arkit.removeEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.dispose();
    }
}
}
