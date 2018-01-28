package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.animation.Action;
import com.tuarua.arane.lights.Light;
import com.tuarua.arane.shapes.Sphere;

import flash.geom.Vector3D;

public class AnimationExample {
    private var arkit:ARANE;
    private var lightNode:Node;
    public function AnimationExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.view3D.debugOptions = [];
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.showsStatistics = false;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

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


    private function switchLight():void {
        if (lightNode && lightNode.light) {
            lightNode.position = new Vector3D(0, 1.0, 1.0);
            lightNode.light.intensity = 3000;
        }
    }

    public function dispose():void {
        arkit.view3D.dispose();
    }
}
}
