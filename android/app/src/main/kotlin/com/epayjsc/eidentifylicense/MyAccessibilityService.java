package com.epayjsc.eidentifylicense;

import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.Toast;

import java.util.List;


public class MyAccessibilityService extends AccessibilityService {

    private final String INSTALL_AND_UNINSTALL = "com.android.packageinstaller";
    private String[] key = new String[]{ "INSTALL","UPDATE","OPEN","OK"};

    /**
     * 当服务连接成功时
     */
    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        Toast.makeText(MyAccessibilityService.this, "服务连接成功", Toast.LENGTH_SHORT).show();
    }

    /**
     * 当指定事件发出服务时
     *
     * @param event
     */
    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        System.out.println("窗口事件的包名" + event.getPackageName().toString());

       try{
           if (event == null || !event.getPackageName().toString()
                   .contains("packageinstaller"))
               return;

           if (event.getSource() != null) {
               switch (event.getPackageName().toString()) {
                   case INSTALL_AND_UNINSTALL:
                       for (int i = 0; i < key.length; i++) {
                           AccessibilityNodeInfo nodeInfo = getRootInActiveWindow();
                           if (nodeInfo != null) {
                               List<AccessibilityNodeInfo> nodes = nodeInfo.findAccessibilityNodeInfosByText(key[i]);
                               if (nodes != null && !nodes.isEmpty()) {
                                   AccessibilityNodeInfo node;
                                   for (int j = 0; j < nodes.size(); j++) {
                                       node = nodes.get(j);
                                       if ((node.getClassName().equals("android.widget.Button") || node.getClassName().equals("android.widget.TextView")) && node.isEnabled()) {
                                           node.performAction(AccessibilityNodeInfo.ACTION_CLICK);
                                       }
                                   }
                               }
                           }
                       }
                       break;
                   default:
                       break;
               }
           }
       }catch (Exception e){

       }
    }

    /**
     * 终止服务时调用
     */
    @Override
    public void onInterrupt() {

    }
}
