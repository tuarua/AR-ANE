package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.ImageAnchor;
import com.tuarua.arane.ImageTrackingConfiguration;
import com.tuarua.arane.ObjectAnchor;
import com.tuarua.arane.ReferenceImageSet;
import com.tuarua.arane.ReferenceObjectSet;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.events.ImageDetectedEvent;
import com.tuarua.arane.events.ObjectDetectedEvent;

import flash.display.BitmapData;

public class ObjectDetectionExample {
    private var arkit:ARANE;

    public function ObjectDetectionExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.addEventListener(ObjectDetectedEvent.OBJECT_DETECTED, onObjectDetected);
        arkit.view3D.init(null, mask);

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