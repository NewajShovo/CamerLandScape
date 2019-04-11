//
//  CameraViewController.h
//  Camera LandScape
//
//  Created by Shafiq Shovo on 10/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CameraViewController : UIViewController <AVCapturePhotoCaptureDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *CameraView;
- (IBAction)Buttonclicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *camButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

//@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@end

NS_ASSUME_NONNULL_END
