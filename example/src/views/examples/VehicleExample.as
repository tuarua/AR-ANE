/*
package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.DebugOptions;
import com.tuarua.arane.Node;
import com.tuarua.arane.PlaneAnchor;
import com.tuarua.arane.PlaneAnchorAlignment;
import com.tuarua.arane.PlaneDetection;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.PlaneDetectedEvent;
import com.tuarua.arane.physics.PhysicsBody;
import com.tuarua.arane.physics.PhysicsBodyType;
import com.tuarua.arane.physics.PhysicsShape;
import com.tuarua.arane.physics.PhysicsShapeOption;
import com.tuarua.arane.physics.PhysicsVehicle;
import com.tuarua.arane.physics.PhysicsVehicleWheel;
import com.tuarua.arane.shapes.Box;
import com.tuarua.arane.shapes.Model;

import flash.display.BitmapData;
import flash.geom.Vector3D;

public class VehicleExample {
    private var arkit:ARANE;
    private var vehicle:PhysicsVehicle;

    public function VehicleExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.showsStatistics = true;
        arkit.view3D.debugOptions = [DebugOptions.showWorldOrigin];
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.addEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);
        arkit.view3D.init(null, mask);
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        config.planeDetection = [PlaneDetection.horizontal];
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
    }

    private function onPlaneDetected(event:PlaneDetectedEvent):void {
        arkit.appendDebug("Plane Detected: " + event.node.name + " "
                + ((event.anchor.alignment == PlaneAnchorAlignment.vertical) ? "vertical" : "horizontal"));
        // create a plane and add to show we have detected a plane
        var node:Node = event.node;
        node.addChildNode(createGridNode(event.anchor));
        arkit.removeEventListener(PlaneDetectedEvent.PLANE_DETECTED, onPlaneDetected);

        addModel();

    }

    //noinspection JSMethodCanBeStatic
    private function createGridNode(planeAnchor:PlaneAnchor):Node {
        //plane is not quite flush with floor
        var plane:Box = new Box(planeAnchor.extent.x, planeAnchor.extent.z, 0);
        var gridTexture:String = "materials/grid.png";
        plane.firstMaterial.diffuse.contents = gridTexture;

        var planeNode:Node = new Node(plane);
        // planeNode.position = new Vector3D(planeAnchor.center.x, 0, planeAnchor.center.z);
        planeNode.position = new Vector3D(0, 0,0);

        var boxShape:PhysicsShape = new PhysicsShape(plane);
        var planePhysics:PhysicsBody = new PhysicsBody(PhysicsBodyType.static, boxShape);
        planePhysics.categoryBitMask = PhysicsCategory.floor;
        planePhysics.collisionBitMask = PhysicsCategory.box;
        planePhysics.contactTestBitMask = PhysicsCategory.box;
        planeNode.physicsBody = planePhysics;

        planeNode.eulerAngles = new Vector3D(-Math.PI / 2, 0, 0);
        return planeNode;
    }

    private function addModel():void {
        var currentPositionOfCamera:Vector3D = arkit.view3D.camera.position;
        trace(currentPositionOfCamera);

        var model:Model = new Model("art.scnassets/car.scn");
        var carNode:Node = model.rootNode;
        carNode.position = new Vector3D(0, 0, 0);
        trace("carNode.scale", carNode.scale);
        if (!carNode) {
            arkit.appendDebug("no carNode");
            return;
        }
        var chassis:Node = carNode.childNode("chassis");
        if (!chassis) {
            arkit.appendDebug("no chassis");
            return;
        }
        arkit.appendDebug("Found chassis");
        var frontRight:Node = chassis.childNode("frontRightTireLocator");
        var frontLeft:Node = chassis.childNode("frontLeftTireLocator");
        var rearRight:Node = chassis.childNode("rearRightTireLocator");
        var rearLeft:Node = chassis.childNode("rearLeftTireLocator");

        var frontRightWheel:PhysicsVehicleWheel = new PhysicsVehicleWheel(frontRight);
        var frontLeftWheel:PhysicsVehicleWheel = new PhysicsVehicleWheel(frontLeft);
        var rearRightWheel:PhysicsVehicleWheel = new PhysicsVehicleWheel(rearRight);
        var rearLeftWheel:PhysicsVehicleWheel = new PhysicsVehicleWheel(rearLeft);

        var wheels:Vector.<PhysicsVehicleWheel> = new <PhysicsVehicleWheel>[frontLeftWheel, frontRightWheel, rearLeftWheel, rearRightWheel];

        trace(wheels);

        var physicsBody:PhysicsBody = new PhysicsBody(PhysicsBodyType.dynamic);
        physicsBody.mass = 140;
        physicsBody.allowsResting = true;
        physicsBody.isAffectedByGravity = true;
        physicsBody.categoryBitMask = PhysicsCategory.box;
        physicsBody.collisionBitMask = PhysicsCategory.floor | PhysicsCategory.box;
        physicsBody.contactTestBitMask = PhysicsCategory.floor | PhysicsCategory.box;

        chassis.physicsBody = physicsBody;

        vehicle = new PhysicsVehicle(chassis.physicsBody, wheels);

        const y:Number = 2.86082750558853;
        wheels[0].connectionPosition = new Vector3D(-wheels[0].connectionPosition.x - 0.28, y - 0.3, wheels[0].connectionPosition.z);
        wheels[1].connectionPosition = new Vector3D(-wheels[1].connectionPosition.x + 0.28, y - 0.3, wheels[1].connectionPosition.z);
        wheels[2].connectionPosition = new Vector3D(-wheels[2].connectionPosition.x, y, wheels[2].connectionPosition.z);
        wheels[3].connectionPosition = new Vector3D(-wheels[3].connectionPosition.x, y, wheels[3].connectionPosition.z);

        arkit.view3D.scene.physicsWorld.addBehavior(vehicle);
        arkit.view3D.scene.rootNode.addChildNode(carNode);

        vehicle.applyEngineForce(410,2);
        vehicle.applyEngineForce(300,3);
        vehicle.setSteeringAngle(0.6, 0);
        vehicle.setSteeringAngle(0.6, 1);

        trace(vehicle.speedInKilometersPerHour);

    }

    public function dispose():void {
        arkit.view3D.dispose();
    }

}
}
*/
