package {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.Anchor;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.DebugOptions;
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
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.LongPressEvent;
import com.tuarua.arane.events.PhysicsEvent;
import com.tuarua.arane.events.PinchGestureEvent;
import com.tuarua.arane.events.SwipeGestureEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.lights.Light;
import com.tuarua.arane.lights.LightingModel;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.materials.WrapMode;
import com.tuarua.arane.permissions.PermissionEvent;
import com.tuarua.arane.permissions.PermissionStatus;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.shapes.Model;
import com.tuarua.arane.shapes.Shape;
import com.tuarua.arane.shapes.Sphere;
import com.tuarua.arane.touch.ARHitTestResult;
import com.tuarua.arane.touch.GesturePhase;
import com.tuarua.arane.touch.HitTestOptions;
import com.tuarua.arane.touch.HitTestResult;
import com.tuarua.arane.touch.HitTestResultType;
import com.tuarua.arane.touch.SwipeGestureDirection;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
import starling.utils.deg2rad;

import views.SimpleButton;
import views.examples.AnimationExample;
import views.examples.AppleBasicExample;
import views.examples.GestureExample;
import views.examples.PhotoBasedExample;
import views.examples.PhysicsExample;
import views.examples.PlaneDetectionExample;
import views.examples.ShapesExample;

public class StarlingRoot extends Sprite {
    [Embed(source="adobeair.png")]
    private static const TestImage:Class;

    [Embed(source="close.png")]
    private static const CloseButton:Class;

    private var closeButtonBmp:Bitmap = new CloseButton() as Bitmap;
    private var closeButton:NativeButton = new NativeButton(closeButtonBmp.bitmapData);

    private var btnBasic:SimpleButton = new SimpleButton("Apple Basic Sample");
    private var btnShapes:SimpleButton = new SimpleButton("Shapes");
    private var btnAnimation:SimpleButton = new SimpleButton("Animation");
    private var btnPhysics:SimpleButton = new SimpleButton("Physics");
    private var btnPlaneDetection:SimpleButton = new SimpleButton("Plane Detection");


    private var btnGestures:SimpleButton = new SimpleButton("Gestures");
    private var btnPBR:SimpleButton = new SimpleButton("Photo Based Rendering");
    private var btnModel:SimpleButton = new SimpleButton("Models from .scn");
    private var btnModelDAE:SimpleButton = new SimpleButton("Models from .dae");

    private var arkit:ARANE;
    private var node:Node;
    private var helicopterNode:Node;


    private var basicExample:AppleBasicExample;
    private var shapesExample:ShapesExample;
    private var animationExample:AnimationExample;
    private var physicsExample:PhysicsExample;
    private var planeDetectionExample:PlaneDetectionExample;
    private var gestureExample:GestureExample;
    private var photoBasedExample:PhotoBasedExample;

    private var selectedExample:uint = 0;


    public function StarlingRoot() {
        closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
    }


    public function start(assets:AssetManager):void {

        arkit = ARANE.arkit;
        if (!arkit.isSupported) {
            trace("ARKIT is NOT Supported on this device");
            return;
        }
        ARANE.displayLogging = true;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(PermissionEvent.STATUS_CHANGED, onPermissionsStatus);
        arkit.requestPermissions();


    }

    private function onPermissionsStatus(event:PermissionEvent):void {
        if (event.status == PermissionStatus.ALLOWED) {
            initMenu();
        } else if (event.status == PermissionStatus.NOT_DETERMINED) {
        } else {
            trace("Allow camera for ARKit usuage");
        }
    }

    private function initMenu():void {
        basicExample = new AppleBasicExample(arkit);
        shapesExample = new ShapesExample(arkit);
        animationExample = new AnimationExample(arkit);
        physicsExample = new PhysicsExample(arkit);
        planeDetectionExample = new PlaneDetectionExample(arkit);
        gestureExample = new GestureExample(arkit);
        photoBasedExample = new PhotoBasedExample(arkit);

        btnPBR.x = btnGestures.x = btnPlaneDetection.x = btnPhysics.x = btnAnimation.x = btnShapes.x =
                btnBasic.x = (stage.stageWidth - 200) * 0.5;
        btnBasic.y = 100;
        btnShapes.y = 180;
        btnAnimation.y = 260;
        btnPhysics.y = 340;
        btnPlaneDetection.y = 420;
        btnGestures.y = 500;
        btnPBR.y = 580;

        btnBasic.addEventListener(TouchEvent.TOUCH, onBasicClick);
        btnShapes.addEventListener(TouchEvent.TOUCH, onShapesClick);
        btnAnimation.addEventListener(TouchEvent.TOUCH, onAnimationClick);
        btnPhysics.addEventListener(TouchEvent.TOUCH, onPhysicsClick);
        btnPlaneDetection.addEventListener(TouchEvent.TOUCH, onPlaneDetectionClick);
        btnGestures.addEventListener(TouchEvent.TOUCH, onGesturesClick);
        btnPBR.addEventListener(TouchEvent.TOUCH, onPhotoBasedClick);

        addChild(btnBasic);
        addChild(btnShapes);
        addChild(btnAnimation);
        addChild(btnPhysics);
        addChild(btnPlaneDetection);
        addChild(btnGestures);
        addChild(btnPBR);

    }

    private function onPhotoBasedClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPBR);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 6;
            photoBasedExample.run();
            addCloseButton();
        }
    }

    private function onGesturesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGestures);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 5;
            gestureExample.run();
            addCloseButton();
        }
    }

    private function onPlaneDetectionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPlaneDetection);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 4;
            planeDetectionExample.run();
            addCloseButton();
        }
    }

    private function onPhysicsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPhysics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 3;
            physicsExample.run();
            addCloseButton();
        }
    }


    private function onBasicClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBasic);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 0;
            basicExample.run();
            addCloseButton();
        }
    }

    private function onShapesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShapes);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 1;
            shapesExample.run();
            addCloseButton();
        }
    }

    private function onAnimationClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnimation);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 2;
            animationExample.run();
            addCloseButton();
        }
    }

    private function addCloseButton():void {
        arkit.addChild(closeButton);
    }

    private function onCloseClick(event:MouseEvent):void {
        switch (selectedExample) {
            case 0:
                basicExample.dispose();
                break;
            case 1:
                shapesExample.dispose();
                break;
            case 2:
                animationExample.dispose();
                break;
            case 3:
                physicsExample.dispose();
                break;
            case 4:
                planeDetectionExample.dispose();
                break;
            case 5:
                gestureExample.dispose();
                break;
            case 6:
                photoBasedExample.dispose();
                break;
        }


        arkit.removeChild(closeButton);
    }


    private function initARView():void {

        arkit.addEventListener(PhysicsEvent.CONTACT_DID_BEGIN, onPhysicsContactBegin);

        trace("arkit.isSupported", arkit.isSupported);
        if (!arkit.isSupported) {
            trace("ARKIT is NOT Supported on this device");
            return;
        }

        Starling.current.stop(true); //suspend Starling when we go to ARKit mode

        arkit.view3D.showsStatistics = false;
        arkit.view3D.autoenablesDefaultLighting = true; //set to false for PBR test
        arkit.view3D.automaticallyUpdatesLighting = true;
        arkit.view3D.antialiasingMode = AntialiasingMode.multisampling4X;



        arkit.view3D.init();


        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        config.planeDetection = PlaneDetection.horizontal;
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

        setTimeout(function ():void {

            //arkit.appendDebug("after 2 seconds add Photo based rendering");
            //addPhotoBasedRendering();

            arkit.appendDebug("after 2 seconds add sphere");
            addSphere();

//                arkit.appendDebug("after 2 seconds add model from .dae");
//                addModel();

//                arkit.appendDebug("after 2 seconds add model from .scn");
//                addSCNModel();

//                arkit.appendDebug("after 2 seconds add rocket from .scn");
//                addRocket();


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


    }

    //noinspection JSMethodCanBeStatic
    private function onPhysicsContactBegin(event:PhysicsEvent):void {
        trace("contact between", event.contact.nodeNameA, "and", event.contact.nodeNameB);
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


    private function addAnchor():void {
        var matrix:Matrix3D = new Matrix3D();
        matrix.position = new Vector3D(0, 0.15, 0);
        var anchor:Anchor = new Anchor();
        anchor.transform = matrix;
        trace("anchor id before adding", anchor.id);
        arkit.view3D.session.add(anchor);
        trace("anchor id after adding", anchor.id);
    }


    private function onNativeButtonClick(event:MouseEvent):void {
        trace(event);

        arkit.view3D.showsStatistics = true;

        moveDroneUpDown();

        // arkit.view3D.dispose();
        // switchSphereMaterial();
        // removeBoxFromEarth();
        // switchLight();

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
        var model:Model = new Model("objects/cherub/cherub.dae", "cherub", true);
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

        // .contents accepts string of file path, uint for color, or bitmapdata
        sphere.firstMaterial.diffuse.contents = "materials/globe.png"; //relative to main bundle

        var light:Light = new Light();
        var lightNode:com.tuarua.arane.Node = new Node();
        lightNode.position = new Vector3D(0, 0.1, 1.0);
        lightNode.light = light;
        arkit.view3D.scene.rootNode.addChildNode(lightNode);

        node = new Node(sphere);
        node.position = new Vector3D(0, 0.1, 0); //r g b in iOS world origin
        var box:Box = new Box(0.1, 0.02, 0.02, 0.001);

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


}
}