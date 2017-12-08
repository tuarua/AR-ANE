package com.tuarua.arane.materials {
import com.tuarua.utils.GUID;

public class Material {
    private var _geometryId:String;
    private var _id:String;
    private var _diffuse:MaterialProperty = new MaterialProperty();
    private var _ambient:MaterialProperty = new MaterialProperty();
    private var _specular:MaterialProperty = new MaterialProperty();
    private var _emission:MaterialProperty = new MaterialProperty();
    private var _transparent:MaterialProperty = new MaterialProperty();
    private var _reflective:MaterialProperty = new MaterialProperty();
    private var _multiply:MaterialProperty = new MaterialProperty();
    private var _normal:MaterialProperty = new MaterialProperty();
    private var _displacement:MaterialProperty = new MaterialProperty();
    private var _ambientOcclusion:MaterialProperty = new MaterialProperty();
    private var _selfIllumination:MaterialProperty = new MaterialProperty();
    private var _metalness:MaterialProperty = new MaterialProperty();
    private var _roughness:MaterialProperty = new MaterialProperty();
    private var _shininess:Number = 1.0;
    private var _transparency:Number = 1.0;
    private var _lightingModel:String = "phong";
    private var _isLitPerPixel:Boolean = true;
    private var _isDoubleSided:Boolean = false;
    private var _fillMode:int = 0;
    private var _cullMode:int = 0;
    private var _transparencyMode:int = 4;
    private var _locksAmbientWithDiffuse:Boolean = true;
    private var _writesToDepthBuffer:Boolean = true;
    private var _colorBufferWriteMask:int = ColorMask.ALL;
    private var _readsFromDepthBuffer:Boolean = true;
    private var _fresnelExponent:Number = 0.0;
    private var _blendMode:int = BlendMode.ALPHA;

    public function Material() {
        this._id = GUID.create();
    }

    public function get id():String {
        return _id;
    }

    public function get diffuse():MaterialProperty {
        return _diffuse;
    }

    public function get ambient():MaterialProperty {
        return _ambient;
    }

    public function get specular():MaterialProperty {
        return _specular;
    }

    public function get emission():MaterialProperty {
        return _emission;
    }

    public function get transparent():MaterialProperty {
        return _transparent;
    }

    public function get reflective():MaterialProperty {
        return _reflective;
    }

    public function get multiply():MaterialProperty {
        return _multiply;
    }

    public function get normal():MaterialProperty {
        return _normal;
    }

    public function get displacement():MaterialProperty {
        return _displacement;
    }

    public function get ambientOcclusion():MaterialProperty {
        return _ambientOcclusion;
    }

    public function get selfIllumination():MaterialProperty {
        return _selfIllumination;
    }

    public function get metalness():MaterialProperty {
        return _metalness;
    }

    public function get roughness():MaterialProperty {
        return _roughness;
    }

    public function get shininess():Number {
        return _shininess;
    }

    public function set shininess(value:Number):void {
        _shininess = value;
    }

    public function get transparency():Number {
        return _transparency;
    }

    public function set transparency(value:Number):void {
        _transparency = value;
    }

    public function get lightingModel():String {
        return _lightingModel;
    }

    public function set lightingModel(value:String):void {
        _lightingModel = value;
    }

    public function get isLitPerPixel():Boolean {
        return _isLitPerPixel;
    }

    public function set isLitPerPixel(value:Boolean):void {
        _isLitPerPixel = value;
    }

    public function get isDoubleSided():Boolean {
        return _isDoubleSided;
    }

    public function set isDoubleSided(value:Boolean):void {
        _isDoubleSided = value;
    }

    public function get fillMode():int {
        return _fillMode;
    }

    public function set fillMode(value:int):void {
        _fillMode = value;
    }

    public function get cullMode():int {
        return _cullMode;
    }

    public function set cullMode(value:int):void {
        _cullMode = value;
    }

    public function get transparencyMode():int {
        return _transparencyMode;
    }

    public function set transparencyMode(value:int):void {
        _transparencyMode = value;
    }

    public function get locksAmbientWithDiffuse():Boolean {
        return _locksAmbientWithDiffuse;
    }

    public function set locksAmbientWithDiffuse(value:Boolean):void {
        _locksAmbientWithDiffuse = value;
    }

    public function get writesToDepthBuffer():Boolean {
        return _writesToDepthBuffer;
    }

    public function set writesToDepthBuffer(value:Boolean):void {
        _writesToDepthBuffer = value;
    }

    public function get colorBufferWriteMask():int {
        return _colorBufferWriteMask;
    }

    public function set colorBufferWriteMask(value:int):void {
        _colorBufferWriteMask = value;
    }

    public function get readsFromDepthBuffer():Boolean {
        return _readsFromDepthBuffer;
    }

    public function set readsFromDepthBuffer(value:Boolean):void {
        _readsFromDepthBuffer = value;
    }

    public function get fresnelExponent():Number {
        return _fresnelExponent;
    }

    public function set fresnelExponent(value:Number):void {
        _fresnelExponent = value;
    }

    public function get blendMode():int {
        return _blendMode;
    }

    public function set blendMode(value:int):void {
        _blendMode = value;
    }

    public function get geometryId():String {
        return _geometryId;
    }

    public function set geometryId(value:String):void {
        _geometryId = value;
    }
}
}
