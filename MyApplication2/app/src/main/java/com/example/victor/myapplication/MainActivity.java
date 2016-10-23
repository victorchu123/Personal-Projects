/*
 * This file was created by Victor Chu on 7/20/2014.
 * Description: Deals with main menu interactions.
 */

package com.example.victor.myapplication;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.moodstocks.android.MoodstocksError;
import com.moodstocks.android.Scanner;


public class MainActivity extends Activity implements Scanner.SyncListener {


    // Moodstocks API key/secret pair
    private static final String API_KEY = "glgcioitufvouztronhc";
    private static final String API_SECRET = "vwLg4QS3alTsj5Hh";
    private static final String TAG = "MainActivity";

    //declares scanner/variables

    private boolean compatible = false;
    private Scanner scanner;



    //what happens on application startup
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my);

        Log.d(TAG, "Application opened.");

        //what happens if camera is compatible

        compatible = Scanner.isCompatible();

        if (compatible) {
            try {
                scanner = Scanner.get();
                String path = Scanner.pathFromFilesDir(this, "scanner.db");
                Log.d("Main", path);
                scanner.open(path, API_KEY, API_SECRET);

                //API syncing process
                scanner.setSyncListener(this);
                scanner.sync();

                //finds sdcard path

                String filepath = Environment.getExternalStorageDirectory().getAbsolutePath();

                //creates app storage
                String sdPath = filepath + "/NeverForgetIMG/";

                Log.d("Main", sdPath);

            } catch (MoodstocksError e) {
                e.printStackTrace();
            }
        }

    }


    //on "Existing Key" button press

    public void onScanButtonClicked(View view) {
        //starts moodstocks scanner api
            if(compatible){
                startActivity(new Intent(this, ScanActivity.class));
            }
    }


    //when application closed
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (compatible) {
            try {
                scanner.close();
                scanner.destroy();
                scanner = null;
            } catch (MoodstocksError e) {
                e.printStackTrace();
            }
        }
    }



    //inflates menu on startup
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.my, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


    // debug log message for pic sync start
    @Override
    public void onSyncStart() {

        Log.d(TAG, "Sync will start.");
    }

    // debug log message for pic sync end
    @Override
    public void onSyncComplete() {
        try {
            Log.d(TAG, "Sync succeeded ("+ scanner.count() + " images)");

        } catch (MoodstocksError e) {
            e.printStackTrace();
        }
    }

    // debug log message for sync failure
    @Override
    public void onSyncFailed(MoodstocksError e) {
        Log.d(TAG, "Sync error #" + e.getErrorCode() + ": " + e.getMessage());

    }

    // debug log for sync progress
    @Override
    public void onSyncProgress(int total, int current) {
        int percent = (int) ((float) current / (float) total * 100);
        Log.d(TAG, "Sync progressing: " + percent + "%");

    }
    //on "New Key" button press, start captureactivity.java
    public void onCaptureButtonClicked(View view){

        try{
            startActivity(new Intent(this, CaptureActivity.class));
        }
        catch(Exception e){
            e.printStackTrace();

        }
    }
}
