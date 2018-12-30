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

package com.tuarua.arane {
import com.tuarua.ARANEContext;
import com.tuarua.arane.lights.Light;
import com.tuarua.arane.physics.PhysicsBody;
import com.tuarua.fre.ANEError;

import flash.geom.Matrix3D;
import flash.geom.Vector3D;

[RemoteClass(alias="com.tuarua.arane.Node")]
public class Node extends NodeReference {
    private var _isModel:Boolean = false;
    private var _isDAE:Boolean = false;
    private var _geometry:*;
    private var _transform:Matrix3D;
    private var _position:Vector3D = new Vector3D(0, 0, 0);
    private var _scale:Vector3D = new Vector3D(1, 1, 1);
    private var _eulerAngles:Vector3D = new Vector3D(0, 0, 0);
    private var _visible:Boolean = true;
    private var _castsShadow:Boolean = true;
    private var _alpha:Number = 1.0;
    private var _light:Light;
    private var _physicsBody:PhysicsBody;
    private var _childNodes:Vector.<Node> = new Vector.<Node>();
    private var _categoryBitMask:int = 1;

    /** Node is the model class for node-tree objects.
     *
     * @param geometry
     * @param name
     */
    public function Node(geometry:* = null, name:String = null) {
        super(name);
        if (geometry) {
            this._geometry = geometry;
            this._geometry["nodeName"] = this._name;
        }
    }

    public function removeChildNodes():void {
        var theRet:* = ARANEContext.context.call("node_removeChildren", _name);
        if (theRet is ANEError) throw theRet as ANEError;
        for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
            _childNodes.removeAt(i);
        }
    }

    /** Removes the node from the childNodes array of the receiver’s parentNode.*/
    public function removeFromParentNode():void {
        var theRet:* = ARANEContext.context.call("node_removeFromParentNode", _name);
        if (theRet is ANEError) throw theRet as ANEError;
        ARANEContext.removedNodeMap.push(_name);
        this._isAdded = false;
        this._parentName = null;
    }

    /** Add child node.
     *
     * @param node
     */
    public function addChildNode(node:Node):void {
        node.parentName = _name;
        if (_isAdded || _name == "sceneRoot") {
            var theRet:* = ARANEContext.context.call("node_addChildNode", _name, node);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        node.isAdded = true;
        _childNodes.push(node);
    }


    public function get alpha():Number {
        return _alpha;
    }

    public function set alpha(value:Number):void {
        if (value == _alpha) return;
        _alpha = value;
        setANEvalue("opacity", value);
    }

    public function get visible():Boolean {
        return _visible;
    }

    public function set visible(value:Boolean):void {
        if (value == _visible) return;
        _visible = value;
        setANEvalue("visible", value);
    }

    public function get eulerAngles():Vector3D {
        return _eulerAngles;
    }

    public function set eulerAngles(value:Vector3D):void {
        if (value.equals(_eulerAngles)) return;
        _eulerAngles = value;
        setANEvalue("eulerAngles", value);
    }

    public function get scale():Vector3D {
        return _scale;
    }

    public function set scale(value:Vector3D):void {
        if (value.equals(_scale)) return;
        _scale = value;
        setANEvalue("scale", value);
    }

    public function get position():Vector3D {
        return _position;
    }

    public function set position(value:Vector3D):void {
        if (value.equals(_position)) return;
        _position = value;
        setANEvalue("position", value);
    }

    /** @private */
    private function setANEvalue(name:String, value:*):void {
        if (_isAdded) {
            var theRet:* = ARANEContext.context.call("node_setProp", _name, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** @private */
    override public function set isAdded(value:Boolean):void {
        _isAdded = value;
        for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
            _childNodes[i].isAdded = true;
        }
    }

    public function get childNodes():Vector.<Node> {
        checkRemovedChildNodes();
        return _childNodes;
    }

    public function childNode(nodeName:String):Node {
        checkRemovedChildNodes();
        for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
            if (_childNodes[i].name == nodeName) {
                return _childNodes[i];
            }
        }

        // if we have passed through, check native implementation - this handles nodes added from native
        var theRet:* = ARANEContext.context.call("node_childNode", _name, nodeName);
        //if (theRet is ANEError) throw theRet as ANEError;
        if (theRet is ANEError) return null;
        var returnNode:Node = theRet as Node;
        if (returnNode) {
            returnNode.isAdded = true;
            _childNodes.push(returnNode); //TODO what if the node that comes back is not child of this
        }
        return returnNode;
    }

    /** @private */
    private function checkRemovedChildNodes():void {
        if (ARANEContext.removedNodeMap.length > 0) {
            var index:int = 0;
            for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
                index = ARANEContext.removedNodeMap.indexOf(_childNodes[i].name);
                if (index > -1) {
                    ARANEContext.removedNodeMap.removeAt(i);
                    _childNodes.removeAt(i);
                }
            }
        }
    }

    public function get transform():Matrix3D {
        return _transform;
    }

    public function set transform(value:Matrix3D):void {
        if(value == null || _transform == null) {
            _transform = value;
            return;
        }
        var isEqual:Boolean = true;
        for (var i:int = 0, l:int = value.rawData.length; i < l; ++i) {
            if (value.rawData[i] != _transform.rawData[i]) {
                isEqual = false;
                break;
            }
        }
        if (isEqual) return;
        _transform = value;
        setANEvalue("transform", value);
    }

    public function get light():Light {
        return _light;
    }

    public function set light(value:Light):void {
        _light = value;
        _light.nodeName = _name;
        setANEvalue("light", value);
    }

    public function get physicsBody():PhysicsBody {
        return _physicsBody;
    }

    public function set physicsBody(value:PhysicsBody):void {
        _physicsBody = value;
        _physicsBody.nodeName = _name;
        setANEvalue("physicsBody", value);
    }

    public function get geometry():* {
        return _geometry;
    }

    public function set geometry(value:*):void {
        _geometry = value;
    }

    public function set childNodes(value:Vector.<Node>):void {
        _childNodes = value;
    }

    /** @private */
    public function get isModel():Boolean {
        return _isModel;
    }

    /** @private */
    public function set isModel(value:Boolean):void {
        _isModel = value;
        for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
            _childNodes[i].isModel = true;
        }
    }

    /** @private */
    public function set isDAE(isDAE:Boolean):void {
        _isDAE = isDAE;
        for (var i:int = 0, l:int = _childNodes.length; i < l; ++i) {
            _childNodes[i].isDAE = true;
        }
    }

    /** @private */
    public function get isDAE():Boolean {
        return _isDAE;
    }

    //TODO
//    public function clone():Node {
//        return clone of this with prop 'clones' set to name of this
//    }

    /** Determines if the node is rendered in shadow maps.
     * @default true */
    public function get castsShadow():Boolean {
        return _castsShadow;
    }

    public function set castsShadow(value:Boolean):void {
        if (value == _castsShadow) return;
        _castsShadow = value;
        setANEvalue("castsShadow", value);
    }

    public function get categoryBitMask():int {
        return _categoryBitMask;
    }

    public function set categoryBitMask(value:int):void {
        if (value == _categoryBitMask) return;
        _categoryBitMask = value;
        setANEvalue("categoryBitMask", value);
    }
}
}
