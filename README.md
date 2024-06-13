# 使用云上曲率实时语音识别&翻译插件（音频前+后处理）

本文介绍如何在你的项目中集成和使用云上曲率实时语音识别&翻译插件（以下简称曲率识别及翻译插件），包括Android和iOS平台。
注意：本文内容主要针对使用[声网视频 SDK v4.0.0 Beta](https://docs.agora.io/cn/video-call-4.x-beta/product_video_ng?platform=Android) 并需要进行**音频前+后处理**操作使用。如果不需要在RTC音频传输过程中，接收端对音频进行识别和翻译，请忽略本文。

## 技术原理

曲率识别及翻译插件是对云上曲率[实时语音识别](https://docs.ilivedata.com/asr/overview/introduction/)和[实时翻译](https://docs.ilivedata.com/alt/overview/introduction/)核心 API 的封装。通过调用[声网视频 SDK v4.0.0 Beta](https://docs.agora.io/cn/video-call-4.x-beta/product_video_ng?platform=Android) 的 [setExtensionProperty](https://docs.agora.io/cn/video-call-4.x-beta/API%20Reference/java_ng/API/class_irtcengine.html#api_setextensionproperty) 或 [setExtensionPropertyWithVendor](https://docs.agora.io/cn/video-call-4.x-beta/API%20Reference/ios_ng/API/class_irtcengine.html#api_setextensionproperty)方法，传入指定的 `key` 和 `value` 参数，你可以快速集成云上曲率的实时语音识别和翻译的能力。支持的 key 和 value 详见[插件的 key-value 列表](云上曲率实时语音识别&翻译插件接口说明.md)

## 前提条件

- Android 开发环境需满足以下要求：
  - Android Studio 4.1 以上版本。
  - 运行 Android 5.0 或以上版本的真机（非模拟器）。
- iOS 开发环境需满足以下要求：
  - Xcode 9.0 或以上版本。
  - 运行 iOS 9.0 或以上版本的真机（非模拟器）。

## 准备工作

### 使用声网 SDK 实现视频通话

曲率识别及翻译插件需要与[声网视频 SDK v4.0.0 Beta](https://docs.agora.io/cn/video-call-4.x-beta/product_video_ng?platform=Android) 搭配使用。参考以下文档集成视频 SDK v4.0.0 Beta 并实现基础的视频通话：
- [实现视频通话（Android）](https://docs.agora.io/cn/video-call-4.x-beta/start_call_android_ng?platform=Android#%E5%BB%BA%E7%AB%8B%E9%A1%B9%E7%9B%AE)
- [实现视频通话（iOS）](https://docs.agora.io/cn/video-call-4.x-beta/start_call_ios_ng%20?platform=iOS#%E5%88%9B%E5%BB%BA%E9%A1%B9%E7%9B%AE)

### 购买和激活插件

在声网控制台[购买和激活](https://docs.agora.io/cn/extension_customer/get_extension?platform=All%20Platforms)曲率识别及翻译插件，保存好获取到的 `appKey` 和 `appSecret`，后续初始化插件时需要用到。

### 集成插件

参考如下步骤在你的项目中集成曲率识别及翻译插件：

**Android**


1. 在[声网云市场下载](https://docs.agora.io/cn/extension_customer/downloads?platform=All%20Platforms)页面下载曲率识别及翻译插件的 Android 插件包。解压后，将所有 `.aar` 文件保存到项目文件夹的  `/app/libs`  路径。
2. 打开 `app/build.gradle` 文件，在 `dependencies` 中添加如下行：

   ```java
   implementation fileTree(dir: "libs", include: ["*.jar", "*.aar"])
   ```

**iOS**


1. 在[声网云市场下载](https://docs.agora.io/cn/extension_customer/downloads?platform=All%20Platforms)页面下载曲率识别及翻译插件的 iOS 插件包。解压后，将所有 `.framework` 库文件保存到你的项目文件夹下。
2. 在 Xcode 中[添加动态库](https://help.apple.com/xcode/mac/current/#/dev51a648b07)，确保 **Embed** 属性设置为 **Embed & Sign**。

以如下项目结构为例，你可以把库文件保存到 `<ProjectName>` 路径下。

```shell
.
├── <ProjectName>
├── <ProjectName>.xcodeproj
```

## 调用流程

本节介绍插件相关接口的调用流程。接口的参数解释详见[接口说明](云上曲率实时语音识别&翻译插件接口说明.md)。
注意：插件的使用是在接收端实现。

### 1. 启用插件

**Android**
初始化声网 `AgoraRtcEngine` 时，调用 `enableExtension` 启用插件。

```java
    RtcEngineConfig config = new RtcEngineConfig();
    config.addExtension("agora-iLiveData-filter-pre"); //添加前处理插件
    config.addExtension("agora-iLiveData-filter-post"); //添加后处理插件(翻译远端用户)

    engine = RtcEngine.create(config);
    engine.enableExtension("iLiveDataPre", "RTVT_PRE", true); //开启前处理插件
    engine.enableExtension("iLiveDataPre", "RTVT_POST", true);//开启后处理插件

```

**iOS**
初始化声网 `AgoraRtcEngine` 时，调用 `enableExtensionWithVendor` 启用插件。

```objective-c
   AgoraRtcEngineConfig *config = [AgoraRtcEngineConfig new];

   // 监听插件事件，用于接收 onEvent 回调
   config.eventDelegate = self;
   self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config
                                                    delegate:self];
   // 开启后处理插件
   [self.kit enableExtensionWithVendor:[iLiveDataPost]
                             extension:[RTVT_POST]
                             enabled:YES];
   //开启前处理插件
   [self.kit enableExtensionWithVendor:[iLiveDataPre]
                             extension:[RTVT_PRE]
                             enabled:YES];

```


### 2. 使用插件
在使用插件时，除了在音频前处理的使用方法中一些必填参数以外，还需要由业务侧自行在`AgoraExtensionInfo`方法中填入`remoteUid`（远端用户ID，即音频发送端ID）、`channelId`（音频通话频道ID）和`localUid`（本端用户ID，即音频接收端ID），用于音频后处理的需要。

**Android**

调用`setExtensionProperty` 指定 key 为 `startAudioTranslation_post`(后处理) 、 `startAudioTranslation_pre`(前处理)，并在value中以json格式传入`appkey` `appsecret`等参数。


```java
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("appKey", "");
    jsonObject.put("appSecret", "");
    jsonObject.put("srcLang", "zh");
    jsonObject.put("dstLang", "en");
    jsonObject.addProperty("asrResult", true);
    jsonObject.addProperty("transResult", true);
    jsonObject.addProperty("tempResult", false);
```


```java
    ExtensionInfo extensionInfo = new ExtensionInfo();
    extensionInfo.localUid = ;
    extensionInfo.channelId = ;
    extensionInfo.remoteUid = ;
```
- 后处理
```java
    engine.setExtensionProperty("iLiveDataPost", "RTVT_POST", extensionInfo, "startAudioTranslation_post", jsonObject.toString());
```
- 前处理
```java
    engine.setExtensionProperty("iLiveDataPre", "RTVT_PRE", "startAudioTranslation_pre", jsonObject.toString());
```


**iOS**
调用`setExtensionPropertyWithVendor`，指定 key 为 `startAudioTranslation_post`(后处理) 、 `startAudioTranslation_pre`(前处理)，并在 value 中传入 `appKey` 和 `appSecret` 等参数。

- 后处理
```objective-c
    NSDictionary * startDic = @{
                                //传入appkey
                                @"appKey":<YOUR_APP_KEY>,
                                //传入appsecret
                                @"appSecret":<YOUR_APP_SECRET>,
                                //传入源语言
                                @"srcLanguage":@"zh",
                                //传入目标语言
                                @"destLanguage":@"en",
                                //设置识别结果
                                @"asrResult":@(YES),
                                //设置翻译结果
                                @"transResult":@(YES),
                                //设置临时结果
                                @"tempResult":@(NO),
                                };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:startDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
```

```objective-c
-(BOOL)_setProperty:(NSString*)key value:(NSString*)value type:(int)type{

    AgoraExtensionInfo * info = [[AgoraExtensionInfo alloc] init];
    info.remoteUid = ;
    info.channelId = ;
    info.localUid = ;

    return [self.kit setExtensionPropertyWithVendor:[iLiveDataPost]
                                   extension:[RTVT_POST]
                               extensionInfo:info
                                         key:"startAudioTranslation_post"
                                       value:value];
}
```


- 前处理
```objective-c
  NSDictionary * startDic = @{
                            //传入appkey
                            @"appKey":<YOUR_APP_KEY>,
                            //传入appsecret
                            @"appSecret":<YOUR_APP_SECRET>,
                            //传入源语言
                            @"srcLanguage":@"zh",
                            //传入目标语言
                            @"destLanguage":@"en",
                            //设置识别结果
                            @"asrResult":@(YES),
                            //设置翻译结果
                            @"transResult":@(YES),
                            //设置临时结果
                            @"tempResult":@(NO),
                            };
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:startDic options:NSJSONWritingPrettyPrinted error:nil];
  NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
```

```objective-c
[self.kit setExtensionPropertyWithVendor:[iLiveDataPre]
                                   extension:[RTVT_PRE]
                                         key:"startAudioTranslation_pre"
                                       value:jsonStr];
```
>注意：
>1. 调用使用插件接口时，需要保证channel中至少有2人在才可以调用，否则调用失败，插件无法使用。
>2. 进入channel后，插件会触发房间人员进入事件监听，并自动使用插件。如果不需要自动使用插件，请开发者自行进行设置。
>3. 如果需要回调临时结果，需要设置`tempResult`为YES，默认为NO。默认识别结果和翻译结果的回调都为YES，如果又不需要，请设置为NO。


### 3. 结束使用插件

**Android**
调用 `setExtensionProperty`方法并指定 key 为 `closeAudioTranslation_post`(后处理)、`closeAudioTranslation_pre`(前处理)， 来结束曲率识别和翻译插件的使用。
- 后处理
```java
    engine.setExtensionProperty("iLiveDataPost", "RTVT_POST", "closeAudioTranslation_post", "{}");
```
- 前处理
```java
    engine.setExtensionProperty("iLiveDataPre", "RTVT_PRE", "closeAudioTranslation_pre", "{}");
```

**iOS**
调用 `setExtensionPropertyWithVendor`方法并指定 key 为 `closeAudioTranslation_post`(后处理)、`closeAudioTranslation_pre`(前处理)， 来结束曲率识别和翻译插件的使用。

- 后处理
```objective-c
    [self.kit setExtensionPropertyWithVendor:[iLiveDataPost]
                                   extension:[RTVT_POST]
                                         key:"closeAudioTranslation_post"
                                       value:"end"];
```



- 前处理
```objective-c
[self.kit setExtensionPropertyWithVendor:[iLiveDataPre]
                               extension:[RTVT_PRE ]
                                     key:"closeAudioTranslation_pre"
                                   value:"end"];
```
> 注意：有以下两种情况需要开发者关注：
> 1. P2P通话时，如果某方出现断线情况，那么在重连成功后，需要开发者主动调用使用插件
> 2. P2P通话时，如果某方离开频道，那么另一方在监听到离开事件后，自动结束使用插件。如果此时再进入到其他房间，需要开发者主动调用使用插件。

### 4. 识别和翻译结果回调

**Android**
初始化成功后，曲率识别及翻译插件会通过 `onEvent` 回调返回识别结果。识别结果的含义详见 `onEvent` 回调。
- 后处理
```java
@Override
public void onEvent(String vendor, String extension, String key, String value) {
  vendor:"iLiveData"
    key: "recognizeResult"识别结果标识  "translateResult"翻译结果标识  "recognizedTempResult"临时识别结果标识 "translatedTempResult"临时翻译结果标识 
    extension: "RTVT_POST"
      value: 对应key分别为 识别结果 和 翻译结果 和 临时识别结果 和 临时翻译结果
}
```

- 前处理
```java
@Override
public void onEvent(String vendor, String extension, String key, String value) {
  vendor:"iLiveData"
    key: "recognizeResult"识别结果标识  "translateResult"翻译结果标识   "recognizedTempResult"临时识别结果标识 "translatedTempResult"临时翻译结果标识 
    extension: "RTVT_PRE"
      value: 对应key分别为 识别结果 和 翻译结果  和 临时识别结果 和 临时翻译结果
}
```

**iOS**
初始化成功后，曲率识别及翻译插件会通过 `onEvent` 回调返回识别结果。识别结果的含义详见 onEvent 回调。

- 后处理
```objective-c
-(void)onEvent:(NSString *)provider extension:(NSString *)extension key:(NSString *)key value:(NSString *)value{

       provider:"iLiveDataPost"
      extension:"RTVT_POST"
            key: "recognizeResult"识别结果标识  "translateResult"翻译结果标识   "recognizedTempResult"临时识别结果标识 "translatedTempResult"临时翻译结果标识 
          value: 对应key分别为 识别结果 和 翻译结果  和 临时识别结果 和 临时翻译结果

}
```
- 前处理
```objective-c
-(void)onEvent:(NSString *)provider extension:(NSString *)extension key:(NSString *)key value:(NSString *)value{

       provider:"iLiveDataPre"
      extension:"RTVT_PRE"
            key: "recognizeResult"识别结果标识  "translateResult"翻译结果标识   "recognizedTempResult"临时识别结果标识 "translatedTempResult"临时翻译结果标识 
          value: 对应key分别为 识别结果 和 翻译结果  和 临时识别结果 和 临时翻译结果

}
```

## 示例项目

| 平台    | 语言        | 示例项目                                                     |
| :------ | :---------- | :----------------------------------------------------------- |
| Android | Java        | [项目示例](https://github.com/highras/rtvt-shengwang-marketplace) |
| iOS     | Objective-C | [项目示例](https://github.com/highras/rtvt-shengwang-marketplace) |

### 运行步骤

**Android**

1. 克隆仓库：
  ```shell
	git clone (https://github.com/highras/rtvt-shengwang-marketplace)
  ```
2. 将项目的\app\src\main\res\values\string_configs.xml 文件中的"agora_app_id" 和"agora_access_token"替换成你自己声网的appid和apptoken 获取 App ID 请参考[开始使用 Agora 平台](https://docs.agora.io/cn/Agora%20Platform/get_appid_token?platform=All%20Platforms); 将"livedata_translate_pid" 和 "livedata_translate_key"替换成云上曲率项目id和key  获取方式详见[购买和激活插件](https://docs.agora.io/cn/extension_customer/get_extension?platform=All%20Platforms)。
3. 连接一台 Android 真机（非模拟器），运行项目。 输入频道号  点击“加入频道” 加入成功后 点击"开始翻译" 界面可以看见翻译结果




**iOS**
1. 从[声网云市场下载](https://docs.agora.io/cn/extension_customer/downloads?platform=All%20Platforms)页面下载曲率识别及翻译插件的 iOS 插件包并解压。
2. 将 iLiveData_Agora.framework 拖入项目。
3. 项目设置 在TARGETS->Build Settings->Other Linker Flags （选中ALL视图）中添加-ObjC，字母O和C大写，符号“-”请勿忽略。
4. 静态库中采用Objective-C++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件( 您可以将任意一个.m后缀的文件改名为.mm )。
5. 打开 ViewController，进行如下修改：
	- 将 `agora_appId` 替换为你的 App ID。获取 App ID 请参考[开始使用 Agora 平台](https://docs.agora.io/cn/Agora%20Platform/get_appid_token?platform=All%20Platforms)。
	- 将 `appKey` 和 `appSecret` 分别替换为你的 `appKey` 和 `appSecret`。获取方式详见[购买和激活插件](https://docs.agora.io/cn/extension_customer/get_extension?platform=All%20Platforms)。
5. 执行 初始化 + 启用插件 步骤
6. 连接一台 iOS 真机（非模拟器），运行项目。




### 预期效果

运行成功后，示例项目会安装到你的 Android 或 iOS 设备上。

1. 启动 app，你可以在界面上看到 `disableExtension` 和 `Start ASR` 按钮
2. 点击 `Start RTVT` 开始语音识别。
3. 点击 `End ASR` 结束语音识别。

## 接口说明

插件所有相关接口的参数解释详见[接口说明](云上曲率实时语音识别&翻译插件接口说明.md)。
