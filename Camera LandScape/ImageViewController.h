//
//  ImageViewController.h
//  Camera LandScape
//
//  Created by Shafiq Shovo on 10/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong,nonatomic) UIImage *Image;
@end

NS_ASSUME_NONNULL_END
