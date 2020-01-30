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
import flash.geom.Vector3D;

/**
 * Representation of a ray and its target which is used for raycasting.
 * <p>Represents a 3D ray and its target which is used to perform raycasting.</p>
 */
public class RaycastQuery {
    /** Origin of the ray. */
    public var origin:Vector3D;
    /** Type of target where the ray should terminate.*/
    public var target:int;
    /** The alignment of the target that should be considered for raycasting.*/
    public var targetAlignment:int;
    /** Direction of the ray.*/
    public var direction:Vector3D;

    public function RaycastQuery() {
    }
}
}