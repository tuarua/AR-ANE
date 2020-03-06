package views.examples {
import com.tuarua.ARKit;
import com.tuarua.arkit.Node;
import com.tuarua.arkit.RunOptions;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.camera.TrackingState;
import com.tuarua.arkit.camera.TrackingStateReason;
import com.tuarua.arkit.events.CameraTrackingEvent;
import com.tuarua.arkit.physics.PhysicsBody;
import com.tuarua.arkit.shapes.Model;

import flash.display.BitmapData;

import flash.geom.Vector3D;
import flash.utils.setTimeout;


public class PhysicsExample {
    private var arkit:ARKit;
    private var rocketNode:Node;

    public function PhysicsExample(arkit:ARKit) {
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
