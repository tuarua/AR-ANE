package views.examples {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.shapes.Capsule;
import com.tuarua.arane.shapes.Pyramid;
import com.tuarua.arane.shapes.Shape;
import com.tuarua.arane.shapes.Sphere;
import com.tuarua.deg2rad;

import flash.display.BitmapData;
import flash.filesystem.File;
import flash.geom.Vector3D;

public class ShapesExample {
    private var arkit:ARANE;

    public function ShapesExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.debugOptions = [DebugOptions.showWorldOrigin];
        arkit.view3D.showsStatistics = true;
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;

        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function addShapeFromSVG():void {
        var heartShapeFile:File = File.applicationDirectory.resolvePath("objects/heart.svg");
        if (!heartShapeFile.exists) return;

        var shape:Shape = new Shape(heartShapeFile.nativePath);
        shape.extrusionDepth = 10.0;
        shape.chamferRadius = 1.0;
        shape.firstMaterial.diffuse.contents = ColorARGB.RED;
        var node:Node = new Node(shape);
        node.position = new Vector3D(0, 0, -1); //r g b in iOS world origin

        node.scale = new Vector3D(0.01, 0.01, 0.01);
        node.eulerAngles = new Vector3D(deg2rad(180), 0, 0);

        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    private function addModel():void {
        var sphere:Sphere = new Sphere(0.025);
        sphere.firstMaterial.diffuse.contents = ColorARGB.RED;
        var sphereNode:Node = new Node(sphere);
        sphereNode.position = new Vector3D(0, 0, -0.25); //r g b in iOS world origin
        arkit.view3D.scene.rootNode.addChildNode(sphereNode);

        var pyramid:Pyramid = new Pyramid(0.1, 0.1, 0.1);
        pyramid.firstMaterial.diffuse.contents = ColorARGB.YELLOW;
        var pyramidNode:Node = new Node(pyramid);
        pyramidNode.position = new Vector3D(0.2, 0, -0.25);
        arkit.view3D.scene.rootNode.addChildNode(pyramidNode);

        var capsule:Capsule = new Capsule(0.025, 0.1);
        capsule.firstMaterial.diffuse.contents = ColorARGB.GREEN;
        var capsuleNode:Node = new Node(capsule);
        capsuleNode.position = new Vector3D(-0.2, 0, -0.25);
        arkit.view3D.scene.rootNode.addChildNode(capsuleNode);
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
