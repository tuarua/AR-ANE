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
import com.tuarua.ARANEContext;
import com.tuarua.arkit.raycast.RaycastQuery;
import com.tuarua.arkit.touch.ARHitTestResult;
import com.tuarua.arkit.touch.HitTestOptions;
import com.tuarua.arkit.touch.HitTestResult;
import com.tuarua.fre.ANEError;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

public class AR3DView {
    /** private */
    private var _isInited:Boolean = false;
    private var _session:Session = new Session();
    private var _debugOptions:Array = [];
    private var _autoenablesDefaultLighting:Boolean = false;
    private var _automaticallyUpdatesLighting:Boolean = true;
    private var _showsStatistics:Boolean = false;
    private var _antialiasingMode:uint = AntialiasingMode.none;
    private var _scene:Scene = new Scene();
    private var _camera:Camera = new Camera("rootScene");
    private var _focusSquare:FocusSquare = new FocusSquare();
    private var _rendersMotionBlur:Boolean;

    /** private */
    public function AR3DView() {
    }

    /** Initialise the ARSCN view.
     * @param frame
     * @param mask An Optional bitmapdata which masks the airView. This allows us to use our AIR stage as UI over
     * the ARKit view
     * @return */
    public function init(frame:Rectangle = null, mask:BitmapData = null):void {
        var ret:* = ARANEContext.context.call("ar3dview_init", frame, _debugOptions, _autoenablesDefaultLighting,
                _automaticallyUpdatesLighting, _showsStatistics, _antialiasingMode, _scene.lightingEnvironment,
                _scene.physicsWorld, _camera, _focusSquare, mask);
        if (ret is ANEError) throw ret as ANEError;
        _isInited = true;
        _focusSquare.isInited = true;
        _scene.init();
    }

    public function dispose():void {
        _isInited = false;
        _debugOptions = [];
        _session = new Session();
        _autoenablesDefaultLighting = false;
        _automaticallyUpdatesLighting = true;
        _showsStatistics = false;
        _antialiasingMode = AntialiasingMode.none;
        _scene = new Scene();
        _camera = new Camera("rootScene");
        _focusSquare = new FocusSquare();
        var ret:* = ARANEContext.context.call("ar3dview_dispose");
        if (ret is ANEError) throw ret as ANEError;
        _isInited = false;
    }

    public function node(anchor:Anchor):Node {
        if (_isInited) {
            var ret:* = ARANEContext.context.call("ar3dview_node", anchor.id);
            if (ret is ANEError) throw ret as ANEError;
            return ret as Node;
        }
        return null;
    }

    // TODO
//    public function anchor(node:Node):Anchor {
//        if (_isInited) {
//            var ret:* = ARANEContext.context.call("getAnchorFromNode", node);
//            if (ret is ANEError) throw ret as ANEError;
//            return theRet as Anchor;
//        }
//        return null;
//    }

    public function get session():Session {
        return _session;
    }

    public function get debugOptions():Array {
        return _debugOptions;
    }

