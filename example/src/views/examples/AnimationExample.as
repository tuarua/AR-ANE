package views.examples {
import com.tuarua.ARKit;
import com.tuarua.arkit.AntialiasingMode;
import com.tuarua.arkit.Node;
import com.tuarua.arkit.RunOptions;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.animation.Action;
import com.tuarua.arkit.camera.TrackingState;
import com.tuarua.arkit.camera.TrackingStateReason;
import com.tuarua.arkit.events.CameraTrackingEvent;
import com.tuarua.arkit.lights.Light;
import com.tuarua.arkit.shapes.Sphere;

import flash.display.BitmapData;

import flash.geom.Vector3D;

public class AnimationExample {
    private var arkit:ARKit;
    private var lightNode:Node;
    public function AnimationExample(arkit:ARKit) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
    }

    private function addModel():void {
        var sphere:Sphere = new Sphere(0.25);
        // .contents accepts string of file path, uint for color, or bitmapdata
        sphere.firstMaterial.diffuse.contents = "materials/globe.png"; //relative to main bundle

        var light:Light = new Light();
        lightNode = new Node();
        lightNode.position = new Vector3D(0, 0.1, 1.0);
        lightNode.light = light;
        arkit.view3D.scene.rootNode.addChildNode(lightNode);

        var node:Node = new Node(sphere);
        node.position = new Vector3D(0, 0.1, -1);

        arkit.view3D.scene.rootNode.addChildNode(node);

        var rotate:Action = new Action();
        rotate.rotateBy(0, 1, 0, 10); //TODO allow rotation on axis
        rotate.repeatForever();
        node.runAction(rotate);
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

    private function switchLight():void {
        if (lightNode && lightNode.light) {
            lightNode.position = new Vector3D(0, 1.0, 1.0);
            lightNode.light.intensity = 3000;
        }
    }

    public function dispose():void {
        arkit.removeEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.dispose();
    }
}
}
