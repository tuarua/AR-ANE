package views.examples {
import com.tuarua.ARKit;
import com.tuarua.ColorARGB;
import com.tuarua.arkit.Node;
import com.tuarua.arkit.PlaneDetection;
import com.tuarua.arkit.RunOptions;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.camera.TrackingState;
import com.tuarua.arkit.camera.TrackingStateReason;
import com.tuarua.arkit.events.CameraTrackingEvent;
import com.tuarua.arkit.events.PlaneDetectedEvent;
import com.tuarua.arkit.events.PlaneRemovedEvent;
import com.tuarua.arkit.events.PlaneUpdatedEvent;
import com.tuarua.arkit.events.TapEvent;
import com.tuarua.arkit.shapes.Pyramid;

import flash.display.BitmapData;

public class FocusSquareExample {
    private var arkit:ARKit;

    public function FocusSquareExample(arkit:ARKit) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.focusSquare.primaryColor = 0xFF3A85BF;
        arkit.view3D.focusSquare.fillColor = 0xFF469AD5;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.addEventListener(PlaneUpdatedEvent.PLANE_UPDATED, onPlaneUpdated);
        arkit.addEventListener(PlaneRemovedEvent.PLANE_REMOVED, onPlaneRemoved);
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.init(null, mask);
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
