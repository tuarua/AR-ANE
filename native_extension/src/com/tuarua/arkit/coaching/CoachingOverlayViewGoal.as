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

package com.tuarua.arkit.coaching {
public final class CoachingOverlayViewGoal {
    /** Session requires normal tracking */
    public static const tracking:uint = 0;
    /** Session requires a horizontal plane */
    public static const horizontalPlane:uint = 1;
    /** Session requires a vertical plane */
    public static const verticalPlane:uint = 2;
    /** Session requires one plane of any type */
    public static const anyPlane:uint = 3;
}
}

