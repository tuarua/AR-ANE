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

package com.tuarua.arkit.raycast {
public final class RaycastQueryTarget {
    /** Ray's target is an already detected plane, considering the plane's estimated size and shape. */
    public static const existingPlaneGeometry:int = 0;
    /** Ray's target is an already detected plane, without considering the plane's size. */
    public static const existingPlaneInfinite:int = 1;
    /**
     * Ray's target is a plane that is estimated using the feature points around the ray.
     * When alignment is ARRaycastTargetAlignmentAny, alignment of estimated planes is based on the normal of the real world
     * surface corresponding to the estimated plane.
     */
    public static const estimatedPlane:int = 2;
}
}
