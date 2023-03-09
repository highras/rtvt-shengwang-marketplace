//
//  ViewController.m
//  AgoraRtcKitTest
//
//  Created by zsl on 2022/8/31.
//

#import "ViewController.h"
#import "ViewController+UI.h"

@interface ViewController ()<AgoraRtcEngineDelegate,AgoraRtcEngineDelegate2,AgoraMediaFilterEventDelegate>

@property(nonatomic,strong)AgoraRtcEngineKit * kit;
@property(nonatomic,strong)AgoraRtcEngineConfig * config;
@property(nonatomic,strong)NSString * agoraToken;

@property(nonatomic,strong)NSString * agora_appId;
@property(nonatomic,strong)NSString * agora_Token;
@property(nonatomic,strong)NSString * agora_RoomId;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.agora_appId = @"c6abd9c0ec4741489221d53f50e4cb62";
        self.agora_Token = @"007eJxTYFB8eaJ0xnmXd9xljcmO4X/lcsQXf8zzdLb0/nxawuLAGU4FBrNUcyPLVEsTS8O0FBOj1JREy1SLlNQUIxMzcwtT45TUKZ//JTcEMjKorpNjYmSAQBCfmcHCwoKBAQAulh6x";
        self.agora_RoomId = @"888";
        
        
        
        [self setUpUI];
        self.agoraToken = self.agora_Token;
        self.config = [[AgoraRtcEngineConfig alloc] init];
        self.config.appId = self.agora_appId;
        self.config.areaCode = AgoraAreaCodeTypeGlobal;
        self.config.channelProfile = AgoraChannelProfileLiveBroadcasting;
        self.config.audioScenario = AgoraAudioScenarioDefault;
        self.config.eventDelegate = self;

        self.kit = [AgoraRtcEngineKit sharedEngineWithConfig:self.config delegate:self];
        
        
        //音频
        NSLog(@"[self.kit setClientRole:AgoraClientRoleBroadcaster]  %d",[self.kit setClientRole:AgoraClientRoleBroadcaster]);
        NSLog(@"[self.kit enableAudio];  %d",[self.kit enableAudio]);
        NSLog(@"self.kit enableExtensionWithVendor:  %d",[self.kit enableExtensionWithVendor:[iLiveDataSimpleFilterManager companyName] extension:[iLiveDataSimpleFilterManager rtvt_plugName] enabled:YES]);
        NSLog(@"[self.kit setAudioProfile:AgoraAudioProfileDefault]  %d",[self.kit setAudioProfile:AgoraAudioProfileDefault]);
        NSLog(@"[self.kit setDefaultAudioRouteToSpeakerphone:YES];   %d",[self.kit setDefaultAudioRouteToSpeakerphone:YES]);
        
        
        //视频
        

        AgoraVideoEncoderConfiguration * videoEncoderConfiguration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(120, 160)
                                                                                                                frameRate:AgoraVideoFrameRateFps15
                                                                                                                  bitrate:AgoraVideoBitrateStandard
                                                                                                          orientationMode:AgoraVideoOutputOrientationModeFixedPortrait
                                                                                                               mirrorMode:AgoraVideoMirrorModeAuto];
        [self.kit setVideoEncoderConfiguration:videoEncoderConfiguration];
        NSLog(@"[self.kit enableVideo];  %d",[self.kit enableVideo]);
        NSLog(@"self.kit enableExtensionWithVendor:  %d",[self.kit enableExtensionWithVendor:[iLiveDataSimpleFilterManager companyName] extension:[iLiveDataSimpleFilterManager rtau_plugName] enabled:YES]);

        AgoraRtcVideoCanvas * videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = 0;
        // the view to be binded

        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(30, 60, 120, 160)];
        myView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:myView];
        videoCanvas.view = myView;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        [self.kit setupLocalVideo:videoCanvas];
        [self.kit startPreview];
        
    });
    
}
//进入房间 开启rtvt
-(void)_startRtvtButtonClick{
    
   
    
    
    
   
            
        NSDictionary * translateDic = @{@"appKey":@"00000090008000",
                                        @"appSecret":@"cXdlcnR5",
                                        @"srcLanguage":@"zh",
                                        @"destLanguage":@"en"
                                        
        };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:translateDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        BOOL start_audio_translate_result = [self _setProperty:@"startAudioTranslation" value:jsonStr type:0];
        
        
        if (  start_audio_translate_result == 0 ) {
            
            NSLog(@"启动插件成功");
            [self.startRtvtButton setTitle:@"End RTVT" forState:UIControlStateNormal];
            [self.startRtvtButton addTarget:self action:@selector(_endRtvtButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            
            NSLog(@"启动插件失败");
            
        }
        
    
    
}
-(void)_endRtvtButtonClick{
    
    BOOL end_audio_translate_result = [self _setProperty:@"closeAudioTranslation" value:@"end" type:0];
    if (end_audio_translate_result == 0) {
        [self.startRtvtButton setTitle:@"Start RTVT" forState:UIControlStateNormal];
        [self.startRtvtButton addTarget:self action:@selector(_startRtvtButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
-(void)_startRtauButtonClick{
    
    int64_t ts1 = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary * audioCheckDic = @{@"appKey":@"92000001",
                                     @"appSecret":@"cXdlcnR5",
                                     @"streamId":[NSString stringWithFormat:@"%lld",ts1],
                                     @"audioLang":@"zh-CN",
                                     @"callbackUrl" : @"callbackUrl",
                                     
    };

    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:audioCheckDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr2 = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    
    BOOL start_check_result = [self _setProperty:@"startAudit" value:jsonStr2 type:1];
    
    
    if (  start_check_result == 0 ) {
        
        NSLog(@"启动插件成功");
        [self.startRtauButton setTitle:@"End RTAU" forState:UIControlStateNormal];
        [self.startRtauButton addTarget:self action:@selector(_endRtauButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        NSLog(@"启动插件失败");
        
    }
}
-(void)_endRtauButtonClick{
    
    BOOL end_check_result = [self _setProperty:@"closeAudit" value:@"end" type:1];
    if (end_check_result == 0) {
        [self.startRtauButton setTitle:@"Start RTAU" forState:UIControlStateNormal];
        [self.startRtauButton addTarget:self action:@selector(_startRtauButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)_startAddRoomButtonClick{
    
    int result = [self.kit joinChannelByToken:self.agoraToken channelId:self.agora_RoomId info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
        
    }];
    if (result == 0) {
        
        [self.addRoomButton setTitle:@"add room is ok" forState:UIControlStateNormal];
        [self.addRoomButton removeTarget:self action:@selector(_startAddRoomButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

//0 rtvt 1rtau
-(BOOL)_setProperty:(NSString*)key value:(NSString*)value type:(int)type{
    
    return [self.kit setExtensionPropertyWithVendor:[iLiveDataSimpleFilterManager companyName]
                                          extension:(type == 0 ? [iLiveDataSimpleFilterManager rtvt_plugName] : [iLiveDataSimpleFilterManager rtau_plugName])
                                                key:key
                                              value:value];
    
    
}
-(void)onEvent:(NSString *)provider extension:(NSString *)extension key:(NSString *)key value:(NSString *)value{
    
    NSLog(@"onEvent  %@   %@  %@   %@",provider,extension,key,value);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([key isEqualToString:@"recognizeResult"]) {
            
            [self.recognizedResultArray addObject:value];
            [self.recognizedTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.recognizedResultArray.count - 1 inSection:0];
            [self.recognizedTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            
        }else if ([key isEqualToString:@"translateResult"]){
            
            [self.translatedResultArray addObject:value];
            [self.translatedTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.translatedResultArray.count - 1 inSection:0];
            [self.translatedTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
    });
    
    
}













#pragma mark ui
-(UIButton*)startRtvtButton{
    if (_startRtvtButton == nil) {
        _startRtvtButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRtvtButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_startRtvtButton setTitle:@"Start RTVT" forState:UIControlStateNormal];
        [_startRtvtButton addTarget:self action:@selector(_startRtvtButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _startRtvtButton.backgroundColor = YS_Color_alpha(0x1b9fff,1);
        [_startRtvtButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _startRtvtButton;
}
-(UIButton*)startRtauButton{
    if (_startRtauButton == nil) {
        _startRtauButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRtauButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_startRtauButton setTitle:@"Start RTAU" forState:UIControlStateNormal];
        [_startRtauButton addTarget:self action:@selector(_startRtauButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _startRtauButton.backgroundColor = YS_Color_alpha(0x1b9fff,1);
        [_startRtauButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _startRtauButton;
}
-(UIButton*)addRoomButton{
    if (_addRoomButton == nil) {
        _addRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addRoomButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_addRoomButton setTitle:@"first add room" forState:UIControlStateNormal];
        [_addRoomButton addTarget:self action:@selector(_startAddRoomButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addRoomButton.backgroundColor = YS_Color_alpha(0x1b9fff,1);
        [_addRoomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _addRoomButton;
}

-(UITableView*)translatedTableView{
    if (_translatedTableView == nil) {
        _translatedTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _translatedTableView.backgroundColor = [UIColor blackColor];
        _translatedTableView.delegate = self;
        _translatedTableView.dataSource = self;
        _translatedTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _translatedTableView;
}
-(UITableView*)recognizedTableView{
    if (_recognizedTableView == nil) {
        _recognizedTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recognizedTableView.backgroundColor = [UIColor blackColor];
        _recognizedTableView.delegate = self;
        _recognizedTableView.dataSource = self;
        _recognizedTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _recognizedTableView;
}
@end
