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
public class ObjectScanningConfiguration extends Configuration {
    private var _planeDetection:Array = [PlaneDetection.none];
    private var _isAutoFocusEnabled:Boolean = true;
    public function ObjectScanningConfiguration() {
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

}
}