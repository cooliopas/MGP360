//
//  CardboardScreenVC.m
//  Periferica
//
//  Created by fede on 4/28/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "CardboardScreenVC.h"
#import "PlayerViewController.h"
#import "UIViewController+Orientation.h"

@interface CardboardScreenVC ()
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;

@end

@implementation CardboardScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.acceptButton.layer.cornerRadius = 3;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set Portrait
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self setOrientation:UIInterfaceOrientationMaskPortrait];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    if (_cameFromPlayer)
        [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PlayerViewController *player = [segue destinationViewController];
    player.item = _item;
    player.cardboardVC = self;
    player.cardboard = YES;
}


@end
