//
//  TKFKTVRecordPlayer.h
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/15.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "TKBaseAudio.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKFKTVRecordPlayer : TKBaseAudio

- (instancetype)initWithPlayURL:(NSURL *)URL outputPath:(nullable NSString *)outputPath;
@end

NS_ASSUME_NONNULL_END