    public function set debugOptions(value:Array):void {
        _debugOptions = value;
        if (_isInited) {
            var ret:* = ARANEContext.context.call("ar3dview_debugOptions", _debugOptions);
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    /** Specifies whether the receiver should automatically light up scenes that have no light source.
     *
     * <p>When enabled, a diffuse light is automatically added and placed while rendering scenes that
     * have no light or only ambient lights.</p>
     *
     * @default false*/
    public function get autoenablesDefaultLighting():Boolean {
        return _autoenablesDefaultLighting;
    }

    public function set autoenablesDefaultLighting(value:Boolean):void {
        if (value == _autoenablesDefaultLighting) return;
        _autoenablesDefaultLighting = value;
        setANEvalue("autoenablesDefaultLighting", value);
    }

    /** Determines whether the view will update the scene’s lighting.
     * @default true */
    public function get automaticallyUpdatesLighting():Boolean {
        return _automaticallyUpdatesLighting;
    }

    public function set automaticallyUpdatesLighting(value:Boolean):void {
        if (value == _automaticallyUpdatesLighting) return;
        _automaticallyUpdatesLighting = value;
        setANEvalue("automaticallyUpdatesLighting", value);
    }

    /** Determines whether the receiver should display statistics info like FPS.
     * <p>When set to true, statistics are displayed in a overlay on top of the rendered scene.</p>
     * @default false */

    public function get showsStatistics():Boolean {
        return _showsStatistics;
    }

    public function set showsStatistics(value:Boolean):void {
        if (value == _showsStatistics) return;
        _showsStatistics = value;
        setANEvalue("showsStatistics", value);
    }

    /**
     * Determines whether view renders motion blur.
     * <p> When set, the view will automatically add motion blur to rendered
     * content that matches the motion blur of the camera stream.</p>
     * Overwrites Camera's motionBlurIntensity property. Disabled by default.
     * iOS 13.0+
     */
    public function get rendersMotionBlur():Boolean {
        return _rendersMotionBlur;
    }

    public function set rendersMotionBlur(value:Boolean):void {
        if (value == _rendersMotionBlur) return;
        _rendersMotionBlur = value;
        setANEvalue("rendersMotionBlur", value);
    }

    /**
     * Creates a raycast query originating from the point on view, aligned along the center of the field of view of
     * the camera.
     * <p>A 2D point in the view's coordinate space and the frame camera's field of view is used to create a ray in
     * the 3D cooridnate space originating at the point.</p>
     * @param point A point in the view’s coordinate system.
     * @param target Type of target where the ray should terminate.
     * @param alignment Alignment of the target.
     */
    public function raycastQuery(point:Point, target:int, alignment:int):RaycastQuery {
        if (!_isInited) return null;
        var ret:* = ARANEContext.context.call("ar3dview_raycastQuery", point, target, alignment);
        if (ret is ANEError) throw ret as ANEError;
        return ret as RaycastQuery;
    }

    /** @private */
    private function setANEvalue(name:String, value:*):void {
        if (!_isInited) return;
        var ret:* = ARANEContext.context.call("ar3dview_setProp", name, value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** @private */
    private function initCheck():void {
        if (!_isInited) {
            throw new Error("You need to init first");
        }
    }

    /** @default AntialiasingMode.none */
    public function get antialiasingMode():uint {
        return _antialiasingMode;
    }

    public function set antialiasingMode(value:uint):void {
        _antialiasingMode = value;
        setANEvalue("antialiasingMode", value);
    }

    /** Searches the current frame for objects corresponding to a point in the view.
     * <p>A 2D point in the view’s coordinate space can refer to any point along a line segment in
     * the 3D coordinate space. Hit-testing is the process of finding objects in the world located
     * along this line segment.</p>
     * @param touchPoint A point in the view’s coordinate system.
     * @param options
     * @return */
    public function hitTest(touchPoint:Point, options:HitTestOptions = null):HitTestResult {
        initCheck();
        var ret:* = ARANEContext.context.call("ar3dview_hitTest", touchPoint, options);
        if (ret is ANEError) throw ret as ANEError;
        return ret as HitTestResult;
    }

    /** Searches the current frame for objects corresponding to a point in the view.
     * <p>A 2D point in the view’s coordinate space can refer to any point along a line segment in
     * the 3D coordinate space. Hit-testing is the process of finding objects in the world located
     * along this line segment.</p>
     * @param touchPoint A point in the view’s coordinate system.
     * @param types The types of results to search for.
     * @return */
    public function hitTest3D(touchPoint:Point, types:Array):ARHitTestResult {
        initCheck();
        var ret:* = ARANEContext.context.call("ar3dview_hitTest3D", touchPoint, types);
        if (ret is ANEError) throw ret as ANEError;
        return ret as ARHitTestResult;
    }

    public function isNodeInsidePointOfView(node:Node):Boolean {
        initCheck();
        var ret:* = ARANEContext.context.call("ar3dview_isNodeInsidePointOfView", node.name);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

//    public function get light():Light {
//        return _light;
//    }
//
//    public function set light(value:Light):void {
//        _light = value;
//        _light.nodeId = "root";
//        setANEvalue("light", value);
//    }
    public function get scene():Scene {
        return _scene;
    }

    public function get camera():Camera {
        return _camera;
    }

    public function get focusSquare():FocusSquare {
        return _focusSquare;
    }

    public function set focusSquare(value:FocusSquare):void {
        _focusSquare = value;
    }
}
}
