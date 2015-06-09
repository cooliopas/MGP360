//
//  CreditsVC.m
//  Periferica
//
//  Created by fede on 4/27/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "CreditsVC.h"
#import "PlayerViewController.h"
#import "Item.h"

@interface CreditsVC ()
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong,nonatomic) PlayerViewController *videoPlayerVC;

@end

@implementation CreditsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setOrientation:UIInterfaceOrientationMaskPortrait];
    [self setAnimation];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"containerVideo"]){
        self.videoPlayerVC = [segue destinationViewController];
        self.videoPlayerVC.isCredits = YES;
        Item *item = [[Item alloc] init];
        item.url = @"http://s3.amazonaws.com/truantvr360/videos/videos/000/000/003/original/parque_san_martin_logo.mp4?1429299657";
        item.isVideo = YES;
        [self.videoPlayerVC setItem:item];
    }
    
}

#pragma mark - NavTransition

-(void)setAnimation
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:43/255 green:132/255 blue:210/255 alpha:1.f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:43/255 green:132/255 blue:210/255 alpha:1.f];
    [UIView animateWithDuration:0.6f animations:^{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
    }];
}


@end
