package {
import com.tuarua.ARKit;
import com.tuarua.arkit.BodyTrackingConfiguration;
import com.tuarua.arkit.FrameSemantics;
import com.tuarua.arkit.ImageTrackingConfiguration;
import com.tuarua.arkit.ObjectScanningConfiguration;
import com.tuarua.arkit.PositionalTrackingConfiguration;
import com.tuarua.arkit.WorldTrackingConfiguration;
import com.tuarua.arkit.camera.TrackingState;
import com.tuarua.arkit.camera.TrackingStateReason;
import com.tuarua.arkit.events.CameraTrackingEvent;
import com.tuarua.arkit.events.SessionEvent;
import com.tuarua.arkit.permissions.PermissionEvent;
import com.tuarua.arkit.permissions.PermissionStatus;

import flash.desktop.NativeApplication;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;

import starling.core.Starling;
import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.SimpleButton;
import views.examples.*;

public class StarlingRoot extends Sprite {
    private var btnClose:SimpleButton = new SimpleButton("Close");
    private var btnBasic:SimpleButton = new SimpleButton("Apple Basic Sample");
    private var btnShapes:SimpleButton = new SimpleButton("Shapes");
    private var btnAnimation:SimpleButton = new SimpleButton("Animation");
    private var btnPhysics:SimpleButton = new SimpleButton("Physics");
    private var btnPlaneDetection:SimpleButton = new SimpleButton("Plane Detection");
    private var btnGestures:SimpleButton = new SimpleButton("Gestures");
    private var btnPBR:SimpleButton = new SimpleButton("Photo Based Rendering");
    private var btnModelDAE:SimpleButton = new SimpleButton("Model from .dae");
    private var btnRemote:SimpleButton = new SimpleButton("Remote Control Model");
    private var btnFocusSquare:SimpleButton = new SimpleButton("Focus Square");
    private var btnImageDetection:SimpleButton = new SimpleButton("Image Detection");
    private var btnObjectDetection:SimpleButton = new SimpleButton("Object Detection");
    private var upArrow:Image = new Image(Assets.getAtlas().getTexture("up-arrow"));
    private var downArrow:Image = new Image(Assets.getAtlas().getTexture("down-arrow"));
    private var btnSave:SimpleButton = new SimpleButton("Save World Map");

    private var menuContainer:Sprite = new Sprite();
    private var exampleButtonsContainer:Sprite = new Sprite();

    private var arkit:ARKit;

    private var basicExample:AppleBasicExample;
    private var shapesExample:ShapesExample;
    private var animationExample:AnimationExample;
    private var physicsExample:PhysicsExample;
    private var planeDetectionExample:PlaneDetectionExample;
    private var gestureExample:GestureExample;
    private var photoBasedExample:PhotoBasedExample;
    private var daeModelExample:DaeModelExample;
    private var remoteControlExample:RemoteControlExample;
    private var focusSquareExample:FocusSquareExample;
    private var imageDetectionExample:ImageDetectionExample;
    private var objectDetectionExample:ObjectDetectionExample;
    private var screenMasks:Dictionary = new Dictionary();

    private var selectedExample:uint = 0;

    private static const GAP:int = 70;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        arkit = ARKit.shared();
        if (!arkit.isSupported) {
            trace("ARKIT is NOT Supported on this device");
            return;
        }
        ARKit.displayLogging = true;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(SessionEvent.ERROR, onSessionError);
        arkit.addEventListener(SessionEvent.INTERRUPTED, onSessionInterrupted);
        arkit.addEventListener(SessionEvent.INTERRUPTION_ENDED, onSessionInterruptionEnded);
        arkit.addEventListener(PermissionEvent.STATUS_CHANGED, onPermissionsStatus);
        arkit.requestPermissions();

        trace("BodyTrackingConfiguration.isSupported", BodyTrackingConfiguration.isSupported);
        trace("PositionalTrackingConfiguration.isSupported", PositionalTrackingConfiguration.isSupported);
        trace("ImageTrackingConfiguration.isSupported", ImageTrackingConfiguration.isSupported);
        trace("ObjectScanningConfiguration.isSupported", ObjectScanningConfiguration.isSupported);
        trace("WorldTrackingConfiguration.supportsUserFaceTracking", WorldTrackingConfiguration.supportsUserFaceTracking);
        trace("WorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation)", WorldTrackingConfiguration.supportsFrameSemantics(FrameSemantics.personSegmentation));
    }


    private function initMenu():void {
        basicExample = new AppleBasicExample(arkit);
        shapesExample = new ShapesExample(arkit);
        animationExample = new AnimationExample(arkit);
        physicsExample = new PhysicsExample(arkit);
        gestureExample = new GestureExample(arkit);
        photoBasedExample = new PhotoBasedExample(arkit);
        daeModelExample = new DaeModelExample(arkit);
        remoteControlExample = new RemoteControlExample(arkit, upArrow, downArrow);
        focusSquareExample = new FocusSquareExample(arkit);
        imageDetectionExample = new ImageDetectionExample(arkit);
        objectDetectionExample = new ObjectDetectionExample(arkit);

        btnClose.x = btnObjectDetection.x = btnImageDetection.x = btnFocusSquare.x
                = btnRemote.x = btnModelDAE.x = btnPBR.x = btnGestures.x = btnPlaneDetection.x
                = btnPhysics.x = btnAnimation.x = btnShapes.x = btnBasic.x = (stage.stageWidth - 200) * 0.5;

        btnClose.y = btnBasic.y = GAP;
        btnShapes.y = btnBasic.y + GAP;
        btnAnimation.y = btnShapes.y + GAP;
        btnPhysics.y = btnAnimation.y + GAP;
        btnPlaneDetection.y = btnPhysics.y + GAP;
        btnGestures.y = btnPlaneDetection.y + GAP;
        btnPBR.y = btnGestures.y + GAP;
        btnModelDAE.y = btnPBR.y + GAP;
        btnRemote.y = btnModelDAE.y + GAP;
        btnFocusSquare.y = btnRemote.y + GAP;
        btnImageDetection.y = btnFocusSquare.y + GAP;
        btnObjectDetection.y = btnImageDetection.y + GAP;

        btnSave.x = (stage.stageWidth - 200) * 0.5;
        btnSave.y = btnClose.y + GAP;


        btnBasic.addEventListener(TouchEvent.TOUCH, onBasicClick);
        btnShapes.addEventListener(TouchEvent.TOUCH, onShapesClick);
        btnAnimation.addEventListener(TouchEvent.TOUCH, onAnimationClick);
        btnPhysics.addEventListener(TouchEvent.TOUCH, onPhysicsClick);
        btnPlaneDetection.addEventListener(TouchEvent.TOUCH, onPlaneDetectionClick);
        btnGestures.addEventListener(TouchEvent.TOUCH, onGesturesClick);
        btnPBR.addEventListener(TouchEvent.TOUCH, onPhotoBasedClick);
        btnModelDAE.addEventListener(TouchEvent.TOUCH, onDaeModelClick);
        btnRemote.addEventListener(TouchEvent.TOUCH, onRemoteClick);
        btnFocusSquare.addEventListener(TouchEvent.TOUCH, onFocusSquareClick);
        btnImageDetection.addEventListener(TouchEvent.TOUCH, onImageDetectionClick);
        btnObjectDetection.addEventListener(TouchEvent.TOUCH, onObjectDetectionClick);
        btnClose.addEventListener(TouchEvent.TOUCH, onCloseClick);

        menuContainer.addChild(btnBasic);
        menuContainer.addChild(btnShapes);
        menuContainer.addChild(btnAnimation);
        menuContainer.addChild(btnPhysics);
        menuContainer.addChild(btnPlaneDetection);
        menuContainer.addChild(btnGestures);
        menuContainer.addChild(btnPBR);
        menuContainer.addChild(btnModelDAE);
        menuContainer.addChild(btnRemote);
        menuContainer.addChild(btnFocusSquare);
        if (arkit.iosVersion >= 11.3) {
            menuContainer.addChild(btnImageDetection);
        }
        if (arkit.iosVersion >= 12.0) {
            menuContainer.addChild(btnObjectDetection);
        }

        planeDetectionExample = new PlaneDetectionExample(arkit, (arkit.iosVersion >= 12.0) ? btnSave : null);

        addChild(menuContainer);

        exampleButtonsContainer.addChild(btnClose);
        exampleButtonsContainer.visible = false;
        addChild(exampleButtonsContainer);
    }

    private function addCloseButtonMask():void {
        menuContainer.visible = false;
        btnClose.visible = true;
        exampleButtonsContainer.visible = true;
    }

    private function onRemoteClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRemote);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 8;
            addCloseButtonMask();
            exampleButtonsContainer.addChild(upArrow);
            exampleButtonsContainer.addChild(downArrow);
            remoteControlExample.run(getScreenMask("remote"));
        }
    }

    private function onFocusSquareClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnFocusSquare);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 9;
            addCloseButtonMask();
            focusSquareExample.run(getScreenMask("basic"));
        }
    }

    private function onDaeModelClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnModelDAE);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 7;
            addCloseButtonMask();
            daeModelExample.run(getScreenMask("basic"));
        }
    }

    private function onPhotoBasedClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPBR);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 6;
            addCloseButtonMask();
            photoBasedExample.run(getScreenMask("basic"));
        }
    }

    private function onGesturesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGestures);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 5;
            addCloseButtonMask();
            gestureExample.run(getScreenMask("basic"));
        }
    }

    private function onPlaneDetectionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPlaneDetection);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 4;
            addCloseButtonMask();
            exampleButtonsContainer.addChild(btnSave);
            planeDetectionExample.run(getScreenMask("plane"));
        }
    }

    private function onPhysicsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPhysics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 3;
            addCloseButtonMask();
            physicsExample.run(getScreenMask("basic"));
        }
    }


    private function onBasicClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBasic);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 0;
            addCloseButtonMask();
            basicExample.run(getScreenMask("basic"));
        }
    }

    private function onShapesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShapes);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 1;
            addCloseButtonMask();
            shapesExample.run(getScreenMask("basic"));
        }
    }

    private function onAnimationClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnimation);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 2;
            addCloseButtonMask();
            animationExample.run(getScreenMask("basic"));
        }
    }

    private function onImageDetectionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnImageDetection);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 10;
            addCloseButtonMask();
            imageDetectionExample.run(getScreenMask("basic"));
        }
    }

    private function onObjectDetectionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnObjectDetection);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 11;
            addCloseButtonMask();
            objectDetectionExample.run(getScreenMask("basic"));
        }
    }

    private function getScreenMask(forScreen:String):BitmapData {
        if (screenMasks[forScreen]) return screenMasks[forScreen];
        var maskBmd:BitmapData = new BitmapData(Starling.current.nativeStage.fullScreenWidth,
                Starling.current.nativeStage.fullScreenHeight, true, 0x00FFFFFF); //the full size mask

        var sf:Number = Starling.current.contentScaleFactor;
        var spriteBmd:BitmapData = new BitmapData(exampleButtonsContainer.width * sf,
                exampleButtonsContainer.height * sf, true, 0xFFFFFFFF);
        exampleButtonsContainer.drawToBitmapData(spriteBmd);
        maskBmd.copyPixels(spriteBmd, spriteBmd.rect,
                new Point(exampleButtonsContainer.bounds.x * sf, exampleButtonsContainer.bounds.y * sf));
        var bmd:BitmapData = new Bitmap(maskBmd).bitmapData;
        screenMasks[forScreen] = bmd;
        return bmd;
    }

    private function onCloseClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnClose);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            switch (selectedExample) {
                case 0:
                    basicExample.dispose();
                    break;
                case 1:
                    shapesExample.dispose();
                    break;
                case 2:
                    animationExample.dispose();
                    break;
                case 3:
                    physicsExample.dispose();
                    break;
                case 4:
                    planeDetectionExample.dispose();
                    break;
                case 5:
                    gestureExample.dispose();
                    break;
                case 6:
                    photoBasedExample.dispose();
                    break;
                case 7:
                    daeModelExample.dispose();
                    break;
                case 8:
                    remoteControlExample.dispose();
                    exampleButtonsContainer.removeChild(upArrow);
                    exampleButtonsContainer.removeChild(downArrow);
                    break;
                case 9:
                    focusSquareExample.dispose();
                    break;
                case 10:
                    imageDetectionExample.dispose();
                    break;
                case 11:
                    objectDetectionExample.dispose();
                    break;
            }
            exampleButtonsContainer.visible = false;
            menuContainer.visible = true;
        }

    }

    private function onCameraTrackingStateChange(event:CameraTrackingEvent):void {
        switch (event.state) {
            case TrackingState.notAvailable:
                arkit.appendDebug("Tracking:Not available");
                break;
            case TrackingState.normal:
                arkit.appendDebug("Tracking:normal");
                break;
            case TrackingState.limited:
                switch (event.reason) {
                    case TrackingStateReason.excessiveMotion:
                        arkit.appendDebug("Tracking:limited - excessive Motion");
                        break;
                    case TrackingStateReason.initializing:
                        arkit.appendDebug("Tracking:limited - initializing");
                        break;
                    case TrackingStateReason.insufficientFeatures:
                        arkit.appendDebug("Tracking:limited - insufficient Features");
                        break;
                    case TrackingStateReason.relocalizing:
                        arkit.appendDebug("Tracking:limited - relocalizing");
                        break;
                }
                break;
        }
    }

    private function onSessionInterrupted(event:SessionEvent):void {
        arkit.appendDebug("Session:Interrupted");
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }

    private function onSessionInterruptionEnded(event:SessionEvent):void {
        arkit.appendDebug("Session:Interruption Ended");
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }

    private function onSessionError(event:SessionEvent):void {
        arkit.appendDebug("Session:Error" + event.error);
        // Present an error message to the user
    }

    private function onPermissionsStatus(event:PermissionEvent):void {
        if (event.status == PermissionStatus.ALLOWED) {
            initMenu();
        } else if (event.status == PermissionStatus.NOT_DETERMINED) {
        } else {
            trace("Allow camera for ARKit usage");
        }
    }

    private function onExiting(event:Event):void {
        ARKit.dispose();
    }

}
}