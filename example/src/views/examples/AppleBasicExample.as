package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.coaching.CoachingOverlayView;
import com.tuarua.arane.coaching.CoachingOverlayViewGoal;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.shapes.Model;

import flash.display.BitmapData;

public class AppleBasicExample {
    private var arkit:ARANE;

    public function AppleBasicExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.showsStatistics = true;
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
        if (arkit.iosVersion >= 13.0) {
            var coaching:CoachingOverlayView = new CoachingOverlayView(CoachingOverlayViewGoal.horizontalPlane);
            coaching.setActive(true, true);
        }
    }

    private function addModel():void {
        var model:Model = new Model("art.scnassets/ship.scn");
        var shipNode:Node = model.rootNode;
        if (!shipNode) return;
        arkit.view3D.scene.rootNode.addChildNode(shipNode);
    }

    private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
        switch (event.state) {
            case TrackingState.notAvailable:
                arkit.appendDebug("Tracking:Not available");
                break;
            case TrackingState.normal:
                arkit.appendDebug("Tracking:normal");
                break;
            case TrackingState.limited:
                switch (event.reason) {
                    case TrackingStateReason.excessiveMotion:
                        arkit.appendDebug("Tracking:limited - excessive Motion");
                        break;
                    case TrackingStateReason.initializing:
                        arkit.appendDebug("Tracking:limited - initializing");
                        addModel();
                        break;
                    case TrackingStateReason.insufficientFeatures:
                        arkit.appendDebug("Tracking:limited - insufficient Features");
                        break;
                    case TrackingStateReason.relocalizing:
                        arkit.appendDebug("Tracking:limited - relocalizing");
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
