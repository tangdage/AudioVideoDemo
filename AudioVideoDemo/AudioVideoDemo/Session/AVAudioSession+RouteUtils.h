#import <AVFoundation/AVFoundation.h>

@interface AVAudioSession (RouteUtils)

- (BOOL)tkf_usingBlueTooth;

- (BOOL)tkf_usingWiredMicrophone;

- (BOOL)tkf_shouldShowEarphoneAlert;

@end
