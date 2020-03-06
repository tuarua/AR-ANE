package views.examples {
import com.tuarua.ARKit;
import com.tuarua.arkit.ImageAnchor;
import com.tuarua.arkit.ImageTrackingConfiguration;
import com.tuarua.arkit.ObjectAnchor;
import com.tuarua.arkit.ReferenceImageSet;
import com.tuarua.arkit.ReferenceObjectSet;
import com.tuarua.arkit.RunOptions;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.events.ImageDetectedEvent;
import com.tuarua.arkit.events.ObjectDetectedEvent;

import flash.display.BitmapData;

public class ObjectDetectionExample {
    private var arkit:ARKit;

    public function ObjectDetectionExample(arkit:ARKit) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.addEventListener(ObjectDetectedEvent.OBJECT_DETECTED, onObjectDetected);
        arkit.view3D.init(null, mask);

        // 1. Scan an Object using the sample app
        // https://developer.apple.com/documentation/arkit/scanning_and_detecting_3d_objects
        //
        // 2. Package the arobject into Assets.car
        // Assets.car contains the scanned object packaged from an AR Resources.arresourcegroup created in Xcode
        // See https://developer.apple.com/documentation/arkit/arreferenceobject
        // See Method 2: Command Line https://airnativeextensions.github.io/tutorials/icons-assets.car

        var referenceObjects:ReferenceObjectSet = new ReferenceObjectSet("AR Resources");
        var config:WorldTrackingConfiguration = new WorldTrackingConfiguration();
        config.detectionObjects = referenceObjects;
        arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);

    }

    private function onObjectDetected(event:ObjectDetectedEvent):void {
        var anchor:ObjectAnchor = event.anchor;
        arkit.appendDebug("Object Detected: " + anchor.referenceObject.name);
    }

    public function dispose():void {
        arkit.removeEventListener(ObjectDetectedEvent.OBJECT_DETECTED, onObjectDetected);
        arkit.view3D.dispose();
    }

}
}