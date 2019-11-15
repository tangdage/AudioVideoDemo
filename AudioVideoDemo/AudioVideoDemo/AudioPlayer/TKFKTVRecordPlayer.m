//
//  TKFKTVRecordPlayer.m
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/15.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "TKFKTVRecordPlayer.h"
#import "TKFAudioSession.h"

@interface TKFKTVRecordPlayer()
{
    NSURL * _URL;
    
    TKFAUGraphNode *_plyerNode;
    TKFAUGraphNode *_converterNode;
    TKFAUGraphNode *_mixerNode;
    TKFAUGraphNode *_ioNode;
}
@end

@implementation TKFKTVRecordPlayer

- (void)dealloc
{
    free(_plyerNode);
    free(_ioNode);
    free(_converterNode);
    free(_mixerNode);

    _plyerNode = NULL;
    _ioNode = NULL;
    _converterNode = NULL;
    _mixerNode = NULL;
}

- (instancetype)initWithPlayURL:(NSURL *)URL outputPath:(nullable NSString *)outputPath
{
    self = [super init];
    if(self) {
    
        _URL = URL;
        // todo: outputPath
        
        [self setURL:URL toAudioUnit:_plyerNode->audioUnit];
    }
    return self;
}

- (TKFAUGraphNodeList *)initGraphNodeList
{
    _nodeList = (TKFAUGraphNodeList *)malloc(sizeof(TKFAUGraphNodeList));
    _nodeList->count = 4;
    _nodeList->nodes = (TKFAUGraphNode **)malloc((sizeof(TKFAUGraphNode *) * _nodeList->count));
    
    TKFAUGraphNode(_ioNode, 0, kAudioUnitType_Output, kAudioUnitSubType_RemoteIO);
    TKFAUGraphNode(_converterNode, 1, kAudioUnitType_FormatConverter, kAudioUnitSubType_AUConverter);
    TKFAUGraphNode(_mixerNode, 2, kAudioUnitType_Mixer, kAudioUnitSubType_MultiChannelMixer);
    TKFAUGraphNode(_plyerNode, 3, kAudioUnitType_Generator, kAudioUnitSubType_AudioFilePlayer);
    return _nodeList;
}

- (void)makeNodeConnections
{
    AUGraphConnectNodeInput(_auGraph, _ioNode->node,       1,  _converterNode->node, 0);
    AUGraphConnectNodeInput(_auGraph, _converterNode->node, 0, _mixerNode->node, 0);
    AUGraphConnectNodeInput(_auGraph, _plyerNode->node, 0, _mixerNode->node, 1);
    AUGraphConnectNodeInput(_auGraph, _mixerNode->node, 0, _ioNode->node, 0);
}

- (void)setNodeProperty:(TKFAUGraphNode *)node
{
    if(node == _ioNode) {
        
        UInt32 enable = 1;
        self.status = AudioUnitSetProperty(node->audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &enable, sizeof(enable));
        
    }else if(node == _plyerNode) {
        
        
    }else if(node == _mixerNode) {
        

    }else if(node == _converterNode) {
        
    }
}

// TODO
//static OSStatus renderCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData)
//{
//    OSStatus result = noErr;
//    __unsafe_unretained TKFMixerAudioPlayer *THIS = (__bridge TKFMixerAudioPlayer *)inRefCon;
//    AudioUnitRender(THIS->_mixerNode->audioUnit, ioActionFlags, inTimeStamp, 0, inNumberFrames, ioData);
////    result = ExtAudioFileWriteAsync(THIS->finalAudioFile, inNumberFrames, ioData);
//    return result;
//}


@end
