package io.agora.api.example;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import io.agora.api.example.common.Constant;
import io.agora.api.example.common.model.ExampleBean;

import io.agora.api.example.examples.advanced.SimpleExtension;

import io.agora.api.example.examples.basic.JoinChannelAudio;
import io.agora.rtc2.RtcEngine;

/**
 * @author cjw
 */
public class ExampleActivity extends AppCompatActivity {
    private static final String TAG = "ExampleActivity";

    private ExampleBean exampleBean;

    private TextView version;

    public static void instance(Activity activity, ExampleBean exampleBean) {
        Intent intent = new Intent(activity, ExampleActivity.class);
        intent.putExtra(Constant.DATA, exampleBean);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_example_layout);
        exampleBean = getIntent().getParcelableExtra(Constant.DATA);
        version = findViewById(R.id.versionNumber);
        version.setText(String.format(getString(R.string.sdkversion1), RtcEngine.getSdkVersion()));
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(exampleBean.getName());
            actionBar.setHomeButtonEnabled(true);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

        Fragment fragment;
        switch (exampleBean.getActionId()) {
            case R.id.action_mainFragment_to_joinChannelAudio:
                fragment = new JoinChannelAudio();
                break;
            case R.id.action_mainFragment_extension:
                fragment = new SimpleExtension();
                break;
            default:
                fragment = new JoinChannelAudio();
                break;
        }
        getSupportFragmentManager().beginTransaction()
                .replace(R.id.fragment_Layout, fragment)
                .commit();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            this.finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
