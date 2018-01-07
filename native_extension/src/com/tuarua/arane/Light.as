package com.tuarua.arane {
import com.tuarua.ARANEContext;
import com.tuarua.arane.materials.MaterialProperty;
import com.tuarua.fre.ANEError;
import com.tuarua.utils.GUID;
[RemoteClass(alias="com.tuarua.arane.Light")]
public class Light {
    private var _name:String;
    public var nodeName:String;
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
    private var _gobo:MaterialProperty;
    private var _iesProfileURL:String;
    private var _categoryBitMask:int = -1;
    private var _spotOuterAngle:Number = 45;

    //noinspection ReservedWordAsName
    public function Light(type:String = LightType.omni) {
        this._type = type;
        this._name = GUID.create();
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
        setANEvalue("type", value);
    }

    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        _color = value;
        setANEvalue("color", value);
    }

    public function get temperature():Number {
        return _temperature;
    }

    public function set temperature(value:Number):void {
        _temperature = value;
        setANEvalue("temperature", value);
    }

    public function get intensity():Number {
        return _intensity;
    }

    public function set intensity(value:Number):void {
        _intensity = value;
        setANEvalue("intensity", value);
    }

    public function get castsShadow():Boolean {
        return _castsShadow;
    }

    public function set castsShadow(value:Boolean):void {
        _castsShadow = value;
        setANEvalue("castsShadow", value);
    }

    public function get shadowRadius():Number {
        return _shadowRadius;
    }

    public function set shadowRadius(value:Number):void {
        _shadowRadius = value;
        setANEvalue("shadowRadius", value);
    }

    public function get shadowColor():uint {
        return _shadowColor;
    }

    public function set shadowColor(value:uint):void {
        _shadowColor = value;
        setANEvalue("shadowColor", value);
    }

    public function get shadowMapSize():Array {
        return _shadowMapSize;
    }

    public function set shadowMapSize(value:Array):void {
        _shadowMapSize = value;
        setANEvalue("shadowMapSize", value);
    }

    public function get shadowSampleCount():int {
        return _shadowSampleCount;
    }

    public function set shadowSampleCount(value:int):void {
        _shadowSampleCount = value;
        setANEvalue("shadowSampleCount", value);
    }

    public function get shadowMode():int {
        return _shadowMode;
    }

    public function set shadowMode(value:int):void {
        _shadowMode = value;
        setANEvalue("shadowMode", value);
    }

    public function get shadowBias():Number {
        return _shadowBias;
    }

    public function set shadowBias(value:Number):void {
        _shadowBias = value;
        setANEvalue("shadowBias", value);
    }

    public function get automaticallyAdjustsShadowProjection():Boolean {
        return _automaticallyAdjustsShadowProjection;
    }

    public function set automaticallyAdjustsShadowProjection(value:Boolean):void {
        _automaticallyAdjustsShadowProjection = value;
        setANEvalue("automaticallyAdjustsShadowProjection", value);
    }

    public function get maximumShadowDistance():Number {
        return _maximumShadowDistance;
    }

    public function set maximumShadowDistance(value:Number):void {
        _maximumShadowDistance = value;
        setANEvalue("maximumShadowDistance", value);
    }

    public function get forcesBackFaceCasters():Boolean {
        return _forcesBackFaceCasters;
    }

    public function set forcesBackFaceCasters(value:Boolean):void {
        _forcesBackFaceCasters = value;
        setANEvalue("forcesBackFaceCasters", value);
    }

    public function get sampleDistributedShadowMaps():Boolean {
        return _sampleDistributedShadowMaps;
    }

    public function set sampleDistributedShadowMaps(value:Boolean):void {
        _sampleDistributedShadowMaps = value;
        setANEvalue("sampleDistributedShadowMaps", value);
    }

    public function get shadowCascadeCount():int {
        return _shadowCascadeCount;
    }

    public function set shadowCascadeCount(value:int):void {
        _shadowCascadeCount = value;
        setANEvalue("shadowCascadeCount", value);
    }

    public function get shadowCascadeSplittingFactor():Number {
        return _shadowCascadeSplittingFactor;
    }

    public function set shadowCascadeSplittingFactor(value:Number):void {
        _shadowCascadeSplittingFactor = value;
        setANEvalue("shadowCascadeSplittingFactor", value);
    }

    public function get orthographicScale():Number {
        return _orthographicScale;
    }

    public function set orthographicScale(value:Number):void {
        _orthographicScale = value;
        setANEvalue("orthographicScale", value);
    }

    public function get zNear():Number {
        return _zNear;
    }

    public function set zNear(value:Number):void {
        _zNear = value;
        setANEvalue("zNear", value);
    }

    public function get zFar():Number {
        return _zFar;
    }

    public function set zFar(value:Number):void {
        _zFar = value;
        setANEvalue("zFar", value);
    }

    public function get attenuationStartDistance():Number {
        return _attenuationStartDistance;
    }

    public function set attenuationStartDistance(value:Number):void {
        _attenuationStartDistance = value;
        setANEvalue("attenuationStartDistance", value);
    }

    public function get attenuationEndDistance():Number {
        return _attenuationEndDistance;
    }

    public function set attenuationEndDistance(value:Number):void {
        _attenuationEndDistance = value;
        setANEvalue("attenuationEndDistance", value);
    }

    public function get attenuationFalloffExponent():Number {
        return _attenuationFalloffExponent;
    }

    public function set attenuationFalloffExponent(value:Number):void {
        _attenuationFalloffExponent = value;
        setANEvalue("attenuationFalloffExponent", value);
    }

    public function get spotInnerAngle():Number {
        return _spotInnerAngle;
    }

    public function set spotInnerAngle(value:Number):void {
        _spotInnerAngle = value;
        setANEvalue("spotInnerAngle", value);
    }

    public function get gobo():MaterialProperty {
        return _gobo;
    }

    public function set gobo(value:MaterialProperty):void {
        _gobo = value;
        setANEvalue("gobo", value);
    }

    public function get iesProfileURL():String {
        return _iesProfileURL;
    }

    public function set iesProfileURL(value:String):void {
        _iesProfileURL = value;
        setANEvalue("iesProfileURL", value);
    }

    public function get categoryBitMask():int {
        return _categoryBitMask;
    }

    public function set categoryBitMask(value:int):void {
        _categoryBitMask = value;
        setANEvalue("categoryBitMask", value);
    }

    public function get spotOuterAngle():Number {
        return _spotOuterAngle;
    }

    public function set spotOuterAngle(value:Number):void {
        _spotOuterAngle = value;
        setANEvalue("spotOuterAngle", value);
    }

    public function get name():String {
        return _name;
    }

    private function setANEvalue(name:String, value:*):void {
        if (nodeName) {
            var theRet:* = ARANEContext.context.call("setLightProp", nodeName, name, value);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }
}
}
