package views.examples {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.events.PlaneRemovedEvent;
import com.tuarua.arane.events.PlaneUpdatedEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.shapes.Pyramid;

public class FocusSquareExample {
    private var arkit:ARANE;

    public function FocusSquareExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.focusSquare.primaryColor = 0xFF3A85BF;
        arkit.view3D.focusSquare.fillColor = 0xFF469AD5;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.addEventListener(PlaneUpdatedEvent.PLANE_UPDATED, onPlaneUpdated);
        arkit.addEventListener(PlaneRemovedEvent.PLANE_REMOVED, onPlaneRemoved);
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        config.planeDetection = [PlaneDetection.horizontal];
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function onPlaneDetected(event:PlaneDetectedEvent):void {
        arkit.appendDebug("Plane Detected: " + event.node.name);
    }

    private function onPlaneUpdated(event:PlaneUpdatedEvent):void {

    }

    private function onPlaneRemoved(event:PlaneRemovedEvent):void {

    }

    private function onSceneTapped(event:TapEvent):void {
        var pyramid:Pyramid = new Pyramid(0.15, 0.15, 0.15);
        pyramid.firstMaterial.diffuse.contents = ColorARGB.DARK_GREY;
        var pyramidNode:Node = new Node(pyramid);
        pyramidNode.position = arkit.view3D.focusSquare.position;
        arkit.view3D.scene.rootNode.addChildNode(pyramidNode);
    }

    private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
        switch (event.state) {
            case TrackingState.limited:
                switch (event.reason) {
                    case TrackingStateReason.initializing:
                        arkit.view3D.focusSquare.enabled = true;
                        break;
                }
                break;
        }
    }

    public function dispose():void {
        arkit.removeEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.removeEventListener(PlaneUpdatedEvent.PLANE_UPDATED, onPlaneUpdated);
        arkit.removeEventListener(PlaneRemovedEvent.PLANE_REMOVED, onPlaneRemoved);
        arkit.removeEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.removeEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.dispose();
    }
}
}
