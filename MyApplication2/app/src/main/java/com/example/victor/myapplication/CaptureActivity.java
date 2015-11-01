/*
 * This file was created by Victor Chu on 7/20/2014.
 * Description: Deals with capturing a picture.
 */

package com.example.victor.myapplication;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.Toast;

import com.moodstocks.android.MoodstocksError;
import com.moodstocks.android.Scanner;
import com.moodstocks.android.advanced.Image;

import java.io.File;
import java.io.FileOutputStream;


public class CaptureActivity extends Activity {

    private Camera cameraObject;
    private ShowCamera showCamera;
    private Scanner scanner;

    private boolean addToLDB = false;
    private boolean addToSDB = false;
    private boolean isThereFlash;

    //checks if there is a camera on the phone
    public static Camera isCameraAvailiable(){
        Camera object = null;
        try {
            object = Camera.open();
        }
        catch (Exception e){
        }
        return object;
    }

    //main function when picture is taken; returns pop up dialog of picture status
    private PictureCallback capturedIt = new PictureCallback() {

        @Override
        public void onPictureTaken(byte[] data, Camera camera) {

            Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
            if(bitmap==null){
                Toast.makeText(getApplicationContext(), "picture not taken", Toast.LENGTH_SHORT).show();
            }
            else
            {
                Toast.makeText(getApplicationContext(), "picture taken", Toast.LENGTH_SHORT).show();
            }
            Bitmap convertedBitmap = convert(bitmap, Bitmap.Config.ARGB_8888);
            processCustomImage(convertedBitmap);
            CaptureActivity.this.finish();
            cameraObject.release();
        }
    };


    //converts bitmap to 270x480px bitmap
    private Bitmap convert(Bitmap bitmap, Bitmap.Config config) {
        Bitmap convertedBitmap = Bitmap.createBitmap(270, 480, config);
        Canvas canvas = new Canvas(convertedBitmap);
        Paint paint = new Paint();
        paint.setColor(Color.BLACK);
        canvas.drawBitmap(bitmap, 0, 0, paint);
        return convertedBitmap;
    }

    //overrides main activity function; initializes camera
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //sets view to activity_capture.xml

        setContentView(R.layout.activity_capture);

        cameraObject = isCameraAvailiable();
        showCamera = new ShowCamera(this, cameraObject);

        FrameLayout preview = (FrameLayout) findViewById(R.id.camPreview);
        preview.addView(showCamera);
    }

    //takes a picture
    public void snapIt(View view){
        cameraObject.takePicture(null, null, capturedIt);
    }


    // overrides main menu function; makes the menu fit to screen
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.capture, menu);
        return true;
    }
    public void processCustomImage(Bitmap bitmap) {

        // Get the bitmap from the `assets` folder:
        //AssetManager assetManager = this.getAssets();
        //InputStream istr;
        //Bitmap bmp = null;
        //try {
            Log.d("processImage:", "initiated.");
            //istr = assetManager.open("test.jpg");
            //bmp = BitmapFactory.decodeStream(istr);

        /*} catch (IOException e) {
            e.printStackTrace();
        }*/

        // Build the `Image` object:
        Image img = null;
        try {
            img = new Image(bitmap);
            Log.d("processImage:", "image made");
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (MoodstocksError e) {
            e.printStackTrace();
        }

        // Local search:
        /*try {
            Result result = scanner.search(img, Scanner.SearchOption.DEFAULT, Result.Extra.NONE);
            if (result != null) {
                Log.d("CaptureActivity", "[Local search] Result found: "+result.getValue());
            }
            else {
                Log.d("CaptureActivity", "[Local search] No result found");
                addToLDB = true;

            }
        } catch (MoodstocksError e) {
            e.printStackTrace();
        }*/

        // Server-side search:
        /*
        try {
            ApiSearcher searcher = new ApiSearcher(scanner);
            Result result = searcher.search(img);
            if (result != null) {
                Log.d("CaptureActivity", "[Server-side search] Result found: "+result.getValue());
            }
            else {
                Log.d("CaptureActivity", "[Server-side search] No result found");
                addToSDB = true;
            }
        } catch (MoodstocksError e) {
            e.printStackTrace();
        }
        */

        /*if (addToLDB && addToSDB == true ){


            //galleryAddPic(bitmap);
            Log.d("CaptureActivity", "Picture can be added.");

        }*/

        // Release the `Image` object so there are no existing images afterwards

        galleryAddPic(bitmap);
        Log.d("CaptureActivity", "Picture can be added.");

        img.release();

    }

    //adds the bitmap picture to the gallery path on phone
    private void galleryAddPic(Bitmap bitmap) {
        // Find the SD Card path
        int imageNum = 0001;
        String imageName = ("IMG_" + imageNum);
        Log.d("ImagePath:", "working");

        File filepath = Environment.getExternalStorageDirectory();

        Log.d("ImagePath", ": " + filepath);

       // Create a new folder in SD Card
        File dir = new File(filepath.getAbsolutePath()
                + "/NeverForgetIMG/");
        dir.mkdirs();

        // Retrieve the image from the res folder
        //BitmapDrawable drawable = (BitmapDrawable) principal.getDrawable();
        //Bitmap bitmap1 = drawable.getBitmap();

        // Create a name for the saved image
        File file = new File(dir, "" + imageName + ".jpg");

        try {

            FileOutputStream output = new FileOutputStream(file);

            // Compress into png format image from 0% - 100%
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, output);
            output.flush();
            output.close();

        }

        catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        imageNum++;
    }
}

