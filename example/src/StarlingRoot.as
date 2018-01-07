package {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.Anchor;
import com.tuarua.arane.AntialiasingMode;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Light;
import com.tuarua.arane.LightType;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.display.NativeButton;
import com.tuarua.arane.display.NativeImage;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.shapes.Capsule;
import com.tuarua.arane.shapes.Cone;
import com.tuarua.arane.shapes.Geometry;
import com.tuarua.arane.shapes.Model;
import com.tuarua.arane.shapes.Plane;
import com.tuarua.arane.shapes.Pyramid;
import com.tuarua.arane.shapes.Sphere;

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
//                 arkit.appendDebug("after 2 seconds add sphere");
//                 addSphere();

//                arkit.appendDebug("after 2 seconds add model from .dae");
//                addModel();

                arkit.appendDebug("after 2 seconds add model from .scn");
                addSCNModel();


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
        var plane:Plane = new Plane(planeAnchor.extent.x, planeAnchor.extent.z);
        plane.firstMaterial.diffuse.contents = ColorARGB.GREEN;
        var planeNode:Node = new Node(plane);

        // need to apply a rotation to fix the orientation of the plane
        var matrix:Matrix3D = new Matrix3D();
        matrix.appendRotation(-90, Vector3D.X_AXIS);

        planeNode.transform = matrix;
        node.addChildNode(planeNode);
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

        /* //arkit.scene3D.dispose();


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
        return;
        //TODO model should contain a childNode which the model is added to??, don't add new Node??
        var node:Node = new Node(model);
        trace("added model to node named", node.name); //ends up as GUID
        node.position = new Vector3D(0, 0, -1.0); //r g b in iOS world origin
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    private function addSCNModel():void {
        var model:Model = new Model("objects/Drone.scn", "helicopter");
        var modelNode:Node = model.rootNode;
        trace("modelNode.isAdded", modelNode.isAdded);
        /*
        trace("modelNode", modelNode);trace("modelNode.name", modelNode.name);
        trace("modelNode.parentName", modelNode.parentName);
        trace("modelNode.geometry", modelNode.geometry);
        trace("modelNode.childNodes", modelNode.childNodes);
        if (modelNode.geometry) {
            var geom:Geometry = modelNode.geometry;
            trace("geom.materials.length", geom.materials.length);
            if (geom.materials.length > 0) {
                trace("geom.firstMaterial.name", geom.firstMaterial.name);
                trace("geom.firstMaterial.isDoubleSided", geom.firstMaterial.isDoubleSided);
                trace("geom.firstMaterial.diffuse", geom.firstMaterial.diffuse);
                trace("geom.firstMaterial.diffuse.nodeName", geom.firstMaterial.diffuse.nodeName);
                trace("geom.firstMaterial.diffuse.materialName", geom.firstMaterial.diffuse.materialName);
                trace("geom.firstMaterial.diffuse.type", geom.firstMaterial.diffuse.type);
                trace("geom.firstMaterial.diffuse.contents", geom.firstMaterial.diffuse.contents);
            }

        }
        trace();*/


        if (modelNode) {

            //TODO allow to set props on model before adding as childNode
            var matrix:Matrix3D = new Matrix3D();
            matrix.appendRotation(90, Vector3D.X_AXIS);
            modelNode.transform = matrix;
            modelNode.position = new Vector3D(modelNode.position.x, modelNode.position.y, modelNode.position.z - 1);

            //modelNode.geometry.firstMaterial.diffuse.contents = ColorARGB.PURPLE; // TODO not working when setting before
            arkit.view3D.scene.rootNode.addChildNode(modelNode);


            var blade1Node:Node = modelNode.childNode("Rotor_R_2");
            var blade2Node:Node = modelNode.childNode("Rotor_L_2");

            var rotorR:Node  = blade1Node.childNode("Rotor_R");
            var rotorL:Node  = blade2Node.childNode("Rotor_L");

            trace("blade1Node", blade1Node);
            trace("blade2Node", blade2Node);

            trace("rotorR", rotorR);
            trace("rotorL", rotorL);

            trace("------");


            //TODO this is not working setting all to YELLOW
            // because all nodes have same material name??

            var bodyMaterial:Material = new Material();
            bodyMaterial.diffuse.contents = ColorARGB.BLACK;

            modelNode.geometry.materials = [bodyMaterial];

            modelNode.geometry.firstMaterial.diffuse.contents = ColorARGB.BLACK;
            blade1Node.geometry.firstMaterial.diffuse.contents = ColorARGB.GREEN;
            blade2Node.geometry.firstMaterial.diffuse.contents = ColorARGB.GREEN;
            //rotorR.geometry.firstMaterial.diffuse.contents = ColorARGB.YELLOW;
            //rotorL.geometry.firstMaterial.diffuse.contents = ColorARGB.YELLOW;

            /*
            let bodyMaterial = SCNMaterial()
        bodyMaterial.diffuse.contents = UIColor.black
        helicopterNode.geometry?.materials = [bodyMaterial]
        scene.rootNode.geometry?.materials = [bodyMaterial]
        let bladeMaterial = SCNMaterial()
        bladeMaterial.diffuse.contents = UIColor.gray
        let rotorMaterial = SCNMaterial()
        rotorMaterial.diffuse.contents = UIColor.darkGray

        blade1Node.geometry?.materials = [rotorMaterial]
        blade2Node.geometry?.materials = [rotorMaterial]
        rotorR.geometry?.materials = [bladeMaterial]
        rotorL.geometry?.materials = [bladeMaterial]
             */



            // TODO add isModel to other child props - really need a better way !!!!
            return;

            /*modelNode.geometry.firstMaterial.diffuse.contents = ColorARGB.BLACK;
            trace("what is the modelNode.name", modelNode.name);
            trace("what is the modelNode.parentId", modelNode.parentName);

            return;


            var blade1Node:Node = modelNode.childNode("Rotor_R_2");
            trace("blade1Node", blade1Node);
            if (blade1Node) {
                trace("blade1Node", blade1Node, blade1Node.name, blade1Node.parentName); //no parentId
                trace("blade1Node.geometry", blade1Node.geometry)
                if (blade1Node.geometry) {
                    //TODO this is not setting the mat prop
                    //blade1Node.geometry.firstMaterial.diffuse.contents = ColorARGB.RED;
                }
            }*/

        }
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

        arkit.view3D.scene.rootNode.addChildNode(node);

        //TODO allow child node to be added before rootNode is added
        var box:Box = new Box(0.1, 0.02, 0.02, 0.001);
        box.firstMaterial.diffuse.contents = ColorARGB.RED;

        var childNode:Node = new Node(box);
        childNode.eulerAngles = new Vector3D(deg2rad(45), 0, 0);
        node.addChildNode(childNode);
    }

    private function addPyramid():void {
        var pyramid:Pyramid = new Pyramid(0.1, 0.1, 0.1);
        var node:Node = new Node(pyramid);
        arkit.view3D.scene.rootNode.addChildNode(node);
    }

    private function addBox():void {
        var box:Box = new Box(0.05, 0.05, 0.05, 0.001);
        var node:Node = new Node(box);
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