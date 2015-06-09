//
//  Item.h
//  Periferica
//
//  Created by nifer on 4/27/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property NSString *key;
@property NSString *thumbnail;
@property NSString *title;
@property NSString *file_name;
@property NSString *file_size;
@property NSString *url;
@property NSString *desc;

@property NSString *poi_address;
@property NSString *poi_lat;
@property NSString *poi_lon;
@property NSString *poi_name;
@property NSString *poi_phone;
@property NSString *poi_web;
@property NSString *poi_description;
@property BOOL isVideo;


-(id)initVideoWithObject:(id)object;
-(id)initImageWithObject:(id)object;
+(Item *)itemWithObject:(id)object;
-(NSComparisonResult) compareInListWith:(Item *)item;

@end
