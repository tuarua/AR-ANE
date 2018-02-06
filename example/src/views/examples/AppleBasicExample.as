package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.shapes.Model;

public class AppleBasicExample {
    private var arkit:ARANE;

    public function AppleBasicExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.view3D.debugOptions = [];
        arkit.view3D.showsStatistics = true;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
    }

    private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
        switch (event.state) {
            case TrackingState.limited:
                switch (event.reason) {
                    case TrackingStateReason.initializing:
                        var model:Model = new Model("art.scnassets/ship.scn");
                        var shipNode:Node = model.rootNode;
                        if (!shipNode) break;
                        arkit.view3D.scene.rootNode.addChildNode(shipNode);
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
