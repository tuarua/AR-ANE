package {
import com.tuarua.ARANE;
import com.tuarua.Color;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.display.NativeButton;
import com.tuarua.arane.display.NativeImage;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.materials.Material;
import com.tuarua.arane.materials.MaterialProperty;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.shapes.Capsule;
import com.tuarua.arane.shapes.Cone;
import com.tuarua.arane.shapes.Plane;
import com.tuarua.arane.shapes.Pyramid;
import com.tuarua.arane.shapes.Sphere;
import com.tuarua.rad2deg;

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
            arkit.scene3D.debugOptions.showWorldOrigin = false;
            arkit.scene3D.debugOptions.showFeaturePoints = false;
            arkit.scene3D.showsStatistics = false;
            arkit.scene3D.init();
            var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
            config.planeDetection = PlaneDetection.horizontal;
            arkit.scene3D.session.run(config);
            setTimeout(function ():void {
                arkit.appendDebug("after 2 seconds add sphere");
                addSphere();
            }, 2000);

            setTimeout(function ():void {
                arkit.appendDebug("after 5 seconds enable debug view of AR Scene");
                enableDebugView();
            }, 5000);

            setTimeout(function ():void {
                arkit.appendDebug("add image from AIR");
                addButtonFromAIR();
            }, 1000);

        }
    }

    private function onPlaneDetected(event:PlaneDetectedEvent):void {
        arkit.appendDebug(event.toString());

        // create a plane and add to show we have detected a plane
        var planeAnchor:PlaneAnchor = event.anchor;
        var node:Node = event.node;
        var plane:Plane = new Plane(planeAnchor.extent.x, planeAnchor.extent.z);
        plane.firstMaterial.diffuse.contents = Color.GREEN;
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


        arkit.scene3D.showsStatistics = true;

        /* //arkit.scene3D.dispose();


         node.alpha = 0.5;
         //node.position = new Vector3D(0, 0.15, 0);

         //var sphere:Sphere = node.geometry as Sphere;
         //sphere.radius = 0.05;

         if(node.childNodes.length > 0){
             var childNode:Node= node.childNodes[0];
             var box:Box = childNode.geometry as Box;
             if (box) {
                 box.width = 0.15;
             }
         }
 */


        switchSphereMaterial();

    }

    private function switchSphereMaterial():void {
        var sphere:Sphere = node.geometry as Sphere;
        sphere.firstMaterial.transparency = 0.8;
        sphere.firstMaterial.diffuse.contents = Color.CYAN;
    }

    private function enableDebugView():void {
        var debugOptions:DebugOptions = new DebugOptions(true, true);
        arkit.scene3D.debugOptions = debugOptions;
    }

    private function addSphere():void {
        var sphere:Sphere = new Sphere(0.025);
        var globeMaterialFile:File = File.applicationDirectory.resolvePath("materials/globe.png");
        if (globeMaterialFile.exists) {
            sphere.firstMaterial.diffuse.contents = globeMaterialFile.nativePath;
        }

        node = new Node(sphere);
        node.position = new Vector3D(0, 0.1, 0); //r g b in iOS world origin
        arkit.scene3D.addChildNode(node);
        trace("sphereNode =", node.id);

        //TODO allow chuld node to be added before rootNode is added
        var box:Box = new Box(0.1, 0.02, 0.02, 0.001);
        box.firstMaterial.diffuse.contents = Color.RED;

        var childNode:Node = new Node(box);
        childNode.eulerAngles = new Vector3D(deg2rad(45), 0, 0);
        node.addChildNode(childNode);
    }

    private function addPyramid():void {
        var pyramid:Pyramid = new Pyramid(0.1, 0.1, 0.1);
        var node:Node = new Node(pyramid);
        arkit.scene3D.addChildNode(node);
    }

    private function addBox():void {
        var box:Box = new Box(0.05, 0.05, 0.05, 0.001);
        var node:Node = new Node(box);
        arkit.scene3D.addChildNode(node);
    }

    private function addCapsule():void {
        var capsule:Capsule = new Capsule(0.05, 0.2);
        var node:Node = new Node(capsule);
        arkit.scene3D.addChildNode(node);
    }

    private function addCone():void {
        var cone:Cone = new Cone(0, 0.05, 0.1);
        var node:Node = new Node(cone);
        arkit.scene3D.addChildNode(node);
    }

}
}