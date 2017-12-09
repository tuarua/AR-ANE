/* Copyright 2017 Tua Rua Ltd.

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
import com.tuarua.utils.GUID;

import flash.geom.Vector3D;

public class Node {
    private var _id:String;
    private var _isAdded:Boolean = false;
    public var geometry:*;
    private var _position:Vector3D = new Vector3D(0, 0, 0);
    private var _scale:Vector3D = new Vector3D(1, 1, 1);
    private var _eulerAngles:Vector3D = new Vector3D(0, 0, 0);
    private var _visible:Boolean = true;
    private var _alpha:Number = 1.0;
    private var _childNodes:Vector.<Node> = new Vector.<Node>();

    public function Node(geometry:*) {
        this._id = GUID.create();
        this.geometry = geometry;
        this.geometry["nodeId"] = this._id;
    }

    public function removeFromParentNode():void {
        var theRet:* = ARANEContext.context.call("removeFromParentNode", _id);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function addChildNode(node:Node):void {
        var theRet:* = ARANEContext.context.call("addChildNode", _id, node);
        if (theRet is ANEError) throw theRet as ANEError;
        _childNodes.push(node);
    }

    public function childNodeById(id:String):Node {
        for each (var node:Node in _childNodes) {
            if (node.id) {
                return node;
            }
        }
        return null;
    }

    public function get id():String {
        return _id;
    }

    public function get alpha():Number {
        return _alpha;
    }

    public function set alpha(value:Number):void {
        _alpha = value;
        setANEvalue("opacity", value);
    }

    public function get visible():Boolean {
        return _visible;
    }

    public function set visible(value:Boolean):void {
        _visible = value;
        setANEvalue("isHidden", value);
    }

    public function get eulerAngles():Vector3D {
        return _eulerAngles;
    }

    public function set eulerAngles(value:Vector3D):void {
        _eulerAngles = value;
        setANEvalue("eulerAngles", value);
    }

    public function get scale():Vector3D {
        return _scale;
    }

    public function set scale(value:Vector3D):void {
        _scale = value;
        setANEvalue("scale", value);
    }

    public function get position():Vector3D {
        return _position;
    }

    public function set position(value:Vector3D):void {
        _position = value;
        setANEvalue("position", value);
    }

    private function setANEvalue(name:String, value:*):void {
        if (_isAdded) {
            var theRet:* = ARANEContext.context.call("setChildNodeProp", _id, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function get isAdded():Boolean {
        return _isAdded;
    }

    public function set isAdded(value:Boolean):void {
        _isAdded = value;
    }

    public function get childNodes():Vector.<Node> {
        return _childNodes;
    }
}
}
