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
import flash.geom.Matrix3D;
/** An anchor representing a body in the world.*/
public class BodyAnchor extends Anchor {
    /**
     * The factor between estimated physical size and default size of the skeleton.
     * <p>This value will be estimated if automaticSkeletonScaleEstimationEnabled is set to true on the BodyTrackingConfiguration.
     * It is used to correct the transform's translation. </p>
     * @default 1.0
     */
    public var estimatedScaleFactor:Number;
    /**
     * The tracked skeleton in 3D.
     * The default height of this skeleton, measured from lowest to highest joint in standing position, is defined to be 1.71 meters.
     */
    public var skeleton:Skeleton3D;
    public function BodyAnchor(id:String, sessionId:String, transform:Matrix3D = null) {
        super(id, sessionId, transform);
    }

    // TODO check actually working
    public function equals(bodyAnchor:BodyAnchor):Boolean {
        return (bodyAnchor.skeleton.jointLocalTransforms == this.skeleton.jointLocalTransforms
                && bodyAnchor.skeleton.jointModelTransforms == this.skeleton.jointModelTransforms);
    }
}
}