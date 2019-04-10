//
//  ImageViewController.m
//  Camera LandScape
//
//  Created by Shafiq Shovo on 10/4/19.
//  Copyright © 2019 Shafiq Shovo. All rights reserved.
//

#import "ImageViewController.h"
#import "AppDelegate.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setAlpha:0.0];
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem *backButton = [ [ UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = backButton;
    _ImageView.image = _Image;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction) Back
{
    [self.navigationController popViewControllerAnimated:NO];
}


@end
