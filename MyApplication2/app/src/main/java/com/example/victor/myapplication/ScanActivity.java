/*
 * This file was created by Victor Chu on 7/20/2014.
 * Description: Deals with scanning or recognition menu interactions.
 */

package com.example.victor.myapplication;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceView;

import com.moodstocks.android.AutoScannerSession;
import com.moodstocks.android.MoodstocksError;
import com.moodstocks.android.Result;
import com.moodstocks.android.Scanner;

public class ScanActivity extends Activity implements AutoScannerSession.Listener {

    private AutoScannerSession session = null;

    //sets new surfaceview for scanning/image recog.
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scan);

        SurfaceView preview = (SurfaceView)findViewById(R.id.preview);

        try {
            session = new AutoScannerSession(this, Scanner.get(), this, preview);
        } catch (MoodstocksError e) {
            e.printStackTrace();
        }
    }


    //inflates menu
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.scan, menu);
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

    // ** need to implement this function for camera failure case
    @Override
    public void onCameraOpenFailed(Exception e) {

    }

    @Override
    public void onResult(Result result) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setCancelable(false);
        builder.setNeutralButton("OK", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                session.resume();
            }
        });
        builder.setTitle(result.getType() == Result.Type.IMAGE ? "Image:" : "Barcode:");
        builder.setMessage(result.getValue());
        builder.show();
    }

    @Override
    public void onWarning(String debugMessage) {

    }
    @Override
    protected void onResume() {
        super.onResume();
        session.start();
    }

    @Override
    protected void onPause() {
        super.onPause();
        session.stop();
    }
}
