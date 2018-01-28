package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.lights.LightingModel;
import com.tuarua.arane.materials.WrapMode;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.touch.HitTestOptions;
import com.tuarua.arane.touch.HitTestResult;

import flash.geom.Vector3D;

public class PhotoBasedExample {
    private var arkit:ARANE;
    private var node:Node;

    public function PhotoBasedExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run():void {
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.debugOptions = [];
        arkit.view3D.showsStatistics = true;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
        arkit.view3D.autoenablesDefaultLighting = false;
        arkit.view3D.automaticallyUpdatesLighting = false;
        arkit.view3D.camera.wantsHDR = true;
        arkit.view3D.camera.exposureOffset = -1;
        arkit.view3D.camera.minimumExposure = -1;
        arkit.view3D.camera.maximumExposure = 3;

        arkit.view3D.scene.lightingEnvironment.contents = "environments/spherical.jpg";
        arkit.view3D.scene.lightingEnvironment.intensity = 2.0;

        arkit.view3D.init();
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

        var box:Box = new Box(0.15, 0.15, 0.15);
        box.firstMaterial.lightingModel = LightingModel.physicallyBased;
        box.firstMaterial.diffuse.contents = "materials/oakfloor2/oakfloor2-albedo.png";
        box.firstMaterial.diffuse.wrapT = box.firstMaterial.diffuse.wrapS = WrapMode.repeat;
        box.firstMaterial.normal.contents = "materials/oakfloor2/oakfloor2-normal.png";
        box.firstMaterial.normal.wrapT = box.firstMaterial.normal.wrapS = WrapMode.repeat;
        box.firstMaterial.roughness.contents = "materials/oakfloor2/oakfloor2-roughness.png";
        box.firstMaterial.roughness.wrapT = box.firstMaterial.roughness.wrapS = WrapMode.repeat;
        node = new Node(box);
        node.position = new Vector3D(0, 0, -0.5); //r g b in iOS world origin
        arkit.view3D.scene.rootNode.addChildNode(node);

    }

    private function onSceneTapped(event:TapEvent):void {
        if (event.location) {
            var hitTestResult:HitTestResult = arkit.view3D.hitTest(event.location, new HitTestOptions());
            if (hitTestResult) {
                if (hitTestResult.node.name == node.name) {
                    var box:Box = node.geometry as Box;
                    //not looking right

                    box.firstMaterial.diffuse.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-albedo.png";
                    box.firstMaterial.normal.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-normal.png";
                    box.firstMaterial.roughness.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-roughness.png";

                    box.firstMaterial.metalness.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-metal.png";
                    box.firstMaterial.metalness.wrapT = box.firstMaterial.metalness.wrapS = WrapMode.repeat;
                }
            }
        }
    }

    public function dispose():void {
        arkit.removeEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.dispose();
    }

}
}
