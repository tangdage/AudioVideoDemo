//
//  ELAudioSession.h
//  video_player
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 xiaokai.zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TKFAudioSession : NSObject

+ (TKFAudioSession *)sharedInstance;

@property(nonatomic, strong) AVAudioSession *audioSession; // Underlying system audio session
@property(nonatomic, assign) Float64 preferredSampleRate;
@property(nonatomic, assign, readonly) Float64 currentSampleRate;
@property(nonatomic, assign) NSTimeInterval preferredLatency;
@property(nonatomic, assign) BOOL active;
@property(nonatomic, strong) NSString *category;
@end
