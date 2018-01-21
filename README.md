![Adobe AIR + ARKit](arane2.png)

ARKit Adobe Air Native Extension for iOS 11.0+
This ANE provides bindings for the ARKit API


-------------

Much time, skill and effort has gone into this. Help support the project

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

-------------

### The ANE

Download the latest from the [Releases](https://github.com/tuarua/AR-ANE/releases) page.


### Dependencies

From the command line cd into /example and run:
````shell
bash get_ios_dependencies.sh
`````
This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.   
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.

### Getting Started

Firstly, familiarise yourself with the concepts of Apple's ARKit. This ANE is at its core a binding for the ARKit APIs.

### Usage
````actionscript
arkit = ARANE.arkit;
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
````` 
### Geometries

The following geometries based on their SCNKit equivalents are available:
Box, Sphere, Capsule, Cone, Cylinder, Plane, Pyramid, Torus, Tube

Example

````actionscript
var cone:Cone = new Cone(0, 0.05, 0.1);
var node:Node = new Node(cone);
arkit.view3D.scene.rootNode.addChildNode(node);
````` 

### Materials

Materials can be supplied as:   
ARGB uint   
BitmapData   
String path to image file   

Example

````actionscript
box.firstMaterial.diffuse.contents = ColorARGB.RED;

sphere.firstMaterial.diffuse.contents = "materials/globe.png";

//supply 6 materials for 6 sides of box
box.materials = new <Material>[redMat, greenMat, blueMat, yellowMat, brownMat, whiteMat];
````` 

### Physics
Example

````actionscript
var box:Box = new Box(0.1, 0.1, 0.1);
box.firstMaterial.diffuse.contents = ColorARGB.ORANGE;
var boxNode:Node = new Node(box);
var boxShape:PhysicsShape = new PhysicsShape(box);
var physicsBody:PhysicsBody = new PhysicsBody(PhysicsBodyType.dynamic, boxShape);
physicsBody.allowsResting = true;

boxNode.physicsBody = physicsBody;
boxNode.position = new Vector3D(0, 0.5, 0);

arkit.view3D.scene.rootNode.addChildNode(boxNode);
````` 

### Detecting Planes
Example

````actionscript
arkit = ARANE.arkit;
arkit.addEventListener(PlaneDetectedEvent.ON_PLANE_DETECTED, onPlaneDetected);

private function onPlaneDetected(event:PlaneDetectedEvent):void {
    var planeAnchor:PlaneAnchor = event.anchor;
    var node:Node = event.node;
    
    var plane:Box = new Box(planeAnchor.extent.x, planeAnchor.extent.z, 0);
    if (gridMaterialFile.exists) {
        plane.firstMaterial.diffuse.contents = gridMaterialFile.nativePath;
    }
    var planeNode:Node = new Node(plane);
    planeNode.position = new Vector3D(planeAnchor.center.x, 0, planeAnchor.center.z)
    var boxShape:PhysicsShape = new PhysicsShape(plane);
    planeNode.physicsBody = new PhysicsBody(PhysicsBodyType.static, boxShape);
    planeNode.eulerAngles = new Vector3D(-Math.PI / 2, 0, 0);
    node.addChildNode(planeNode);
}
`````

### Camera Tracking
Example

````actionscript
arkit = ARANE.arkit;
arkit.addEventListener(CameraTrackingEvent.ON_STATE_CHANGE, onCameraTrackingStateChange);

private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
    switch (event.state) {
        case TrackingState.notAvailable:
            break;
        case TrackingState.normal:
            break;
        case TrackingState.limited:
            switch (event.reason) {
                case TrackingStateReason.excessiveMotion:
                    break;
                case TrackingStateReason.initializing:
                    break;
                case TrackingStateReason.insufficientFeatures:
                    break;
            }
            break;
    }
}

````` 

### Detecting Touches
````actionscript
arkit = ARANE.arkit;
arkit.addEventListener(TapEvent.ON_SCENE3D_TAP, onSceneTapped);
private function onSceneTapped(event:TapEvent):void {
    if (event.location) {
        // look for planes
        var arHitTestResult:ARHitTestResult = arkit.view3D.hitTest3D(event.location, [HitTestResultType.existingPlaneUsingExtent]);
        if (arHitTestResult) {
        //plane tapped
        }
        
        var hitTestResult:HitTestResult = arkit.view3D.hitTest(event.location, new HitTestOptions());
        trace("hitTestResult", hitTestResult);
        if (hitTestResult) {
        // node tapped on
        }
    }
}
````` 

### Running on Simulator

ARKit won't run on the simulator

### Running on Device

The example project can be run on the device from IntelliJ using AIR 28.

### Issues

The Issues section is for bugs and API requests **only**.     
Use the supplied template or the ticket will be closed.   
Paid Premium support is available.

### Contributing

If you have knowledge of ARKit contributions are welcome. This includes adding documentation, sample code and Scenekit models.   
Likewise, sponsorship or donations will go a long way to pushing the ANE further along.

### Prerequisites

You will need:

- an iOS device with an A9 or later processor
- IntelliJ IDEA / Flash Builder
- AIR 28
- Xcode 9.1 if you wish to edit the iOS source
- wget on OSX

### Task List

* Planes
    - [x] Plane Detection
    - [x] Plane Updates
    - [ ] Plane Removal
* Geometry
    - [x] Box
    - [x] Capsule
    - [x] Cone
    - [x] Cylinder
    - [x] Plane
    - [x] Pyramid
    - [x] Shape (from SVG)
    - [x] Sphere
    - [x] Models
        - [x] from .scn
        - [x] from .dae
    - [ ] Text
    - [x] Torus
    - [x] Tube

* Lighting

* Materials
    - [x] Colour
    - [x] Image
    - [x] BitmapData
* Physics
    - [ ] Collision Events

* Animation

* CameraTracking
   - [x] Events

* Touch
    - [x] Tap
    - [x] Swipe
    - [ ] Pinch
* Hit Test


### References
* [https://developer.apple.com/documentation/arkit]
* [https://github.com/eh3rrera/ARKitSceneKitExample]
* [https://github.com/rosberry/pARtfolio]
* [https://www.appcoda.com/arkit-physics-scenekit/]



