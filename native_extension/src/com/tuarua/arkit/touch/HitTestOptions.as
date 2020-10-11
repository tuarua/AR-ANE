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

package com.tuarua.arkit.touch {

public class HitTestOptions {
    public var clipToZRange:Boolean;
    public var backFaceCulling:Boolean = true;
    public var boundingBoxOnly:Boolean;
    public var ignoreChildNodes:Boolean;
    //public var rootNode:Node; //TODO - pass in Node but have getter for nodeName
    public var ignoreHiddenNodes:Boolean = true;
    public var categoryBitMask:int = 1;
    public var searchMode:int = HitTestSearchMode.closest;

    public function HitTestOptions(clipToZRange:Boolean = false, backFaceCulling:Boolean = true,
                                   boundingBoxOnly:Boolean = false, ignoreChildNodes:Boolean = false,
                                   ignoreHiddenNodes:Boolean = true, searchMode:int = 0) {
        this.clipToZRange = clipToZRange;
        this.backFaceCulling = backFaceCulling;
        this.boundingBoxOnly = boundingBoxOnly;
        this.ignoreChildNodes = ignoreChildNodes;
        this.ignoreHiddenNodes = ignoreHiddenNodes;
        this.searchMode = searchMode;
    }
}
}
