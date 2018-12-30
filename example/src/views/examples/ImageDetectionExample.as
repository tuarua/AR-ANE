package views.examples {
import com.tuarua.ARANE;
import com.tuarua.arane.ImageAnchor;
import com.tuarua.arane.ImageTrackingConfiguration;
import com.tuarua.arane.ReferenceImageSet;
import com.tuarua.arane.RunOptions;
import com.tuarua.arane.WorldTrackingConfiguration;
import com.tuarua.arane.events.ImageDetectedEvent;

import flash.display.BitmapData;

public class ImageDetectionExample {
    private var arkit:ARANE;

    public function ImageDetectionExample(arkit:ARANE) {
        this.arkit = arkit;
    }

    public function run(mask:BitmapData = null):void {
        arkit.view3D.autoenablesDefaultLighting = true;
        arkit.addEventListener(ImageDetectedEvent.IMAGE_DETECTED, onImageDetected);
        arkit.view3D.init(null, mask);

        // copy image from "reference_images" onto a *secondary* Apple device and display in fullscreen.
        // Assets.car contains these images packaged from an AR Resources.arresourcegroup created in Xcode
        // See https://developer.apple.com/documentation/arkit/recognizing_images_in_an_ar_experience for more details

        var config:*;
        var referenceImages:ReferenceImageSet = new ReferenceImageSet("AR Resources");
        if (arkit.iosVersion >= 12.0) {
            config = new ImageTrackingConfiguration();
            config.trackingImages = referenceImages;
            arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
        } else {
            config = new WorldTrackingConfiguration();
            config.detectionImages = referenceImages;
            arkit.view3D.session.run(config, [RunOptions.resetTracking, RunOptions.removeExistingAnchors]);
        }

    }

    private function onImageDetected(event:ImageDetectedEvent):void {
        var anchor:ImageAnchor = event.anchor;
        arkit.appendDebug("Image Detected: " + anchor.name + " " + anchor.width.toFixed(3) + " x " + anchor.height.toFixed(3) + " metres");
    }

    public function dispose():void {
        arkit.removeEventListener(ImageDetectedEvent.IMAGE_DETECTED, onImageDetected);
        arkit.view3D.dispose();
    }

}
}