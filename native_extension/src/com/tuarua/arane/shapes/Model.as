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

package com.tuarua.arane.shapes {
import com.tuarua.ARANEContext;
import com.tuarua.arane.Node;

//import com.tuarua.arane.materials.Material;
import com.tuarua.fre.ANEError;

public class Model {
    private var _isAdded:Boolean = false;
    private var _url:String;
    private var _nodeName:String;
    private var _flatten:Boolean;
    //private var _materials:Vector.<Material> = new Vector.<Material>();
    private var _rootNode:Node;

    public function Model(url:String, nodeName:String = null, flatten:Boolean = false) {
        super();
        this._url = url;
        this._nodeName = nodeName;
        this._flatten = flatten;
    }

    public function get url():String {
        return _url;
    }

    public function get nodeName():String {
        return _nodeName;
    }

//    public function get isAdded():Boolean {
//        return _isAdded;
//    }

    public function set isAdded(value:Boolean):void {
        _isAdded = value;
    }

    /*public function set nodeName(value:String):void {
        _nodeName = value;
    }*/

    public function get rootNode():Node {
        //first get call in to get node
        // and add scene to models dict
        if (!_isAdded) {
            var theRet:* = ARANEContext.context.call("addModel", _url, nodeName, this._flatten);
            if (theRet is ANEError) throw theRet as ANEError;
            _rootNode = theRet as Node;
            if (!_rootNode) {
                return null;
            }
            _rootNode.isModel = true;
            _rootNode.isDAE = _url.indexOf(".dae") > -1;
        }
        _rootNode.parentName = nodeName;
        return _rootNode;
    }
}
}
