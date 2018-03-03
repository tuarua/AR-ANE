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

package com.tuarua.arane.lights {
import com.tuarua.ARANEContext;
import com.tuarua.arane.materials.MaterialProperty;
import com.tuarua.deg2rad;
import com.tuarua.fre.ANEError;

[RemoteClass(alias="com.tuarua.arane.lights.Light")]
public class Light {
    private var _name:String;
    public var nodeName:String;
    private var _isDefault:Boolean = true;
    private var _type:String = LightType.omni;
    private var _color:uint = 0xFFFFFFFF;
    private var _temperature:Number = 6500;
    private var _intensity:Number = 1000;
    private var _castsShadow:Boolean = false;
    private var _shadowColor:uint = 0x80000000;
    private var _shadowRadius:Number = 3;
    private var _shadowMapSize:Array = [0, 0];
    private var _shadowSampleCount:int = 0;
    private var _shadowMode:int = ShadowMode.forward;
    private var _shadowBias:Number = 1;
    private var _automaticallyAdjustsShadowProjection:Boolean = true;
    private var _maximumShadowDistance:Number = 100;
    private var _forcesBackFaceCasters:Boolean = false;
    private var _sampleDistributedShadowMaps:Boolean = false;
    private var _shadowCascadeCount:int = 1;
    private var _shadowCascadeSplittingFactor:Number = 0.15;
    private var _orthographicScale:Number = 1;
    private var _zNear:Number = 1;
    private var _zFar:Number = 100;
    private var _attenuationStartDistance:Number = 0;
    private var _attenuationEndDistance:Number = 0;
    private var _attenuationFalloffExponent:Number = 2;
    private var _spotInnerAngle:Number = 0;
    private var _iesProfileURL:String;
    private var _categoryBitMask:int = -1;
    private var _spotOuterAngle:Number = deg2rad(45);

    /** Light represents a light that can be attached to a Node.
     *
     * @param type
     */
    public function Light(type:String = LightType.omni) {
        this._type = type;
        this._name = ARANEContext.context.call("createGUID") as String;
    }

    /** Specifies the receiver's type.
     * @Default LightType.omni */
    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        if (value == _type) return;
        _type = value;
        setANEvalue("type", value);
    }

    /** Specifies the receiver's color.
     * @Default 0xFFFFFFFF */
    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        if (value == _color) return;
        _isDefault = false;
        _color = value;
        setANEvalue("color", value);
    }

    /** Specifies the receiver's temperature.
     * @Default 1000 */
    public function get temperature():Number {
        return _temperature;
    }

    public function set temperature(value:Number):void {
        if (value == _temperature) return;
        _isDefault = false;
        _temperature = value;
        setANEvalue("temperature", value);
    }

    /** Specifies the receiver's temperature.
     *
     * <p>This intensity is used to modulate the light color. When used with a physically-based material,
     * this corresponds to the luminous flux of the light, expressed in lumens (lm).</p>
     *
     * @Default 1000 */
    public function get intensity():Number {
        return _intensity;
    }

    public function set intensity(value:Number):void {
        if (value == _intensity) return;
        _intensity = value;
        setANEvalue("intensity", value);
    }

    /** Determines whether the receiver casts a shadow.
     *
     * <p>Shadows are only supported by spot and directional lights.</p>
     *
     * @Default false */
    public function get castsShadow():Boolean {
        return _castsShadow;
    }

    public function set castsShadow(value:Boolean):void {
        if (value == _castsShadow) return;
        _isDefault = false;
        _castsShadow = value;
        setANEvalue("castsShadow", value);
    }

    /** Specifies the sample radius used to render the receiver’s shadow.
     * @Default 3.0 */
    public function get shadowRadius():Number {
        return _shadowRadius;
    }

    public function set shadowRadius(value:Number):void {
        if (value == _shadowRadius) return;
        _isDefault = false;
        _shadowRadius = value;
        setANEvalue("shadowRadius", value);
    }

    /** Specifies the color of the shadow casted by the receiver.
     * @Default 0x80000000 */
    public function get shadowColor():uint {
        return _shadowColor;
    }

    public function set shadowColor(value:uint):void {
        if (value == _shadowColor) return;
        _isDefault = false;
        _shadowColor = value;
        setANEvalue("shadowColor", value);
    }

    /** Specifies the size of the shadow map.
     *
     * <p>The larger the shadow map is the more precise the shadows are but the slower the computation is.
     * If set to {0,0} the size of the shadow map is automatically chosen.</p>
     *
     * @Default [0, 0] */
    public function get shadowMapSize():Array {
        return _shadowMapSize;
    }

    public function set shadowMapSize(value:Array):void {
        if (value == _shadowMapSize) return;
        _isDefault = false;
        _shadowMapSize = value;
        setANEvalue("shadowMapSize", value);
    }

    /** Specifies the number of sample per fragment to compute the shadow map.
     *
     * <p>when the shadowSampleCount is set to 0, a default sample count is chosen depending on the platform.</p>
     *
     * @Default 0 */
    public function get shadowSampleCount():int {
        return _shadowSampleCount;
    }

    public function set shadowSampleCount(value:int):void {
        if (value == _shadowSampleCount) return;
        _isDefault = false;
        _shadowSampleCount = value;
        setANEvalue("shadowSampleCount", value);
    }

    /** Specified the mode to use to cast shadows.
     * @Default ShadowMode.forward */
    public function get shadowMode():int {
        return _shadowMode;
    }

    public function set shadowMode(value:int):void {
        if (value == _shadowMode) return;
        _isDefault = false;
        _shadowMode = value;
        setANEvalue("shadowMode", value);
    }

    /** Specifies the correction to apply to the shadow map to correct acne artefacts. It is multiplied by an
     * implementation-specific value to create a constant depth offset.
     *
     * @Default 1.0 */
    public function get shadowBias():Number {
        return _shadowBias;
    }

    public function set shadowBias(value:Number):void {
        if (value == _shadowBias) return;
        _isDefault = false;
        _shadowBias = value;
        setANEvalue("shadowBias", value);
    }

    /** Specifies if the shadow map projection should be done automatically or manually by the user.
     * @Default true */
    public function get automaticallyAdjustsShadowProjection():Boolean {
        return _automaticallyAdjustsShadowProjection;
    }

    public function set automaticallyAdjustsShadowProjection(value:Boolean):void {
        if (value == _automaticallyAdjustsShadowProjection) return;
        _isDefault = false;
        _automaticallyAdjustsShadowProjection = value;
        setANEvalue("automaticallyAdjustsShadowProjection", value);
    }

    /** Specifies the maximum distance from the viewpoint from which the shadows for the receiver light won't
     * be computed.
     * @Default 100.0 */
    public function get maximumShadowDistance():Number {
        return _maximumShadowDistance;
    }

    public function set maximumShadowDistance(value:Number):void {
        if (value == _maximumShadowDistance) return;
        _isDefault = false;
        _maximumShadowDistance = value;
        setANEvalue("maximumShadowDistance", value);
    }

    /** Render only back faces of the shadow caster when enabled.
     * @Default false */
    public function get forcesBackFaceCasters():Boolean {
        return _forcesBackFaceCasters;
    }

    public function set forcesBackFaceCasters(value:Boolean):void {
        if (value == _forcesBackFaceCasters) return;
        _isDefault = false;
        _forcesBackFaceCasters = value;
        setANEvalue("forcesBackFaceCasters", value);
    }

    /** Use the sample distribution of the main rendering to better fit the shadow frusta.
     * @Default false */
    public function get sampleDistributedShadowMaps():Boolean {
        return _sampleDistributedShadowMaps;
    }

    public function set sampleDistributedShadowMaps(value:Boolean):void {
        if (value == _sampleDistributedShadowMaps) return;
        _isDefault = false;
        _sampleDistributedShadowMaps = value;
        setANEvalue("sampleDistributedShadowMaps", value);
    }

    /** Specifies the number of distinct shadow maps that will be computed for the receiver light.
     * @Default 1 */
    public function get shadowCascadeCount():int {
        return _shadowCascadeCount;
    }

    public function set shadowCascadeCount(value:int):void {
        if (value == _shadowCascadeCount) return;
        _isDefault = false;
        _shadowCascadeCount = value;
        setANEvalue("shadowCascadeCount", value);
    }

    /** Specifies a factor to interpolate between linear splitting (0) and logarithmic splitting (1)
     * @Default 0.15 */
    public function get shadowCascadeSplittingFactor():Number {
        return _shadowCascadeSplittingFactor;
    }

    public function set shadowCascadeSplittingFactor(value:Number):void {
        if (value == _shadowCascadeSplittingFactor) return;
        _isDefault = false;
        _shadowCascadeSplittingFactor = value;
        setANEvalue("shadowCascadeSplittingFactor", value);
    }

    /** Specifies the orthographic scale used to render from the directional light into the shadow map.
     *
     * <p>This is only applicable for directional lights.</p>
     *
     * @Default 1 */
    public function get orthographicScale():Number {
        return _orthographicScale;
    }

    public function set orthographicScale(value:Number):void {
        if (value == _orthographicScale) return;
        _isDefault = false;
        _orthographicScale = value;
        setANEvalue("orthographicScale", value);
    }

    /** Specifies the minimal distance between the light and the surface to cast shadow on. If a surface is
     * closer to the light than this minimal distance, then the surface won't be shadowed. The near value
     * must be different than zero.
     *
     * @Default 1 */
    public function get zNear():Number {
        return _zNear;
    }

    public function set zNear(value:Number):void {
        if (value == _zNear) return;
        _isDefault = false;
        _zNear = value;
        setANEvalue("zNear", value);
    }

    /** Specifies the maximal distance between the light and a visible surface to cast shadow on. If a surface
     * is further from the light than this maximal distance, then the surface won't be shadowed.
     *
     * @Default 100.0 */
    public function get zFar():Number {
        return _zFar;
    }

    public function set zFar(value:Number):void {
        if (value == _zFar) return;
        _isDefault = false;
        _zFar = value;
        setANEvalue("zFar", value);
    }

    /** The distance at which the attenuation starts (Omni or Spot light types only).
     * @Default 0 */
    public function get attenuationStartDistance():Number {
        return _attenuationStartDistance;
    }

    public function set attenuationStartDistance(value:Number):void {
        if (value == _attenuationStartDistance) return;
        _isDefault = false;
        _attenuationStartDistance = value;
        setANEvalue("attenuationStartDistance", value);
    }

    /** The distance at which the attenuation ends (Omni or Spot light types only).
     * @Default 0 */
    public function get attenuationEndDistance():Number {
        return _attenuationEndDistance;
    }

    public function set attenuationEndDistance(value:Number):void {
        if (value == _attenuationEndDistance) return;
        _isDefault = false;
        _attenuationEndDistance = value;
        setANEvalue("attenuationEndDistance", value);
    }

    /** Specifies the attenuation between the start and end attenuation distances. 0 means a constant
     * attenuation, 1 a linear attenuation and 2 a quadratic attenuation, but any positive value will
     * work (Omni or Spot light types only).
     * @Default 2 */
    public function get attenuationFalloffExponent():Number {
        return _attenuationFalloffExponent;
    }

    public function set attenuationFalloffExponent(value:Number):void {
        if (value == _attenuationFalloffExponent) return;
        _isDefault = false;
        _attenuationFalloffExponent = value;
        setANEvalue("attenuationFalloffExponent", value);
    }

    /** The angle in degrees between the spot direction and the lit element below which the lighting is
     * at full strength.
     * @Default 0 */
    public function get spotInnerAngle():Number {
        return _spotInnerAngle;
    }

    public function set spotInnerAngle(value:Number):void {
        if (value == _spotInnerAngle) return;
        _isDefault = false;
        _spotInnerAngle = value;
        setANEvalue("spotInnerAngle", value);
    }

    /** The angle in degrees between the spot direction and the lit element after which the lighting is
     * at zero strength.
     * @Default 45 degrees */
    public function get spotOuterAngle():Number {
        return _spotOuterAngle;
    }

    public function set spotOuterAngle(value:Number):void {
        if (value == _spotOuterAngle) return;
        _isDefault = false;
        _spotOuterAngle = value;
        setANEvalue("spotOuterAngle", value);
    }

    /** Specifies the IES file from which the shape, direction, and intensity of illumination is determined.
     * @default null */
    public function get iesProfileURL():String {
        return _iesProfileURL;
    }

    public function set iesProfileURL(value:String):void {
        if (value == _iesProfileURL) return;
        _isDefault = false;
        _iesProfileURL = value;
        setANEvalue("iesProfileURL", value);
    }

    /** Determines the node categories that will be lit by the receiver.
     * @default all bits */
    public function get categoryBitMask():int {
        return _categoryBitMask;
    }

    public function set categoryBitMask(value:int):void {
        if (value == _categoryBitMask) return;
        _isDefault = false;
        _categoryBitMask = value;
        setANEvalue("categoryBitMask", value);
    }

    /** The name of the light.*/
    public function get name():String {
        return _name;
    }

    /** @private */
    private function setANEvalue(name:String, value:*):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("setLightProp", nodeName, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    /** @private */
    public function get isDefault():Boolean {
        return _isDefault;
    }
}
}
