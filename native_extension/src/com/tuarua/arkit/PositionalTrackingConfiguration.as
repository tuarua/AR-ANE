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

package com.tuarua.arkit {
import com.tuarua.ARANEContext;
import com.tuarua.fre.ANEError;

import flash.filesystem.File;
/**
 * A configuration for running positional tracking.
 * <p>Positional tracking provides 6 degrees of freedom tracking of the device by running the camera at lowest
 * possible resolution and frame rate.</p>
 * iOS 13.0+.
 */
public class PositionalTrackingConfiguration extends Configuration {
    private var _planeDetection:Array = [PlaneDetection.none];
    private var _initialWorldMap:File;

    public function PositionalTrackingConfiguration() {
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

    public function get initialWorldMap():File {
        return _initialWorldMap;
    }

    public function set initialWorldMap(value:File):void {
        _initialWorldMap = value;
    }

    /**
     * A Boolean value indicating whether the current device supports this session configuration class.
     *
     * <p>Different types of AR experiences (which you configure using concrete ARConfiguration subclasses)
     * can have different hardware requirements.</p>
     *
     * <p>Before attempting to create an AR configuration, verify that the user’s device supports the
     * configuration you plan to use by checking the isSupported property of the corresponding configuration class.
     * If this property’s value is false, the current device does not support the requested configuration.</p>
     */
    public static function get isSupported():Boolean {
        var ret:* = ARANEContext.context.call("isSupported_PositionalConfig");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }
}
}