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

package com.tuarua.arane.raycast {
import com.tuarua.arane.*;

import flash.geom.Matrix3D;
/** Result of a raycast on a single target. */
public class RaycastResult {
    /** The transformation matrix that defines the raycast result's rotation, translation and scale relative to the world.*/
    public var worldTransform:Matrix3D;
    /** Type of the target where the ray terminated.*/
    public var target:int;
    /** Alignment of the target.*/
    public var targetAlignment:int;
    /** The anchor that the ray intersected.
     * <p>In case of an existing plane target, an anchor will always be provided. In case of an estimated plane target,
     * an anchor may be provided if the ray hit an existing plane.</p>
     */
    public var anchor:Anchor;
    public function RaycastResult() {
    }
}
}