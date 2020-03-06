package views.examples {
import com.tuarua.ARKit;
import com.tuarua.arkit.AntialiasingMode;
import com.tuarua.arkit.Node;
import com.tuarua.arkit.RunOptions;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.camera.TrackingState;
import com.tuarua.arkit.camera.TrackingStateReason;
import com.tuarua.arkit.events.CameraTrackingEvent;
import com.tuarua.arkit.events.TapEvent;
import com.tuarua.arkit.lights.LightingModel;
import com.tuarua.arkit.materials.WrapMode;
import com.tuarua.arkit.shapes.Box;
import com.tuarua.arkit.touch.HitTestOptions;
import com.tuarua.arkit.touch.HitTestResult;

import flash.display.BitmapData;

import flash.geom.Vector3D;

public class PhotoBasedExample {
    private var arkit:ARKit;
    private var node:Node;

    public function PhotoBasedExample(arkit:ARKit) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.showsStatistics = true;

        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
        arkit.view3D.automaticallyUpdatesLighting = false;

        arkit.view3D.camera.wantsHDR = true;
        arkit.view3D.camera.exposureOffset = -1;
        arkit.view3D.camera.minimumExposure = -1;
        arkit.view3D.camera.maximumExposure = 3;

        arkit.view3D.scene.lightingEnvironment.contents = "environments/spherical.jpg";
        arkit.view3D.scene.lightingEnvironment.intensity = 2.0;

        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
        
    }

    private function onSceneTapped(event:TapEvent):void {
        if (event.location) {
            var hitTestResult:HitTestResult = arkit.view3D.hitTest(event.location, new HitTestOptions());
            if (hitTestResult) {
                if (hitTestResult.node.name == node.name) {
                    var box:Box = node.geometry as Box;
                    box.firstMaterial.diffuse.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-albedo.png";
                    box.firstMaterial.normal.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-normal.png";
                    box.firstMaterial.roughness.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-roughness.png";
                    box.firstMaterial.metalness.contents = "materials/bamboo-wood-semigloss/bamboo-wood-semigloss-metal.png";
                    box.firstMaterial.metalness.wrapT = box.firstMaterial.metalness.wrapS = WrapMode.repeat;
                }
            }
        }
    }

    private function addModel():void {
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
        arkit.removeEventListener(TapEvent.TAP, onSceneTapped);
        arkit.view3D.dispose();
    }

}
}
