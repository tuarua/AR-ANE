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

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

[RemoteClass(alias="com.tuarua.arane.PlaneAnchor")]
public class PlaneAnchor extends Anchor {
    public var alignment:int = 0;
    public var center:Vector3D;
    public var extent:Vector3D;
    /** Classification of the plane. iOS 12.0+ */
    public var classification:uint;

    /** Creates a new anchor object with the specified transform. */
    public function PlaneAnchor(id:String, transform:Matrix3D = null) {
        super(id, transform);
    }

    public function equals(planeAnchor:PlaneAnchor):Boolean {
        return (planeAnchor.alignment == this.alignment
                && planeAnchor.center.equals(this.center)
                && planeAnchor.extent.equals(this.extent));
    }

    /**
     * Determines whether plane classification is supported on this device.
     * Plane classification is available only on iPhone XS, iPhone XS Max, and iPhone XR.
     */
    public static function get isClassificationSupported():Boolean {
        var theRet:* = ARANEContext.context.call("planeAnchor_isClassificationSupported");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

}
}
