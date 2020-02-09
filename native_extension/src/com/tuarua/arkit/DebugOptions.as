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
public final class DebugOptions {
    // These are strings as the numbers are 64bit uint which AIR does not support
    // parsed in Swift to UInt
    public static const showFeaturePoints:String = "1073741824";
    public static const showWorldOrigin:String = "18446744071562067968";
    public static const showConstraints:String = "512";
    public static const showLightExtents:String = "8";
    public static const showPhysicsShapes:String = "1";
    public static const showBoundingBoxes:String = "2";
    public static const showLightInfluences:String = "4";
    public static const showPhysicsFields:String = "16";
    public static const showWireframe:String = "32";
    public static const renderAsWireframe:String = "64";
    public static const showSkeletons:String = "128";
    public static const showCreases:String = "256";
    public static const showCameras:String = "1024";
}
}