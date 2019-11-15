//
//  TKFAudioPlayer.h
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/13.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKBaseAudio.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFAudioPlayer : TKBaseAudio

- (instancetype)initWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
