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

//@property (weak, nonatomic) AVMutableComposition *composition;
@property (weak, nonatomic) AVMutableComposition *mixAsset;
@property (weak, nonatomic) AVMutableCompositionTrack *videotrack;
@property (weak, nonatomic) AVMutableCompositionTrack *audiotrack;


@end

@implementation vedioShowViewController
@synthesize Label,outputPath1;
- (void)viewDidLoad {
    [super viewDidLoad];
    Label.text=outputPath1;
    
    
    
    
    
    
    
    
    
    
    
    
    NSURL *fileURL =[ [NSURL alloc] initFileURLWithPath:outputPath1];
//    _currentAsset = [AVAsset assetWithURL:fileURL];
    ///NSLog(@"%@",_currentAsset);
//    self.playerItem = [AVPlayerItem playerItemWithAsset:_currentAsset];
   
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"Toccata-and-Fugue-Dm.mp3" withExtension:nil];
    
    /*
    AVAsset *audioAsset = [ AVAsset assetWithURL:audioURL];
    AVAsset *videoAsset = [AVAsset assetWithURL:fileURL];
    NSLog(@"%@",videoAsset);
    CGAffineTransform txf = [videoAsset preferredTransform];
    CMTime duration = [videoAsset duration];
    
    
    NSError *error;
    
    AVMutableComposition* mixAsset = [AVMutableComposition composition];
    
    AVMutableCompositionTrack* audioTrack = [mixAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] lastObject] atTime:kCMTimeZero error: &error];
    
    AVMutableCompositionTrack* videoTrack = [mixAsset addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] lastObject] atTime:kCMTimeZero error: &error];
    
    CGSize size = [ videoTrack naturalSize];
*/
    
    NSError *error = nil;
    AVURLAsset *videoAssetURL = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVURLAsset *audioAssetURL = [ [ AVURLAsset alloc] initWithURL:audioURL options:nil];
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoTrack = [[videoAssetURL tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[audioAssetURL tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:videoTrack atTime:kCMTimeZero error:&error];
    if (videoTrack && compositionVideoTrack) {
        [compositionVideoTrack setPreferredTransform:videoTrack.preferredTransform];
    }
    //CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(M_PI);
  //  videoTrack.preferredTransform = CGAffineTransformMakeRotation(M_PI);
    //videoTrack.prefferedTransform =
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
    
    /*
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = fileURL;
    NSLog(@"%@",exportSession.outputURL);
    exportSession.outputFileType = AVFileTypeQuickTimeMovie; //very important select you video format (AVFileTypeQuickTimeMovie, AVFileTypeMPEG4, etc...)
    exportSession.videoComposition = videoComposition;
    exportSession.shouldOptimizeForNetworkUse = NO;
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetURL.duration);
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exportSession status]) {
                
            case AVAssetExportSessionStatusCompleted: {
                
                NSLog(@"Triming Completed");
                
                //generate video thumbnail
                ///self.videoUrl = exportSession.outputURL;
                AVURLAsset *videoAssetURL = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
                AVAssetImageGenerator *genrateAsset = [[AVAssetImageGenerator alloc] initWithAsset:videoAssetURL];
                genrateAsset.appliesPreferredTrackTransform = YES;
                CMTime time = CMTimeMakeWithSeconds(0.0,600);
                NSError *error = nil;
                CMTime actualTime;
                
                CGImageRef cgImage = [genrateAsset copyCGImageAtTime:time actualTime:&actualTime error:&error];
                //self.videoImage = [[UIImage alloc] initWithCGImage:cgImage];
                CGImageRelease(cgImage);
                
                break;
            }
            default: {
                break;
            }
        }
    }];
    
    
    */
    
    
    _playerItem = [AVPlayerItem playerItemWithAsset:composition];
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _playerView.player = _player;
    self.playAndPausButton.hidden = NO;
    [_progressBar setValue:0];
    
    
   
}
#pragma mark -player Item duration
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
            [_progressBar setValue:0];
            CMTime targetTime=CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
            [self.player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
            [ self playAndPauseControll:_playAndPausButton withButtonState:1];
        }
    }
}
#pragma mark - play and pause button clicked;
- (IBAction)playAndPauseButton:(id)sender {
    UIButton* mybtn = ( UIButton* )sender;
    if([_progressBar value]==[_progressBar maximumValue])
    {
        [ _progressBar setValue:0];
        CMTime targetTime=CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
         [self.player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
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
        [_progressBar setValue:0];
        targetTime=CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
        [self.player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        ///[_player currentTime:0]
        [ self playAndPauseControll:_playAndPausButton withButtonState:1];
    }
}




@end
