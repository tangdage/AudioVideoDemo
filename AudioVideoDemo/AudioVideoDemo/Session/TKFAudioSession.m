//
//  ELAudioSession.m
//  video_player
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 xiaokai.zhan. All rights reserved.
//

#import "TKFAudioSession.h"
#import "AVAudioSession+RouteUtils.h"

@implementation TKFAudioSession

+ (TKFAudioSession *)sharedInstance
{
    static TKFAudioSession *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TKFAudioSession alloc] init];
    });
    return instance;
}

- (id)init
{
    if((self = [super init]))
    {
        _preferredSampleRate = _currentSampleRate = 44100.0;
        _audioSession = [AVAudioSession sharedInstance];
        
           [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(audioRouteChangeListenerCallback:)
                                                         name:AVAudioSessionRouteChangeNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(otherAppAudioSessionCallBack:)
                                                         name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(systermAudioSessionCallBack:)
                                                         name:AVAudioSessionInterruptionNotification object:nil];
    }
    return self;
}

- (void)setCategory:(NSString *)category
{
    _category = category;
    
    NSError *error = nil;
    if(![self.audioSession setCategory:_category error:&error])
        NSLog(@"Could note set category on audio session: %@", error.localizedDescription);
}

- (void)setActive:(BOOL)active
{
    _active = active;
    
    NSError *error = nil;
    
    if(![self.audioSession setPreferredSampleRate:self.preferredSampleRate error:&error])
        NSLog(@"Error when setting sample rate on audio session: %@", error.localizedDescription);
    
    if(![self.audioSession setActive:_active error:&error])
        NSLog(@"Error when setting active state of audio session: %@", error.localizedDescription);
    
    _currentSampleRate = [self.audioSession sampleRate];
}

- (void)setPreferredLatency:(NSTimeInterval)preferredLatency
{
    _preferredLatency = preferredLatency;
    
    NSError *error = nil;
    if(![self.audioSession setPreferredIOBufferDuration:_preferredLatency error:&error])
        NSLog(@"Error when setting preferred I/O buffer duration");
}

#pragma mark - notification observer

// 监听外部设备改变
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            NSLog(@"headset input");
            break;
        }
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            NSLog(@"pause play when headset output");
//            [self.avPlayer pause];
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
    AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
    if (currentRoute) {
        if ([[AVAudioSession sharedInstance] tkf_usingWiredMicrophone]) {
        } else {
            if (![[AVAudioSession sharedInstance] tkf_usingBlueTooth]) {
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            }
        }
    }
    
}

// 其他app占用音频通道
- (void)otherAppAudioSessionCallBack:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] integerValue];
    switch (interuptType) {
        case AVAudioSessionSilenceSecondaryAudioHintTypeBegin:{
//            [self.avPlayer pause];
            NSLog(@"pause play when other app occupied session");
            break;
        }
        case AVAudioSessionSilenceSecondaryAudioHintTypeEnd:{
            NSLog(@"occupied session");
            break;
        }
        default:
            break;
    }
}

- (void)systermAudioSessionCallBack:(NSNotification *)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];

    switch (interuptType) {
        case AVAudioSessionInterruptionTypeBegan:{
//            [self.avPlayer pause];
            NSLog(@"pause play when phone call or alarm ");
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:{
            break;
        }
        default:
            break;
    }
}

@end
