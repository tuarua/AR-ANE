package views.examples {
import com.tuarua.ARANE;
import com.tuarua.ColorARGB;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.PlaneAnchorAlignment;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.events.PhysicsEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.events.PlaneRemovedEvent;
import com.tuarua.arane.events.PlaneUpdatedEvent;
import com.tuarua.arane.events.TapEvent;
import com.tuarua.arane.physics.PhysicsBody;
import com.tuarua.arane.physics.PhysicsBodyType;
import com.tuarua.arane.physics.PhysicsShape;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.touch.ARHitTestResult;
import com.tuarua.arane.touch.HitTestResultType;

import flash.display.BitmapData;
import flash.filesystem.File;

import flash.geom.Vector3D;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import views.SimpleButton;

public class PlaneDetectionExample {
    private var arkit:ARANE;
    private var saveButton:SimpleButton;

    public function PlaneDetectionExample(arkit:ARANE, saveButton:SimpleButton = null) {
        this.arkit = arkit;
        this.saveButton = saveButton;
        if (this.saveButton) {
            saveButton.addEventListener(TouchEvent.TOUCH, onSaveClick);
        }
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.debugOptions = [DebugOptions.showFeaturePoints];
        arkit.view3D.showsStatistics = true;
        arkit.view3D.autoenablesDefaultLighting = true;

        arkit.addEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.addEventListener(PlaneUpdatedEvent.PLANE_UPDATED, onPlaneUpdated);
        arkit.addEventListener(PlaneRemovedEvent.PLANE_REMOVED, onPlaneRemoved);
        arkit.addEventListener(TapEvent.TAP, onSceneTapped);
        arkit.addEventListener(PhysicsEvent.CONTACT_DID_BEGIN, onPhysicsContactBegin);
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();

        if (arkit.iosVersion >= 11.3) {
            config.planeDetection = [PlaneDetection.horizontal, PlaneDetection.vertical];
        } else {
            config.planeDetection = [PlaneDetection.horizontal];
        }

        var worldMapFile:File = File.applicationStorageDirectory.resolvePath("worldMap.data");
        if (worldMapFile.exists) {
            config.initialWorldMap = worldMapFile;
        }

        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function onSaveClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(saveButton);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            arkit.view3D.session.saveCurrentWorldMap(File.applicationStorageDirectory.resolvePath("worldMap.data"),
                    function ():void {
                        trace("saveCurrentWorldMap closure reached");
                    });
        }
    }

    //noinspection JSMethodCanBeStatic
    private function createGridNode(planeAnchor:PlaneAnchor):Node {
        //plane is not quite flush with floor
        var plane:Box = new Box(planeAnchor.extent.x, planeAnchor.extent.z, 0);
        var gridTexture:String = "materials/grid.png";
        plane.firstMaterial.diffuse.contents = gridTexture;

        var planeNode:Node = new Node(plane);
        planeNode.position = new Vector3D(planeAnchor.center.x, 0, planeAnchor.center.z);

        var boxShape:PhysicsShape = new PhysicsShape(plane);
        var planePhysics:PhysicsBody = new PhysicsBody(PhysicsBodyType.static, boxShape);
        planePhysics.categoryBitMask = PhysicsCategory.floor;
        planePhysics.collisionBitMask = PhysicsCategory.box;
        planePhysics.contactTestBitMask = PhysicsCategory.box;
        planeNode.physicsBody = planePhysics;

        planeNode.eulerAngles = new Vector3D(-Math.PI / 2, 0, 0);
        return planeNode;
    }

    private function onPlaneDetected(event:PlaneDetectedEvent):void {
        trace(event);
        arkit.appendDebug("Plane Detected: " + event.node.name + " "
                + ((event.anchor.alignment == PlaneAnchorAlignment.vertical) ? "vertical" : "horizontal"));
        // create a plane and add to show we have detected a plane
        var node:Node = event.node;
        node.addChildNode(createGridNode(event.anchor));
    }

    private function onPlaneUpdated(event:PlaneUpdatedEvent):void {
        var planeAnchor:PlaneAnchor = event.anchor;
        var node:Node = arkit.view3D.scene.rootNode.childNode(event.nodeName);
        if (node && node.childNodes.length) {
            var planeNode:Node = node.childNodes[0];
            var plane:Box = planeNode.geometry as Box;
            plane.width = planeAnchor.extent.x;
            plane.height = planeAnchor.extent.z;
            planeNode.position = new Vector3D(planeAnchor.center.x, 0, planeAnchor.center.z);
            var boxShape:PhysicsShape = new PhysicsShape(plane);
            var planePhysics:PhysicsBody = new PhysicsBody(PhysicsBodyType.static, boxShape);
            planePhysics.categoryBitMask = PhysicsCategory.floor;
            planePhysics.collisionBitMask = PhysicsCategory.box;
            planePhysics.contactTestBitMask = PhysicsCategory.box;
            planeNode.physicsBody = planePhysics;
        }
    }

    private function onPlaneRemoved(event:PlaneRemovedEvent):void {
        arkit.appendDebug("Plane Removed: " + event.nodeName);
        var node:Node = arkit.view3D.scene.rootNode.childNode(event.nodeName);
        if (node) {
            node.removeChildNodes();
            node.removeFromParentNode();
        }
    }

    private function onSceneTapped(event:TapEvent):void {
        //trace("arkit.view3D.camera.position", arkit.view3D.camera.position);
        if (event.location) {
            // look for planes
            var arHitTestResult:ARHitTestResult = arkit.view3D.hitTest3D(
                    event.location, [HitTestResultType.existingPlaneUsingExtent]
            );
            if (arHitTestResult) {
                var planeAnchor:PlaneAnchor = arHitTestResult.anchor as PlaneAnchor;
                if (planeAnchor) {
                    if (planeAnchor.alignment == PlaneAnchorAlignment.horizontal) {
                        var box:Box = new Box(0.1, 0.1, 0.1);
                        box.firstMaterial.diffuse.contents = ColorARGB.ORANGE;
                        var boxNode:Node = new Node(box);

                        var boxShape:PhysicsShape = new PhysicsShape(box);
                        var physicsBody:PhysicsBody = new PhysicsBody(PhysicsBodyType.dynamic, boxShape);
                        physicsBody.allowsResting = true;
                        physicsBody.categoryBitMask = PhysicsCategory.box;
                        physicsBody.collisionBitMask = PhysicsCategory.floor | PhysicsCategory.box;
                        physicsBody.contactTestBitMask = PhysicsCategory.floor | PhysicsCategory.box;

                        boxNode.physicsBody = physicsBody;
                        boxNode.position = new Vector3D(arHitTestResult.worldTransform.position.x,
                                arHitTestResult.worldTransform.position.y + 0.5,
                                arHitTestResult.worldTransform.position.z);

                        arkit.view3D.scene.rootNode.addChildNode(boxNode);
                    } else {
                        var node:Node = arkit.view3D.node(arHitTestResult.anchor);
                        if (node != null) {
                            (node.childNodes[0].geometry as Box).firstMaterial.diffuse.contents = 0x80FFFFFF;
                        }
                    }
                }

            }

        }
    }

    //noinspection JSMethodCanBeStatic
    private function onPhysicsContactBegin(event:PhysicsEvent):void {
        trace("contact between", event.contact.nodeNameA, "and", event.contact.nodeNameB);
    }

    public function dispose():void {
        arkit.removeEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.removeEventListener(PlaneUpdatedEvent.PLANE_UPDATED, onPlaneUpdated);
        arkit.removeEventListener(PlaneRemovedEvent.PLANE_REMOVED, onPlaneRemoved);
        arkit.removeEventListener(TapEvent.TAP, onSceneTapped);
        arkit.removeEventListener(PhysicsEvent.CONTACT_DID_BEGIN, onPhysicsContactBegin);
        arkit.view3D.dispose();
    }
}
}
