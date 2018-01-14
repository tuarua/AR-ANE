package {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.Anchor;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Light;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.animation.Action;
import com.tuarua.arane.animation.Transaction;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.display.NativeButton;
import com.tuarua.arane.display.NativeImage;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.physics.PhysicsBody;
import com.tuarua.arane.physics.PhysicsBodyType;
import com.tuarua.arane.physics.PhysicsShape;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.shapes.Capsule;
import com.tuarua.arane.shapes.Cone;
import com.tuarua.arane.shapes.Model;
import com.tuarua.arane.shapes.Plane;
import com.tuarua.arane.shapes.Pyramid;
import com.tuarua.arane.shapes.Shape;
import com.tuarua.arane.shapes.Sphere;
import com.tuarua.arane.touch.ARHitTestResult;
import com.tuarua.arane.touch.HitTestOptions;
import com.tuarua.arane.touch.HitTestResult;
import com.tuarua.arane.touch.HitTestResultType;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.system.Capabilities;
import flash.utils.setTimeout;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
import starling.utils.deg2rad;

public class StarlingRoot extends Sprite {
    private var gridMaterialFile:File = File.applicationDirectory.resolvePath("materials/grid.png");
    private var ql:Quad = new Quad(100, 50, 0xFFF000);
    private var qr:Quad = new Quad(100, 50, 0x0000ff);
    private var qbl:Quad = new Quad(100, 50, 0xFF0000);
    private var qbr:Quad = new Quad(100, 50, 0x00F055);
    private var btn:Quad = new Quad(200, 200, 0x00F055);

    [Embed(source="adobeair.png")]
    private static const TestImage:Class;

    [Embed(source="close.png")]
    private static const TestButton:Class;

    private var arkit:ARANE;
    private var node:Node;
    private var lightNode:Node;
    private var helicopterNode:Node;

    public function StarlingRoot() {

    }

    public function start(assets:AssetManager):void {
        qbr.x = qr.x = stage.stageWidth - 100;
        qbl.y = qbr.y = stage.stageHeight - 50;

        addChild(ql);
        addChild(qr);
        addChild(qbl);
        addChild(qbr);


        btn.x = 200;
        btn.y = 100;

        btn.addEventListener(TouchEvent.TOUCH, onClick);
        addChild(btn);

        trace(Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);

    }

    private function onClick(event:TouchEvent):void {

        var touch:Touch = event.getTouch(btn);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            ARANE.displayLogging = true;
            arkit = ARANE.arkit;
            arkit.addEventListener(PlaneDetectedEvent.ON_PLANE_DETECTED, onPlaneDetected);
            arkit.addEventListener(CameraTrackingEvent.ON_STATE_CHANGE, onCameraTrackingStateChange);
            arkit.addEventListener(TapEvent.ON_SCENE3D_TAP, onSceneTapped);
            trace("arkit.isSupported", arkit.isSupported);
            if (!arkit.isSupported) {
                trace("ARKIT is NOT Supported on this device");
                return;
            }

            arkit.view3D.showsStatistics = false;
            arkit.view3D.automaticallyUpdatesLighting = true;
            arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;
            arkit.view3D.init();
            var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
            config.planeDetection = PlaneDetection.horizontal;
            arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

            setTimeout(function ():void {
                arkit.appendDebug("after 2 seconds add sphere");
                addSphere();

//                arkit.appendDebug("after 2 seconds add model from .dae");
//                addModel();

//                arkit.appendDebug("after 2 seconds add model from .scn");
//                addSCNModel();


//                arkit.appendDebug("after 2 seconds add shape from SVG");
//                addShapeFromSVG();

            }, 2000);

            setTimeout(function ():void {
                arkit.appendDebug("after 5 seconds enable debug view of AR Scene");
                enableDebugView();
            }, 5000);

//            setTimeout(function ():void {
//                arkit.appendDebug("after 7 seconds add an anchor to the session");
//                addAnchor();
//            }, 7000);

            setTimeout(function ():void {
                arkit.appendDebug("add image from AIR");
                addButtonFromAIR();
            }, 1000);

        }
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
                        break;
                    case TrackingStateReason.insufficientFeatures:
                        arkit.appendDebug("Tracking:limited - insufficient Features");
                        break;
                }
                break;
        }
    }

    private function onSceneTapped(event:TapEvent):void {
        trace(event);
        trace(event.location);

        if (event.location) {

            // look for planes
            var arHitTestResult:ARHitTestResult = arkit.view3D.hitTest3D(event.location, [HitTestResultType.existingPlaneUsingExtent]);
            if (arHitTestResult) {
                trace(arHitTestResult.type);
                trace(arHitTestResult.anchor);
                trace(arHitTestResult.distance);
                trace("localTransform", arHitTestResult.localTransform.rawData);
                trace("worldTransform", arHitTestResult.worldTransform.rawData);
                var box:Box = new Box(0.1, 0.1, 0.1);
                box.firstMaterial.diffuse.contents = ColorARGB.ORANGE;
                var boxNode:Node = new Node(box);

                //https://github.com/appcoda/ARKitPhysics/blob/master/ARKitPhysics/ViewController.swift

                var boxShape:PhysicsShape = new PhysicsShape(box);
                var physicsBody:PhysicsBody = new PhysicsBody(PhysicsBodyType.dynamic, boxShape);
                physicsBody.allowsResting = true;

                boxNode.physicsBody = physicsBody;
                boxNode.position = new Vector3D(arHitTestResult.worldTransform.position.x,
                        arHitTestResult.worldTransform.position.y + 0.5,
                        arHitTestResult.worldTransform.position.z);

                arkit.view3D.scene.rootNode.addChildNode(boxNode);
                return;
            }

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
                hitTestResult.node.removeFromParentNode();
            }

        }
    }

    private function addAnchor():void {
        var matrix:Matrix3D = new Matrix3D();
        matrix.position = new Vector3D(0, 0.15, 0);
        var anchor:Anchor = new Anchor();
        anchor.transform = matrix;
        trace("anchor id before adding", anchor.id);
        arkit.view3D.session.add(anchor);
        trace("anchor id after adding", anchor.id);
    }

    private function onPlaneDetected(event:PlaneDetectedEvent):void {
        arkit.appendDebug(event.toString());

        // create a plane and add to show we have detected a plane
        var planeAnchor:PlaneAnchor = event.anchor;
        var node:Node = event.node;


        //plane is not quite flush with floor
        var plane:Box = new Box(planeAnchor.extent.x, planeAnchor.extent.z, 0);
        if (gridMaterialFile.exists) {
            // .contents accepts string of file path, uint for color, or bitmapdata
            plane.firstMaterial.diffuse.contents = gridMaterialFile.nativePath;
        }

        // https://www.appcoda.com/arkit-physics-scenekit/

        var planeNode:Node = new Node(plane);
        planeNode.position = new Vector3D(planeAnchor.center.x, 0, planeAnchor.center.z)

        var boxShape:PhysicsShape = new PhysicsShape(plane);
        planeNode.physicsBody = new PhysicsBody(PhysicsBodyType.static, boxShape);
        planeNode.eulerAngles = new Vector3D(-Math.PI / 2, 0, 0);
        node.addChildNode(planeNode);

        //we may wish to remove old planes

    }

    private function addImageFromAIR():void {
        var bmp:Bitmap = new TestImage() as Bitmap;
        var image:NativeImage = new NativeImage(bmp.bitmapData);
        arkit.addChild(image);
    }

    private function addButtonFromAIR():void {
        var bmp:Bitmap = new TestButton() as Bitmap;
        var button:NativeButton = new NativeButton(bmp.bitmapData);
        button.addEventListener(MouseEvent.CLICK, onNativeButtonClick);
        arkit.addChild(button);
    }

    private function onNativeButtonClick(event:MouseEvent):void {
        trace(event);

        arkit.view3D.showsStatistics = true;

        moveDroneUpDown();

        /* //arkit.view3D.dispose();


         node.alpha = 0.5;
         //node.position = new Vector3D(0, 0.15, 0);

         //var sphere:Sphere = node.geometry as Sphere;
         //sphere.radius = 0.05;

         if(node.childNodes.length > 0){
             var childNode:Node = node.childNodes[0];
             var box:Box = childNode.geometry as Box;
             if (box) {
                 box.width = 0.15;
             }
         }
 */


        // switchSphereMaterial();
        // removeBoxFromEarth();
        // switchLight();

    }

    private function removeBoxFromEarth():void {
        if (node && node.childNodes.length > 0) {
            var boxNode:Node = node.childNodes[0];
            if (boxNode) {
                boxNode.removeFromParentNode();
            }
        }
    }

    private function switchLight():void {
        if (lightNode && lightNode.light) {
            lightNode.position = new Vector3D(0, 1.0, 1.0);
            lightNode.light.intensity = 3000;
        }
    }

    private function switchSphereMaterial():void {
        if (node) {
            var sphere:Sphere = node.geometry as Sphere;
            sphere.firstMaterial.transparency = 0.8;
            sphere.firstMaterial.diffuse.contents = ColorARGB.CYAN;
        }
    }

    private function enableDebugView():void {
        arkit.view3D.debugOptions = [DebugOptions.showWorldOrigin, DebugOptions.showFeaturePoints];
    }

    private function addModel():void {
        // objects folder must be packaged in ipa root
        arkit.view3D.autoenablesDefaultLighting = false;
        var model:Model = new Model("objects/cherub/cherub.dae", "cherub");
        var node:Node = model.rootNode;

        if (node == null) {
            trace("no cherub");
            return;
        }

        arkit.view3D.scene.rootNode.addChildNode(node);
        node.position = new Vector3D(0, 0, -1.0); //r g b in iOS world origin

        //N.B. - this dae doesn't like transforms applied.
        //It is recommended to use scn
    }

    private function addSCNModel():void {
        var model:Model = new Model("objects/Drone.scn", "helicopter");
        helicopterNode = model.rootNode;
        trace("helicopterNode.isAdded", helicopterNode.isAdded);

        if (helicopterNode) {
            var matrix:Matrix3D = new Matrix3D();
            matrix.appendRotation(-90, Vector3D.X_AXIS);
            helicopterNode.transform = matrix;
            helicopterNode.position = new Vector3D(helicopterNode.position.x, helicopterNode.position.y,
                    helicopterNode.position.z - 1);

            var blade1:Node = helicopterNode.childNode("Rotor_R_2");
            var blade2:Node = helicopterNode.childNode("Rotor_L_2");
            var rotorR:Node = blade1.childNode("Rotor_R");
            var rotorL:Node = blade2.childNode("Rotor_L");

            var bodyMaterial:Material = new Material();
            bodyMaterial.diffuse.contents = ColorARGB.BLACK;

            helicopterNode.geometry.materials = new <Material>[bodyMaterial];

            var bladeMaterial:Material = new Material();
            bladeMaterial.diffuse.contents = ColorARGB.DARK_GREY;
            var rotorMaterial:Material = new Material();
            rotorMaterial.diffuse.contents = ColorARGB.GREY;
            var bladeMaterials:Vector.<Material> = new <Material>[bladeMaterial];
            var rotorMaterials:Vector.<Material> = new <Material>[rotorMaterial];

            blade1.geometry.materials = bladeMaterials;
            blade2.geometry.materials = bladeMaterials;
            rotorL.geometry.materials = rotorMaterials;
            rotorR.geometry.materials = rotorMaterials;

            arkit.view3D.scene.rootNode.addChildNode(helicopterNode);

            var rotate:Action = new Action();
            rotate.rotateBy(0, 0, 200, 0.5);
            rotate.repeatForever();
            rotorL.runAction(rotate);
            rotorR.runAction(rotate);

        }
    }

    private function moveDroneUpDown(up:Boolean = true):void {
        if (!helicopterNode) return;
        Transaction.begin();
        Transaction.animationDuration = 1.0;
        var value:Number = helicopterNode.position.y;
        if (up) {
            value = value + 0.1;
        } else {
            value = value - 0.1;
        }
        helicopterNode.position = new Vector3D(helicopterNode.position.x, value, helicopterNode.position.z);
        Transaction.commit();
    }

    private function stopRotors():void {
        var blade1:Node = helicopterNode.childNode("Rotor_R_2");
        var rotorR:Node = blade1.childNode("Rotor_R");

        var blade2:Node = helicopterNode.childNode("Rotor_L_2");
        var rotorL:Node = blade2.childNode("Rotor_L");
        if (!rotorL || !rotorR) return;
        rotorL.removeAllActions();
        rotorR.removeAllActions();
    }

    private function addSphere():void {
        arkit.view3D.autoenablesDefaultLighting = true;
        var sphere:Sphere = new Sphere(0.025);
        var globeMaterialFile:File = File.applicationDirectory.resolvePath("materials/globe.png");
        if (globeMaterialFile.exists) {
            // .contents accepts string of file path, uint for color, or bitmapdata
            sphere.firstMaterial.diffuse.contents = globeMaterialFile.nativePath;
        }

        var light:Light = new Light();
        lightNode = new Node();
        lightNode.position = new Vector3D(0, 0.1, 1.0);
        lightNode.light = light;
        arkit.view3D.scene.rootNode.addChildNode(lightNode);

        node = new Node(sphere);
        node.position = new Vector3D(0, 0.1, 0); //r g b in iOS world origin

        var box:Box = new Box(0.1, 0.02, 0.02, 0.001);

        //TODO crashes
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

        box.materials = new <Material>[redMat, greenMat, blueMat, yellowMat, brownMat, whiteMat];

        var childNode:Node = new Node(box);
        childNode.eulerAngles = new Vector3D(deg2rad(45), 0, 0);
        node.addChildNode(childNode);

        arkit.view3D.scene.rootNode.addChildNode(node);

        var rotate:Action = new Action();
        rotate.rotateBy(0, 1, 0, 10); //TODO allow rotation on axis
        rotate.repeatForever();
        node.runAction(rotate);
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

    private function addPyramid():void {
        var pyramid:Pyramid = new Pyramid(0.1, 0.1, 0.1);
        var node:Node = new Node(pyramid);
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    private function addCapsule():void {
        var capsule:Capsule = new Capsule(0.05, 0.2);
        var node:Node = new Node(capsule);
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    private function addCone():void {
        var cone:Cone = new Cone(0, 0.05, 0.1);
        var node:Node = new Node(cone);
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

}
}