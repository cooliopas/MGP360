//
//  CustomAnnotation.m
//  Periferica
//
//  Created by fede on 4/24/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate,title,subtitle,item;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}
@end
