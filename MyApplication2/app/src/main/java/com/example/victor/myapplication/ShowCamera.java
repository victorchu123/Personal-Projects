/*
 * This file was created by Victor Chu on 7/20/2014.
 * Description: Deals with creating a camera and maintaining correct orientations.
 */

package com.example.victor.myapplication;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.hardware.Camera;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class ShowCamera extends SurfaceView implements SurfaceHolder.Callback {

    private SurfaceHolder holdMe;
    private Camera theCamera;

    //camera constructor
    public ShowCamera(Context context, Camera camera) {
        super(context);
        theCamera = camera;
        holdMe = getHolder();
        holdMe.addCallback(this);
    }
    //camera autorotate
    public void setCameraDisplayOrientation(ShowCamera activity,
                                            int cameraId, Camera camera) {
        android.hardware.Camera.CameraInfo info =
                new android.hardware.Camera.CameraInfo();
        android.hardware.Camera.getCameraInfo(cameraId, info);
        int rotation = ((Activity) getContext()).getWindowManager().getDefaultDisplay().getRotation();

        int degrees = 0;
        switch (rotation) {
            case Surface.ROTATION_0: degrees = 0; break;
            case Surface.ROTATION_90: degrees = 90; break;
            case Surface.ROTATION_180: degrees = 180; break;
            case Surface.ROTATION_270: degrees = 270; break;
        }

        int result;
        if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            result = (info.orientation + degrees) % 360;
            result = (360 - result) % 360;  // compensate the mirror
        } else {  // back-facing
            result = (info.orientation - degrees + 360) % 360;
        }
        camera.setDisplayOrientation(result);
    }

    //camera autorotate
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height)
    {
        setCameraDisplayOrientation(this, Camera.CameraInfo.CAMERA_FACING_BACK, theCamera);
    }

    //starts camera
    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        try   {
            setCameraDisplayOrientation(this, Camera.CameraInfo.CAMERA_FACING_BACK, theCamera );
            theCamera.setPreviewDisplay(holder);
            theCamera.startPreview();

        } catch (Exception e) {
            e.getMessage();
        }
    }

    //terminates the camera
    @Override
    public void surfaceDestroyed(SurfaceHolder arg0) {
        theCamera.release();
    }

    //camera autorotate
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        //setCameraDisplayOrientation(this, Camera.CameraInfo.CAMERA_FACING_BACK, theCamera );
    }
}
