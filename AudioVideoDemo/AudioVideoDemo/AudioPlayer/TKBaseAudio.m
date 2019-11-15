//
//  TKFAUGraph.m
//  ffmpeg-iphone
//
//  Created by tangkaifu on 2019/11/14.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "TKBaseAudio.h"
#import "TKFAudioSession.h"

@implementation TKBaseAudio

- (void)dealloc
{
    if(_nodeList) {
        free(_nodeList->nodes);
        free(_nodeList);
    }
    
    DisposeAUGraph(_auGraph);
}

- (void)setStatus:(OSStatus)status
{
    if(status != noErr) {
        NSLog(@"设置出错");
        NSAssert(YES, @"设置出错,请检查代码");
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _sampleRate = 44100.0;
        
        [[TKFAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord];
        [[TKFAudioSession sharedInstance] setPreferredSampleRate:44100];
        [[TKFAudioSession sharedInstance] setActive:YES];
        
        // 创建AUGraph
        self.status = NewAUGraph(&_auGraph);
        
        TKFAUGraphNodeList *nodeList = [self initGraphNodeList];
        if(nodeList != NULL && nodeList->count > 0) {
            for (int i = 0; i < nodeList->count; i++) {
                TKFAUGraphNode *node = *(nodeList->nodes + i);
                
                // 添加节点
                self.status = AUGraphAddNode(_auGraph, &(node->description), &node->node);
            }
        }
        
        // 打开AUGraph，会创建对应Nodes的AudioUnit
        self.status = AUGraphOpen(_auGraph);
        
        if(nodeList != NULL && nodeList->count > 0) {
            for (int i = 0; i < nodeList->count; i++) {
                TKFAUGraphNode *node = nodeList->nodes[i];
                
                // 获取audioUnit
                self.status = AUGraphNodeInfo(_auGraph, node->node, NULL, &node->audioUnit);
                
                // 设置属性
                [self setNodeProperty:node];
            }
        }
        
        [self makeNodeConnections];
        
        CAShow(_auGraph);

        self.status = AUGraphInitialize(_auGraph);
    }
    return self;
}

- (AudioStreamBasicDescription)noninterleavedPCMFormatWithChannels:(UInt32)channels
{
    UInt32 bytesPerSample = sizeof(Float32);
    
    AudioStreamBasicDescription asbd;
    bzero(&asbd, sizeof(asbd));
    asbd.mSampleRate = _sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    asbd.mBitsPerChannel = 8 * bytesPerSample;
    asbd.mBytesPerFrame = bytesPerSample;
    asbd.mBytesPerPacket = bytesPerSample;
    asbd.mFramesPerPacket = 1;
    asbd.mChannelsPerFrame = channels;
    return asbd;
}

- (void)setURL:(NSURL *)URL toAudioUnit:(AudioUnit)audioUnit
{
     AudioFileID musicFile;
     CFURLRef songURL = (__bridge  CFURLRef)URL;

    self.status = AudioFileOpenURL(songURL, kAudioFileReadPermission, 0, &musicFile);

     AudioStreamBasicDescription fileASBD;
     UInt32 propSize = sizeof(fileASBD);
     
     UInt64 nPackets;
     UInt32 propsize = sizeof(nPackets);
     
     AudioFileGetProperty(musicFile, kAudioFilePropertyAudioDataPacketCount,&propsize, &nPackets);
     AudioFileGetProperty(musicFile, kAudioFilePropertyDataFormat,&propSize, &fileASBD);

     ScheduledAudioFileRegion rgn;
     memset (&rgn.mTimeStamp, 0, sizeof(rgn.mTimeStamp));
     rgn.mTimeStamp.mSampleTime = 0;
     rgn.mCompletionProc = NULL;
     rgn.mCompletionProcUserData = NULL;
     rgn.mLoopCount = 0;
     rgn.mStartFrame = 0;
     rgn.mAudioFile = musicFile;
     rgn.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
     rgn.mFramesToPlay = (UInt32)nPackets * fileASBD.mFramesPerPacket; //
     
     UInt32 defaultVal = 0;

     AudioTimeStamp startTime;
     memset (&startTime, 0, sizeof(startTime));
     startTime.mFlags = kAudioTimeStampSampleTimeValid;
     startTime.mSampleTime = -1;

      self.status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_ScheduledFileIDs, kAudioUnitScope_Global, 0, &musicFile, sizeof(musicFile));
      self.status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_ScheduledFileRegion, kAudioUnitScope_Global, 0,&rgn, sizeof(rgn));
      self.status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_ScheduledFilePrime,kAudioUnitScope_Global, 0, &defaultVal, sizeof(defaultVal));
      self.status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_ScheduleStartTimeStamp,kAudioUnitScope_Global, 0, &startTime, sizeof(startTime));
}

- (void)start
{
    self.status = AUGraphStart(_auGraph);
}

- (void)stop
{
    Boolean isRunning = false;
    self.status = AUGraphIsRunning(_auGraph, &isRunning);
    
    if (isRunning) {
       self.status = AUGraphStop(_auGraph);
    }
}

- (TKFAUGraphNodeList *)initGraphNodeList;
{
    return NULL;
}

- (void)setNodeProperty:(TKFAUGraphNode *)node
{
}

- (void)makeNodeConnections
{
}
@end
