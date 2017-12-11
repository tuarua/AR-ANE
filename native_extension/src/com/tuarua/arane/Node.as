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

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

public class Node {
    private var _id:String;
    private var _parentId:String;
    private var _isAdded:Boolean = false;
    public var geometry:*;
    private var _transform:Matrix3D;
    private var _position:Vector3D = new Vector3D(0, 0, 0);
    private var _scale:Vector3D = new Vector3D(1, 1, 1);
    private var _eulerAngles:Vector3D = new Vector3D(0, 0, 0);
    private var _visible:Boolean = true;
    private var _alpha:Number = 1.0;
    private var _light:Light;
    private var _childNodes:Vector.<Node> = new Vector.<Node>();

    public function Node(geometry:* = null, id:String = null) {
        if (id) {
            this._id = id;
        } else {
            this._id = GUID.create();
        }
        if (geometry) {
            this.geometry = geometry;
            this.geometry["nodeId"] = this._id;
        }
    }

    public function removeFromParentNode():void {
        var theRet:* = ARANEContext.context.call("removeFromParentNode", _id);
        if (theRet is ANEError) throw theRet as ANEError;
        ARANEContext.removedNodeMap.push(_id);
        this._isAdded = false;
        this.parentId = null;
    }

    public function addChildNode(node:Node):void {
        var theRet:* = ARANEContext.context.call("addChildNode", _id, node);
        if (theRet is ANEError) throw theRet as ANEError;
        node.parentId = _id;
        node.isAdded = true;
        _childNodes.push(node);
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
        setANEvalue("visible", value);
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
        checkRemovedChildNodes();
        return _childNodes;
    }

    public function childNodeById(id:String):Node {
        checkRemovedChildNodes();
        for each (var node:Node in _childNodes) {
            if (node.id) {
                return node;
            }
        }
        return null;
    }

    private function checkRemovedChildNodes():void {
        if (ARANEContext.removedNodeMap.length > 0) {
            var i:int;
            var id:String;
            var cnt:int = 0;
            for each (var node:Node in _childNodes) {
                i = ARANEContext.removedNodeMap.indexOf(node.id);
                if (i > -1) {
                    id = node.id;
                    ARANEContext.removedNodeMap.removeAt(i);
                    _childNodes.removeAt(cnt);
                }
                cnt++;
            }
        }
    }

    public function get transform():Matrix3D {
        return _transform;
    }

    public function set transform(value:Matrix3D):void {
        _transform = value;
        setANEvalue("transform", value);
    }

    public function get light():Light {
        return _light;
    }

    public function set light(value:Light):void {
        _light = value;
        _light.nodeId = _id;
        setANEvalue("light", value);
    }

    public function get parentId():String {
        return _parentId;
    }

    public function set parentId(value:String):void {
        _parentId = value;
    }
}
}
