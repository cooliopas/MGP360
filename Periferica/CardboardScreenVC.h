//
//  CardboardScreenVC.h
//  Periferica
//
//  Created by fede on 4/28/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface CardboardScreenVC : UIViewController
@property BOOL cardboard;
@property BOOL cameFromPlayer;
@property (strong, nonatomic) Item *item;
@end
