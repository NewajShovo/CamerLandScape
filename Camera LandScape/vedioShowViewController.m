//
//  vedioShowViewController.m
//  Camera LandScape
//
//  Created by Shafiq Shovo on 15/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "vedioShowViewController.h"
#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface vedioShowViewController ()
@property (weak, nonatomic) IBOutlet PlayerView *playerView;
@property (nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIButton *playAndPausButton;
@property (strong,nonatomic) AVAsset *currentAsset;
@property (weak, nonatomic) IBOutlet UISlider *progressBar;

@end

@implementation vedioShowViewController
@synthesize Label,outputPath1;
- (void)viewDidLoad {
    [super viewDidLoad];
    Label.text=outputPath1;
    NSURL *fileURL =[ [NSURL alloc] initFileURLWithPath:outputPath1];
    _currentAsset = [AVAsset assetWithURL:fileURL];
    ///NSLog(@"%@",_currentAsset);
    self.playerItem = [AVPlayerItem playerItemWithAsset:_currentAsset];
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerView.player = _player;
    self.playAndPausButton.hidden = NO;
    [_progressBar setValue:0];
   
}
#pragma mark -player Itme duration
- (CMTime)playerItemDuration
{
    AVPlayerItem *thePlayerItem = [_player currentItem];
    if (thePlayerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        
      ///  NSLog(@"%lf",time);
        return([_playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}
#pragma mark - syching with the UISlider
- (void)syncScrubber
{
    //NSLog(@"HELLO");
    CMTime playerDuration = [self playerItemDuration];
    
    if (CMTIME_IS_INVALID(playerDuration))
    {
       _progressBar.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration) && (duration > 0))
    {
        float minValue = [_progressBar minimumValue];
        double time = CMTimeGetSeconds([_playerItem duration]);
        
        float maxValue =time;
        [_progressBar setMaximumValue:time];
        NSLog(@"Duration is %f",maxValue);
        time = CMTimeGetSeconds([_player currentTime]);
        NSLog(@"Present time is %f",time);
        [_progressBar setValue:time];
        if([_progressBar value]==[_progressBar maximumValue])
        {
            [ self playAndPauseControll:_playAndPausButton withButtonState:1];
        }
    }
}
#pragma mark - play and pause button clicked;
- (IBAction)playAndPauseButton:(id)sender {
    UIButton* mybtn = ( UIButton* )sender;
    if([_progressBar value]==[_progressBar maximumValue])
    {
        [ self playAndPauseControll:_playAndPausButton withButtonState:1];
    }
    else{
    [ self playAndPauseControll:mybtn withButtonState:_player.rate];
    }
}

#pragma mark - play and pause button controll;
- (void) playAndPauseControll:(UIButton *) btn withButtonState:(float)rate {
    
    
    if (rate) {
        [self.player pause];
        [btn setTitle:@"Play" forState:UIControlStateNormal];
        if(_observer)
        {
            [_player removeTimeObserver:_observer];
            _observer = nil;
        }
    } else {
        
        double interval = .1f;
        
        CMTime playerDuration = [self playerItemDuration]; // return player duration.
        if (CMTIME_IS_INVALID(playerDuration))
        {
            return;
        }
        double duration = CMTimeGetSeconds(playerDuration);
        NSLog(@"%f",duration);
        if (isfinite(duration))
        {
            CGFloat width = CGRectGetWidth([_progressBar bounds]);
            interval = 0.1f * duration / width;
        }
        
        /* Update the scrubber during normal playback. */
        _observer=[_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                       queue:NULL
                                                  usingBlock:
                  ^(CMTime time)
                  {
                      [self syncScrubber];
                  }];
        
        
        
        [self.player play];
        [self.playAndPausButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
    
    
    
    
}



#pragma mark - slider touch event controll

- (IBAction)sliderTouched:(UISlider *)sender {
   
    [ self playAndPauseControll:_playAndPausButton withButtonState:1];
}

- (IBAction)touchUpInside:(UISlider *)sender {
    [ self playAndPauseControll:_playAndPausButton withButtonState:0];
}
- (IBAction)touchUpOutside:(UISlider *)sender {
    [ self playAndPauseControll:_playAndPausButton withButtonState:0];
}


#pragma mark - slider controll

- (IBAction)sliderControll:(id)sender {
    Float64 seconds = [_progressBar value];
  ///  NSLog(@"HELLO");
    CMTime targetTime = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
    [self.player seekToTime:targetTime
            toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    if([_progressBar value]==[_progressBar maximumValue])
    {
         [ self playAndPauseControll:_playAndPausButton withButtonState:1];
    }
}



@end
