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
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.filesystem.File;

public class WorldTrackingConfiguration extends Configuration {
    private var _planeDetection:Array = [PlaneDetection.none];
    private var _isAutoFocusEnabled:Boolean = true;
    private var _detectionImages:ReferenceImageSet;
    private var _maximumNumberOfTrackedImages:int = 0;
    private var _environmentTexturing:int = EnvironmentTexturing.none;
    private var _detectionObjects:ReferenceObjectSet;
    private var _initialWorldMap:File;
    private var _automaticImageScaleEstimationEnabled:Boolean;
    private var _isCollaborationEnabled:Boolean;
    private var _userFaceTrackingEnabled:Boolean;
    private var _wantsHDREnvironmentTextures:Boolean = true;

    public function WorldTrackingConfiguration() {
        super();
    }

    /** Type of planes to detect in the scene.
     *
     * <p>If set, new planes will continue to be detected and updated over time. Detected planes will be<br />
     * added to the session as ARPlaneAnchor objects. In the event that two planes are merged, the newer<br />
     * plane will be removed. </p>
     * @default to single item array of PlaneDetection.none.
     * */
    public function get planeDetection():Array {
        return _planeDetection;
    }

    public function set planeDetection(value:Array):void {
        _planeDetection = value;
    }

    /** Enable or disable continuous auto focus. iOS 11.3+.
     *
     * @default to true.
     * */
    public function get isAutoFocusEnabled():Boolean {
        return _isAutoFocusEnabled;
    }

    public function set isAutoFocusEnabled(value:Boolean):void {
        _isAutoFocusEnabled = value;
    }

    /** Images to detect in the scene.
     *
     * <p>If set the session will attempt to detect the specified images.
     * When an image is detected an ARImageAnchor will be added to the session. </p>
     *
     * */
    public function get detectionImages():ReferenceImageSet {
        return _detectionImages;
    }

    public function set detectionImages(value:ReferenceImageSet):void {
        _detectionImages = value;
    }

    /**
     * Maximum number of images to track simultaneously.
     * <p> Setting the maximum number of tracked images will limit the number of images that can be tracked in a given frame.<br />
     * If more than the maximum is visible, only the images already being tracked will continue to track until tracking is lost or another image is removed.<br />
     * Images will continue to be detected regardless of images tracked. Default value is zero.</p>
     */
    public function get maximumNumberOfTrackedImages():int {
        return _maximumNumberOfTrackedImages;
    }

    public function set maximumNumberOfTrackedImages(value:int):void {
        _maximumNumberOfTrackedImages = value;
    }

    /**
     * Enables the estimation of a scale factor which may be used to correct the physical size of an image.
     * <p> If set to true ARKit will attempt to use the computed camera positions in order to compute the scale by which the given physical size
     * differs from the estimated one. The information about the estimated scale can be found as the property estimatedScaleFactor on the ImageAnchor. </p>
     * <p> When set to true the transform of a returned ARImageAnchor will use the estimated scale factor to correct the translation. Default value is false.</p>
     * iOS 13.0+
     */
    public function get automaticImageScaleEstimationEnabled():Boolean {
        return _automaticImageScaleEstimationEnabled;
    }

    public function set automaticImageScaleEstimationEnabled(value:Boolean):void {
        _automaticImageScaleEstimationEnabled = value;
    }

    /**
     * Enable/disable a collaborative session. Disabled by default.
     * <p> When enabled, ARSession will output collaboration data for other participants using its delegate didOutputCollaborationData.
     * It is the responsibility of the caller to send the data to each participant. When data is received by a participant, it
     * should be passed to the ARSession by calling updateWithCollaborationData.</p>
     * iOS 13.0+
     */
    public function get isCollaborationEnabled():Boolean {
        return _isCollaborationEnabled;
    }

    public function set isCollaborationEnabled(value:Boolean):void {
        _isCollaborationEnabled = value;
    }

    /** Indicates whether user face tracking using the front facing camera can be enabled on this device. iOS 13.0+ */
    public function get supportsUserFaceTracking():Boolean {
        var ret:* = ARANEContext.context.call("supportsUserFaceTracking");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /** Enable or disable running Face Tracking using the front facing camera. Disabled by default.
     * When enabled, Session detects faces (if visible in the front-facing camera image) and adds to its list of anchors,
     * an FaceAnchor object representing each face.
     * The transform of the FaceAnchor objects will be in the world coordinate space.
     * see FaceAnchor
     * iOS 13.0+
     */
    public function get userFaceTrackingEnabled():Boolean {
        return _userFaceTrackingEnabled;
    }

    public function set userFaceTrackingEnabled(value:Boolean):void {
        _userFaceTrackingEnabled = value;
    }

    /** Determines whether environment textures will be provided with high dynamic range. Enabled by default. iOS 13.0+ */
    public function get wantsHDREnvironmentTextures():Boolean {
        return _wantsHDREnvironmentTextures;
    }

    public function set wantsHDREnvironmentTextures(value:Boolean):void {
        _wantsHDREnvironmentTextures = value;
    }

    /**
     * The mode of environment texturing to run.
     * <p>If set, texture information will be accumulated and updated. Adding an AREnvironmentProbeAnchor to the session<br />
     * will get the current environment texture available from that probe's perspective which can be used for lighting<br />
     * virtual objects in the scene. Defaults to EnvironmentTexturing.none.</p>
     */
    public function get environmentTexturing():int {
        return _environmentTexturing;
    }

    public function set environmentTexturing(value:int):void {
        _environmentTexturing = value;
    }

    /**
     * Objects to detect in the scene.
     * <p>If set the session will attempt to detect the specified objects.<br />
     * When an object is detected an ARObjectAnchor will be added to the session.</p>
     */
    public function get detectionObjects():ReferenceObjectSet {
        return _detectionObjects;
    }

    public function set detectionObjects(value:ReferenceObjectSet):void {
        _detectionObjects = value;
    }

    public function get initialWorldMap():File {
        return _initialWorldMap;
    }

    public function set initialWorldMap(value:File):void {
        _initialWorldMap = value;
    }
}
}
