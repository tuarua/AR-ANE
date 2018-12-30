/* Copyright 2018 Tua Rua Ltd.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 Additional Terms
 No part, or derivative of this Air Native Extensions's code is permitted
 to be sold as the basis of a commercially packaged Air Native Extension which
 undertakes the same purpose as this software. That is an ARKit wrapper for iOS.
 All Rights Reserved. Tua Rua Ltd.
 */
package com.tuarua.arane {
/**
 * A configuration for running image tracking.
 * <p>Image tracking provides 6 degrees of freedom tracking of known images. Four images may be tracked simultaneously.<br/>
 * iOS 12.0+.</p>
 */
public class ImageTrackingConfiguration extends Configuration {
    private var _isAutoFocusEnabled:Boolean = true;
    private var _maximumNumberOfTrackedImages:int = 0;
    private var _trackingImages:ReferenceImageSet;
    public function ImageTrackingConfiguration() {
        super();
    }

    /**
     * Maximum number of images to track simultaneously.
     * <p>Setting the maximum number of tracked images will limit the number of images that can be tracked in a given frame.<br />
     * If more than the maximum is visible, only the images already being tracked will continue to track until tracking is lost or another image is removed.<br />
     * Default value is one.</p>
     */
    public function get maximumNumberOfTrackedImages():int {
        return _maximumNumberOfTrackedImages;
    }

    public function set maximumNumberOfTrackedImages(value:int):void {
        _maximumNumberOfTrackedImages = value;
    }

    /** Enable or disable continuous auto focus.
     *
     * @default to true.
     * */
    public function get isAutoFocusEnabled():Boolean {
        return _isAutoFocusEnabled;
    }

    public function set isAutoFocusEnabled(value:Boolean):void {
        _isAutoFocusEnabled = value;
    }

    /**
     Images to track in the scene.
     */
    public function get trackingImages():ReferenceImageSet {
        return _trackingImages;
    }

    public function set trackingImages(value:ReferenceImageSet):void {
        _trackingImages = value;
    }
}
}
