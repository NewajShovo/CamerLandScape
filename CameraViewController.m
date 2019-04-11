//
//  ViewController.m
//  Camera LandScape
//
//  Created by Shafiq Shovo on 8/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "CameraViewController.h"
#import   <AVFoundation/AVFoundation.h>
#import "ImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraViewController ()
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureDevice *device;
@property (nonatomic) AVCaptureDeviceInput *input;
@property (nonatomic) AVCaptureMovieFileOutput *MovieFileOutput;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic)  AVCapturePhotoOutput* output;


@end

@implementation CameraViewController
int a=0;
BOOL WeAreRecording;
@synthesize CameraView;
@synthesize session,previewLayer,device,input,output,MovieFileOutput;

#pragma mark - rotation will stop
-(BOOL)shouldAutorotate{
    return NO;
}


#pragma mark - veiwDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    WeAreRecording = 0;
    self.navigationController.navigationBarHidden=YES;
    
    // Do any additional setup after loading the view, typically from a nib
    //AVCaptureSession *session= [ [ AVCaptureSession alloc] init];
    
    session = [ [ AVCaptureSession alloc] init];
    device = [ AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    input = [ AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //stillImageOutput = [ [AVCapturePhotoOutput alloc] init];
    if(!input)
        
    {
        NSLog(@"No Input");
    }
    
    [session addInput:input];
    output = [[AVCapturePhotoOutput alloc] init];
    MovieFileOutput = [ [ AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 60;
    int32_t preferredTimeScale = 30;
    
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);
    MovieFileOutput.maxRecordedDuration = maxDuration;
    MovieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    
    [session addOutput:output];
    [session addOutput:MovieFileOutput];
    
    previewLayer  = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    UIView *view = self.view;
    previewLayer.frame = view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [CameraView.layer addSublayer:previewLayer];
    
    
    
    //Start capture session
    [session startRunning];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
-(void)OrientationDidChange:(NSNotification*)notification {
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];
    CGFloat angle;
    if(Orientation==UIDeviceOrientationLandscapeLeft) {
        a=1;
        angle = M_PI;
        //device=//UIDeviceOrientationLandscapeRight;
        NSLog(@"LandscapeLeft");
    } else if(Orientation==UIDeviceOrientationPortrait) {
        a=2;
        angle = M_PI_2;
        NSLog(@"Potrait Mode");
    }
    else if( UIDeviceOrientationLandscapeRight)
    {
        a=3;
        //angle = - M_PI_2;
        NSLog(@"LandscapeRight");
    }
    //    [UIView animateWithDuration:.2 animations:^{
    //        self.swipeCamera.transform = CGAffineTransformMakeRotation(angle);
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

//
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        self->previewLayer.frame = self.view.bounds;
        self->previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    } completion:^(id  _Nonnull context) {
        NSLog(@"changed");
        
        if(size.height == 375 && a==3 ){
            NSLog(@"XYZ");
            self->previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        }else if(size.height==375&& a==1)
        {
            NSLog(@"XYZ2");
            self->previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        }else {
            
            self->previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        }
        
        
        // after rotation
        [self->CameraView.layer addSublayer:self->previewLayer];
    }];
    
}
/*
 AVCapturePhotoSettings *photoSettings =[ [ AVCapturePhotoSettings alloc] init];
 
 NSLog(@"Hello");
 id previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject;
 NSDictionary *format = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:previewPixelType,(NSString*)kCVPixelBufferWidthKey:@160,(NSString*)kCVPixelBufferHeightKey:@160};
 photoSettings.previewPhotoFormat = format;
 
 [output capturePhotoWithSettings:photoSettings  delegate:self];
 */

#pragma mark - Button clicked
- (IBAction)Buttonclicked:(id)sender {
    
    if (!WeAreRecording)
    {
        NSLog(@"Start Recording");
        WeAreRecording = YES;
        
        NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@",NSTemporaryDirectory(), @"output.mov"];
        NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outputPath])
        {
            NSError *error;
            if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
            {
                //Error - handle if requried
            }
        }
        
            [MovieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
        //start Recording
  
        
    } else
    {
        NSLog(@"Stop Recording");
        [MovieFileOutput stopRecording];
    }
    
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    
    NSLog(@"%@",outputFileURL);
    NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
    
    BOOL RecordedSuccessfully = YES;
    NSLog(@"%@",[error localizedDescription]);
    if ([error code] != noErr)
    {
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
        {
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully)
    {
        //----- RECORDED SUCESSFULLY -----
        NSLog(@"didFinishRecordingToOutputFileAtURL - success");
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL])
        {
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {

                 }
                 else{
                     NSLog(@"Completed");
                 }
             }];
        }

        ///[library release];
        
    }
}


#pragma mark AVCapturePhotoCaptureDelegate
-(void)captureOutput:(AVCapturePhotoOutput *)captureOutput
didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer
previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer
    resolvedSettings:(nonnull AVCaptureResolvedPhotoSettings *)resolvedSettings
     bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings
               error:(nullable NSError *)error
{







    NSLog(@"I am here");
    NSData* photoData = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer
                                                                    previewPhotoSampleBuffer:previewPhotoSampleBuffer];

    if(a==2)
    {
        NSLog(@"Device is Potrait");

    }
    else if(a==1) {
        NSLog(@"Device is LandScapeLeft");
    }
    else if(a==3)
    {
        NSLog(@"Device is LandScapeRight");
    }
    UIImage *image = [UIImage imageWithCGImage:[[[UIImage alloc] initWithData:photoData] CGImage]
                                         scale:1.0f
                                   orientation:[self currentOrientation]];

    ImageViewController *second = [ [ ImageViewController alloc ] init];
    second.Image = image;

    [self.navigationController pushViewController:second animated:YES];
    //UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);
}




- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden= YES;
}
-(UIImageOrientation) currentOrientation{
    UIImageOrientation curOrientation ;
    if(a== 1 ){
        curOrientation = UIImageOrientationUp;
        
    }else if(a== 2 ){
        curOrientation = UIImageOrientationRight;
    }else {
        curOrientation = UIImageOrientationDown;
        
    }
    
    return curOrientation;
    
}
@end



