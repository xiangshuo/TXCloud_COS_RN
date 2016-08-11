package com.你的包;
import android.content.Context;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.tencent.upload.Const;
import com.tencent.upload.UploadManager;
import com.tencent.upload.task.ITask;
import com.tencent.upload.task.IUploadTaskListener;
import com.tencent.upload.task.data.FileInfo;
import com.tencent.upload.task.impl.FileUploadTask;
import com.tencent.upload.task.impl.PhotoUploadTask;

import java.io.File;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by sf on 16/7/12.
 * 上传腾讯对象存储
 */
public class TxUpload extends ReactContextBaseJavaModule {

    Context ct;

    public TxUpload(ReactApplicationContext reactContext) {
        super(reactContext);
        ct=reactContext;
    }

    @Override
    public String getName() {
        return "TxUploadAndroid";
    }

    @ReactMethod
    public void uploadFile(String appId, String bucket, String filePath,String fileSign,
                       final Callback callback) {

        UploadManager fileUploadMgr = new UploadManager(ct, appId, Const.FileType.File,
                "qcloudobject");
        
        File file=new File(filePath);
        if (file == null || !file.exists()) {
            Toast.makeText(ct,"该文件不存在", Toast.LENGTH_SHORT).show();
            Log.e("xxxx","文件错误啦啦");
            return;
        }
        filePath=file.getAbsolutePath();
        
        FileUploadTask task = new FileUploadTask(bucket,filePath,"/"+file.getName(),"",true,new IUploadTaskListener() {

            @Override
            public void onUploadSucceed(FileInfo result) {
                //Toast.makeText(ct,"成功"+result.url,Toast.LENGTH_SHORT).show();
                WritableMap map = Arguments.createMap();
                map.putInt("status", 1);
                map.putString("url", result.url);
                callback.invoke(map);
            }

            @Override
            public void onUploadFailed(int errorCode, String errorMsg) {
                //Toast.makeText(ct,"错误"+errorCode+" 错误消息"+errorMsg,Toast.LENGTH_SHORT).show();
                WritableMap map = Arguments.createMap();
                map.putInt("status", 0);
                map.putInt("errorCode", errorCode);
                map.putString("errorMsg", errorMsg);
                callback.invoke(map);
                Log.e("xxxx","错误"+errorCode+" 错误消息"+errorMsg);

            }

            @Override
            public void onUploadProgress(long l, long l1) {

            }

            @Override
            public void onUploadStateChange(ITask.TaskState taskState) {

            }
        });

        task.setAuth(fileSign);
        fileUploadMgr.upload(task);  // 开始上传
    }

    @ReactMethod
    public void uploadImg(String appId, String bucket,String filePath,String photoSign,
                       final Callback callback) {
        //Log.e("xxxx",filePath.substring(7));

        UploadManager  mPhotoUpLoadManager = new UploadManager(ct, appId,
                Const.FileType.Photo, "qcloudphoto");
        PhotoUploadTask  imgUploadTask = new PhotoUploadTask(filePath.substring(7),
                new IUploadTaskListener() {

                    @Override
                    public void onUploadSucceed(final FileInfo result) {
                        // Log.i("Demo", "upload succeed: " + result.url);
                        //Toast.makeText(ct,"成功"+result.url,Toast.LENGTH_SHORT).show();
                        WritableMap map = Arguments.createMap();
                        map.putInt("status", 1);
                        map.putString("url", result.url);
                        callback.invoke(map);
                    }

                    @Override
                    public void onUploadStateChange(ITask.TaskState state) {
                        //Toast.makeText(ct,"changestate"+state,Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onUploadProgress(long totalSize, long sendSize) {
                         long p = (long) ((sendSize * 100) / (totalSize * 1.0f));
                        Log.i("Demo", "上传进度: " + p + "%");
                        //Toast.makeText(ct,"上传进度"+p,Toast.LENGTH_SHORT).show();

                    }

                    @Override
                    public void onUploadFailed(final int errorCode, final String errorMsg) {
                        //Log.i("Demo", "上传结果:失败! ret:" + errorCode + " msg:" + errorMsg);
                        //Toast.makeText(ct," 错误"+errorCode+" 错误消息"+errorMsg,Toast.LENGTH_SHORT).show();
                        WritableMap map = Arguments.createMap();
                        map.putInt("status", 0);
                        map.putInt("errorCode", errorCode);
                        map.putString("errorMsg", errorMsg);
                        callback.invoke(map);
                    }
                }
        );

        imgUploadTask.setBucket(bucket);
        //task.setFileId("test_fileId_" + UUID.randomUUID()); // 为图片自定义FileID(可选)
        imgUploadTask.setAuth(photoSign);
        mPhotoUpLoadManager.upload(imgUploadTask);  // 开始上传

    }



}
