//
//  TKFAudioPlayer.m
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/13.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "TKFAudioPlayer.h"
#import "TKFAudioSession.h"
#import <AVFoundation/AVFoundation.h>

@interface TKFAudioPlayer()
{
    NSURL * _url;
    
    TKFAUGraphNode *_plyerNode;
    TKFAUGraphNode *_ioNode;
}
@end

@implementation TKFAudioPlayer

- (void)dealloc
{
    free(_plyerNode);
    free(_ioNode);
    
    _plyerNode = NULL;
    _ioNode = NULL;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if(self) {
        _url = URL;
        
        [self setURL:URL toAudioUnit:_plyerNode->audioUnit];
    }
    return self;
}

#pragma mark - Ovrride

- (TKFAUGraphNodeList *)initGraphNodeList
{
    _nodeList = (TKFAUGraphNodeList *)malloc(sizeof(TKFAUGraphNodeList));
    _nodeList->count = 2;
    _nodeList->nodes = (TKFAUGraphNode **)malloc((sizeof(TKFAUGraphNode *) * _nodeList->count));
    
    TKFAUGraphNode(_plyerNode, 0, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer);
    TKFAUGraphNode(_ioNode, 1, kAudioUnitType_Output, kAudioUnitSubType_RemoteIO);
    return _nodeList;
}

- (void)setNodeProperty:(TKFAUGraphNode *)node
{
    AudioStreamBasicDescription stereoStreamFormat = [self noninterleavedPCMFormatWithChannels:2];

    if(node == _plyerNode) {
        self.status = AudioUnitSetProperty(node->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &stereoStreamFormat, sizeof (stereoStreamFormat));
    }if(node == _ioNode) {
        self.status = AudioUnitSetProperty(node->audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &stereoStreamFormat, sizeof(stereoStreamFormat));
    }
}

- (void)makeNodeConnections
{
    AUGraphConnectNodeInput(_auGraph, _plyerNode->node, 0, _ioNode->node, 0);
}
@end
