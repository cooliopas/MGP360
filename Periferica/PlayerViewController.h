//
//  PlayerViewController.h
//  Periferica
//
//  Created by nifer on 4/24/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Orientation.h"
#import "CardboardScreenVC.h"
#import "Item.h"

@interface PlayerViewController : UIViewController

@property (strong, nonatomic) Item *item;
@property BOOL cardboard;
@property BOOL isCredits;
@property (assign, nonatomic) CardboardScreenVC *cardboardVC;

@end
