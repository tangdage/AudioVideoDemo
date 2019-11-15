//
//  TKFAUGraph.h
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/14.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


#define TKFAUGraphNode(name, index, type, subType) \
AudioComponentDescription description##index;\
description##index.componentManufacturer = kAudioUnitManufacturer_Apple; \
description##index.componentType = type; \
description##index.componentSubType = subType; \
description##index.componentFlags = 0; \
description##index.componentFlagsMask = 0; \
name = (TKFAUGraphNode *)malloc((sizeof(TKFAUGraphNode))); \
bzero(name, sizeof(TKFAUGraphNode)); \
name->description = description##index; \
*(_nodeList->nodes + index) = name;

typedef struct AUGraphNode {
    AUNode   node;
    AudioUnit  audioUnit;
    AudioComponentDescription description;
}TKFAUGraphNode;

typedef struct AUGraphNodeList {
    UInt32        count;
    TKFAUGraphNode ** nodes;
}TKFAUGraphNodeList;


@interface TKBaseAudio : NSObject
{
    AUGraph  _auGraph;
    Float64   _sampleRate;
    TKFAUGraphNodeList *_nodeList;
}

- (void)setStatus:(OSStatus)status;

- (AudioStreamBasicDescription)noninterleavedPCMFormatWithChannels:(UInt32)channels;

- (void)setURL:(NSURL *)URL toAudioUnit:(AudioUnit)audioUnit;

#pragma mark -

- (void)start;

- (void)stop;

#pragma mark - abstractMethod

- (TKFAUGraphNodeList *)initGraphNodeList;

- (void)setNodeProperty:(TKFAUGraphNode *)node;

- (void)makeNodeConnections;
@end
