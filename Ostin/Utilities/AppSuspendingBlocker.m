//
//  AppSuspendingBlocker.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 16/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AppSuspendingBlocker.h"
#import <AVFoundation/AVFoundation.h>

@interface AppSuspendingBlocker ()
{
    AVAudioPlayer *_player;
    NSTimer *_timer;
}
@end

@implementation AppSuspendingBlocker

- (void)startBlock
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interuptedAudio:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [self playAudio];
}

- (void)stopBlock
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [_player stop];
}

- (void)interuptedAudio:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"AVAudioSessionInterruptionNotification"] && notification.userInfo != nil)
    {
        NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
        if ([interruptionType integerValue] == 1)
            [self playAudio];
    }
}

- (void)playAudio
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emptySound" ofType:@"wav"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _player.numberOfLoops = -1;
    _player.volume = 0.01;
    
    [_player prepareToPlay];
    [_player play];
}

@end
