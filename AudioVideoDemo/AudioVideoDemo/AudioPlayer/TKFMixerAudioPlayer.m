//
//  TKFMixerAudioPlayer.m
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/14.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "TKFMixerAudioPlayer.h"
#import "TKFAudioSession.h"

@interface TKFMixerAudioPlayer()
{
    NSURL * _url0;
    NSURL * _url1;

    TKFAUGraphNode *_plyer0Node;
    TKFAUGraphNode *_plyer1Node;
    TKFAUGraphNode *_mixerNode;
    TKFAUGraphNode *_ioNode;
}

@end

@implementation TKFMixerAudioPlayer

- (void)dealloc
{
    free(_plyer0Node);
    free(_plyer1Node);
    free(_mixerNode);
    free(_ioNode);

    _nodeList = NULL;
    _plyer0Node = NULL;
    _plyer1Node = NULL;
    _ioNode = NULL;
}

- (instancetype)initWithURL:(NSURL *)URL0 URL1:(NSURL *)URL1;
{
    self = [super init];
    if(self) {
        
        _url0 = URL0;
        _url1 = URL1;
        
        [self setURL:URL0 toAudioUnit:_plyer0Node->audioUnit];
        [self setURL:URL1 toAudioUnit:_plyer1Node->audioUnit];
    }
    return self;
}

- (TKFAUGraphNodeList *)initGraphNodeList
{
    _nodeList = (TKFAUGraphNodeList *)malloc(sizeof(TKFAUGraphNodeList));
    _nodeList->count = 4;
    _nodeList->nodes = (TKFAUGraphNode **)malloc((sizeof(TKFAUGraphNode *) * _nodeList->count));
    
    TKFAUGraphNode(_plyer0Node, 0, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer);
    TKFAUGraphNode(_plyer1Node, 1, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer);
    TKFAUGraphNode(_mixerNode, 2, kAudioUnitType_Mixer, kAudioUnitSubType_MultiChannelMixer);
    TKFAUGraphNode(_ioNode, 3, kAudioUnitType_Output, kAudioUnitSubType_RemoteIO);
    return _nodeList;
}

- (void)makeNodeConnections
{
    AUGraphConnectNodeInput(_auGraph, _plyer0Node->node, 0, _mixerNode->node, 1);
    AUGraphConnectNodeInput(_auGraph, _plyer1Node->node, 0, _mixerNode->node, 2);
    AUGraphConnectNodeInput(_auGraph, _mixerNode->node, 0, _ioNode->node, 0);
}

- (void)setNodeProperty:(TKFAUGraphNode *)node
{
    if(node == _ioNode) {

    }else if(node == _plyer0Node || node == _plyer1Node) {

    }else if(node == _mixerNode) {


    }
}
@end
