package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.shapes.Model;

import flash.display.BitmapData;

import flash.geom.Vector3D;

public class DaeModelExample {
    private var arkit:ARANE;
    public function DaeModelExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.autoenablesDefaultLighting = false;
        arkit.view3D.showsStatistics = true;
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function addModel():void {
        var model:Model = new Model("objects/cherub/cherub.dae", "cherub", true);
        var node:Node = model.rootNode;

        if (node == null) {
            trace("no cherub");
            return;
        }

        arkit.view3D.scene.rootNode.addChildNode(node);
        node.position = new Vector3D(0, 0, -1.0); //r g b in iOS world origin
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
        arkit.view3D.dispose();
    }
}
}
