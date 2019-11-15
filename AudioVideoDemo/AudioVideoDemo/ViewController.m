//
//  ViewController.m
//  AudioVideoDemo
//
//  Created by tangkaifu on 2019/11/15.
//  Copyright © 2019 com.lizhi.tangkaifu. All rights reserved.
//

#import "ViewController.h"
#import "TKFAudioPlayer.h"
#import "TKFMixerAudioPlayer.h"
#import "TKFKTVRecordPlayer.h"

@interface TKFItem : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) void(^didClickBlock)(void);
@end

@implementation TKFItem
@end

@interface ViewController ()
@property (nonatomic, strong) NSArray <TKFItem *> *itmes;
@property (nonatomic, strong)  TKBaseAudio *audioTool;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.itmes = [self crateItems];
}

- (NSArray<TKFItem *> *)crateItems
{
    __weak typeof(self) weakSelf = self;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"output.aac" ofType:nil];
    NSURL *URL =  [NSURL URLWithString:path];
    
    TKFItem *item0 = [[TKFItem alloc] init];
    item0.title = @"测试播放";
    [item0 setDidClickBlock:^(void) {
        weakSelf.audioTool = [[TKFAudioPlayer alloc] initWithURL:URL];
        [weakSelf.audioTool start];
    }];

    
    TKFItem *item1 = [[TKFItem alloc] init];
    item1.title = @"测试混音";
    [item1 setDidClickBlock:^(void) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"beatsMono.caf" ofType:nil];
        NSURL *URL1 =  [NSURL URLWithString:path];
        
        weakSelf.audioTool = [[TKFMixerAudioPlayer alloc] initWithURL:URL URL1:URL1];;
        [weakSelf.audioTool start];
    }];
    
    TKFItem *item2 = [[TKFItem alloc] init];
    item2.title = @"测试耳返和混音功能";
    [item2 setDidClickBlock:^(void) {
        weakSelf.audioTool = [[TKFKTVRecordPlayer alloc] initWithPlayURL:URL outputPath:nil];
        [weakSelf.audioTool start];
    }];
    return @[item0, item1, item2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itmes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TKFItem *item = self.itmes[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = item.title;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TKFItem *item = self.itmes[indexPath.row];
    if(item.didClickBlock) {
        item.didClickBlock();
    }
}

@end
