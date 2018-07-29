package views.examples {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.Node;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.animation.Action;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.LongPressEvent;
import com.tuarua.arane.events.PinchGestureEvent;
import com.tuarua.arane.events.SwipeGestureEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.touch.GesturePhase;
import com.tuarua.arane.touch.HitTestOptions;
import com.tuarua.arane.touch.HitTestResult;
import com.tuarua.arane.touch.SwipeGestureDirection;
import com.tuarua.deg2rad;

import flash.display.BitmapData;

import flash.geom.Vector3D;

public class GestureExample {
    private var arkit:ARANE;
    private var nodePinched:Node;
    private var node:Node;
    public function GestureExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.addEventListener(SwipeGestureEvent.LEFT, onSceneSwiped);
        arkit.addEventListener(SwipeGestureEvent.RIGHT, onSceneSwiped);
        arkit.addEventListener(SwipeGestureEvent.UP, onSceneSwiped);
        arkit.addEventListener(SwipeGestureEvent.DOWN, onSceneSwiped);

        arkit.addEventListener(PinchGestureEvent.PINCH, onScenePinched);
        arkit.addEventListener(LongPressEvent.LONG_PRESS, onSceneLongPress);
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function addModel():void {
        var redMat:Material = new Material();
        redMat.diffuse.contents = ColorARGB.RED;

        var greenMat:Material = new Material();
        greenMat.diffuse.contents = ColorARGB.GREEN;

        var blueMat:Material = new Material();
        blueMat.diffuse.contents = ColorARGB.BLUE;

        var yellowMat:Material = new Material();
        yellowMat.diffuse.contents = ColorARGB.YELLOW;

        var brownMat:Material = new Material();
        brownMat.diffuse.contents = ColorARGB.BROWN;

        var whiteMat:Material = new Material();
        whiteMat.diffuse.contents = ColorARGB.WHITE;

        var box:Box = new Box(0.1, 0.1, 0.1, 0.005);
        box.materials = new <Material>[redMat, greenMat, blueMat, yellowMat, brownMat, whiteMat];
        node = new Node(box);
        node.position = new Vector3D(0, 0, -0.25);
        node.eulerAngles = new Vector3D(deg2rad(45), 0, 0);
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    //noinspection JSMethodCanBeStatic
    private function onSceneSwiped(event:SwipeGestureEvent):void {
        trace(event);
        if (event.phase == GesturePhase.ENDED) {
            var rotate:Action = new Action();
            switch (event.direction) {
                case SwipeGestureDirection.UP:
                    rotate.rotateBy(deg2rad(-90), 0, 0, 0.3);
                    break;
                case SwipeGestureDirection.DOWN:
                    rotate.rotateBy(deg2rad(90), 0, 0, 0.3);
                    break;
                case SwipeGestureDirection.LEFT:
                    rotate.rotateBy(0, deg2rad(-90), 0, 0.3);
                    break;
                case SwipeGestureDirection.RIGHT:
                    rotate.rotateBy(0, deg2rad(90), 0, 0.3);
                    break;
            }
            node.runAction(rotate);
        }
    }

    //noinspection JSMethodCanBeStatic
    private function onSceneLongPress(event:LongPressEvent):void {
        if (event.phase == GesturePhase.ENDED) {
            trace("long press has ended");
        }
    }

    private function onScenePinched(event:PinchGestureEvent):void {
        if (event.phase == GesturePhase.BEGAN) {
            var hitTestResult:HitTestResult = arkit.view3D.hitTest(event.location);
            if (hitTestResult && hitTestResult.node) {
                nodePinched = hitTestResult.node;
            }
        } else if (event.phase == GesturePhase.ENDED) {
            nodePinched = null;
        } else {
            if (nodePinched) {
                nodePinched.scale = new Vector3D(event.scale, event.scale, event.scale);
            }
        }
    }


    private function onSceneTapped(event:TapEvent):void {
        if (event.location) {
            // tap object to remove.
            var hitTestResult:HitTestResult = arkit.view3D.hitTest(event.location, new HitTestOptions());
            trace("hitTestResult", hitTestResult);
            if (hitTestResult) {
                trace("hitTestResult.faceIndex", hitTestResult.faceIndex);
                trace("hitTestResult.geometryIndex", hitTestResult.geometryIndex);
                trace("hitTestResult.worldCoordinates", hitTestResult.worldCoordinates);
                trace("hitTestResult.node.name", hitTestResult.node.name);
                trace("hitTestResult.node.isAdded", hitTestResult.node.isAdded);
                trace("hitTestResult.node.parentName", hitTestResult.node.parentName);
                //hitTestResult.node.removeFromParentNode();
            }

        }
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
        arkit.removeEventListener(SwipeGestureEvent.UP, onSceneSwiped);
        arkit.removeEventListener(PinchGestureEvent.PINCH, onScenePinched);
        arkit.removeEventListener(LongPressEvent.LONG_PRESS, onSceneLongPress);
        arkit.view3D.dispose();
    }

}
}
