package {
import com.tuarua.ARANE;
import com.tuarua.arane.camera.TrackingState;
import com.tuarua.arane.camera.TrackingStateReason;
import com.tuarua.arane.display.NativeButton;
import com.tuarua.arane.events.CameraTrackingEvent;
import com.tuarua.arane.events.SessionEvent;
import com.tuarua.arane.permissions.PermissionEvent;
import com.tuarua.arane.permissions.PermissionStatus;

import flash.display.Bitmap;
import flash.events.MouseEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import views.SimpleButton;
import views.examples.*;
import views.examples.RemoteControlExample;

public class StarlingRoot extends Sprite {
    [Embed(source="close.png")]
    private static const CloseButton:Class;

    private var closeButtonBmp:Bitmap = new CloseButton() as Bitmap;
    private var closeButton:NativeButton = new NativeButton(closeButtonBmp.bitmapData);

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

    private var arkit:ARANE;

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

    private var selectedExample:uint = 0;

    public function StarlingRoot() {
        closeButton.addEventListener(MouseEvent.CLICK, onCloseClick);
    }

    public function start(assets:AssetManager):void {
        arkit = ARANE.arkit;
        if (!arkit.isSupported) {
            trace("ARKIT is NOT Supported on this device");
            return;
        }
        ARANE.displayLogging = true;
        arkit.addEventListener(CameraTrackingEvent.STATE_CHANGED, onCameraTrackingStateChange);
        arkit.addEventListener(SessionEvent.ERROR, onSessionError);
        arkit.addEventListener(SessionEvent.INTERRUPTED, onSessionInterrupted);
        arkit.addEventListener(SessionEvent.INTERRUPTION_ENDED, onSessionInterruptionEnded);
        arkit.addEventListener(PermissionEvent.STATUS_CHANGED, onPermissionsStatus);
        arkit.requestPermissions();
    }


    private function initMenu():void {
        basicExample = new AppleBasicExample(arkit);
        shapesExample = new ShapesExample(arkit);
        animationExample = new AnimationExample(arkit);
        physicsExample = new PhysicsExample(arkit);
        planeDetectionExample = new PlaneDetectionExample(arkit);
        gestureExample = new GestureExample(arkit);
        photoBasedExample = new PhotoBasedExample(arkit);
        daeModelExample = new DaeModelExample(arkit);
        remoteControlExample = new RemoteControlExample(arkit);
        focusSquareExample = new FocusSquareExample(arkit);

        btnFocusSquare.x = btnRemote.x = btnModelDAE.x = btnPBR.x = btnGestures.x = btnPlaneDetection.x =
                btnPhysics.x = btnAnimation.x = btnShapes.x = btnBasic.x = (stage.stageWidth - 200) * 0.5;
        btnBasic.y = 100;
        btnShapes.y = 180;
        btnAnimation.y = 260;
        btnPhysics.y = 340;
        btnPlaneDetection.y = 420;
        btnGestures.y = 500;
        btnPBR.y = 580;

        btnModelDAE.y = 660;
        btnRemote.y = 740;
        btnFocusSquare.y = 820;

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

        addChild(btnBasic);
        addChild(btnShapes);
        addChild(btnAnimation);
        addChild(btnPhysics);
        addChild(btnPlaneDetection);
        addChild(btnGestures);
        addChild(btnPBR);
        addChild(btnModelDAE);
        addChild(btnRemote);
        addChild(btnFocusSquare);

    }

    private function onRemoteClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRemote);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 8;
            remoteControlExample.run();
            addCloseButton();
        }
    }

    private function onFocusSquareClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnFocusSquare);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 9;
            focusSquareExample.run();
            addCloseButton();
        }
    }

    private function onDaeModelClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnModelDAE);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 7;
            daeModelExample.run();
            addCloseButton();
        }
    }

    private function onPhotoBasedClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPBR);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 6;
            photoBasedExample.run();
            addCloseButton();
        }
    }

    private function onGesturesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGestures);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 5;
            gestureExample.run();
            addCloseButton();
        }
    }

    private function onPlaneDetectionClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPlaneDetection);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 4;
            planeDetectionExample.run();
            addCloseButton();
        }
    }

    private function onPhysicsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPhysics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 3;
            physicsExample.run();
            addCloseButton();
        }
    }

    private function onBasicClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBasic);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 0;
            basicExample.run();
            addCloseButton();
        }
    }

    private function onShapesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShapes);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 1;
            shapesExample.run();
            addCloseButton();
        }
    }

    private function onAnimationClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnimation);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            selectedExample = 2;
            animationExample.run();
            addCloseButton();
        }
    }

    private function addCloseButton():void {
        arkit.addChild(closeButton);
    }

    private function onCloseClick(event:MouseEvent):void {
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
                break;
            case 9:
                focusSquareExample.dispose();
                break;
        }

        arkit.removeChild(closeButton);
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
            trace("Allow camera for ARKit usuage");
        }
    }

}
}