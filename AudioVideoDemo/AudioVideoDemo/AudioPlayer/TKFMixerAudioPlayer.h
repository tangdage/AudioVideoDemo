//
//  TKFMixerAudioPlayer.h
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/14.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKBaseAudio.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFMixerAudioPlayer : TKBaseAudio
- (instancetype)initWithURL:(NSURL *)URL0 URL1:(NSURL *)URL1;
@end

NS_ASSUME_NONNULL_END
