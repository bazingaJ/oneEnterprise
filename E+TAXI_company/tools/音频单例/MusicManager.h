//
//  MusicManager.h
//  avTest
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicManager : NSObject

@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) AVPlayer *player;

+ (instancetype)shareInfo;

- (void)playAndPause;
- (void)playPrevious;
- (void)playNext;
- (void)replaceItemWithUrlString:(NSString *)urlString;
- (void)playerVolumeWithVolumeFloat:(CGFloat)volumeFloat;
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;

@end
