//
//  CustomAnnotation.h
//  Periferica
//
//  Created by fede on 4/24/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Item.h"

@interface CustomAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    Item *item;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) Item *item;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


- (id)initWithLocation:(CLLocationCoordinate2D)coord;

// Other methods and properties.
@end
