//
//  Item.m
//  Periferica
//
//  Created by nifer on 4/27/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "Item.h"



@implementation Item

-(id)initVideoWithObject:(id)object {
    Item *obj = [self initWithObject:object];
    obj.isVideo = YES;
    return obj;
}

-(id)initImageWithObject:(id)object
{
    Item *obj = [self initWithObject:object];
    obj.isVideo = NO;
    return obj;
}

-(id)initWithObject:(id)object
{
    if (self = [super init]) {
        self.key = [object valueForKey:@"id"];
        self.thumbnail = [object valueForKey:@"thumbnail"];
        self.title = [object valueForKey:@"title"];
        self.file_name = [object valueForKey:@"video_file_name"];
        self.file_size = [object valueForKey:@"video_file_size"];
        
        NSString *poiString = [NSString stringWithFormat:@"%@",object[@"poi"]];
        if ([poiString isEqualToString:@"<null>"])
            return self;
        
        self.poi_address = object[@"poi"][@"address"];
        
        NSString *lat = (NSString *)object[@"poi"][@"lat"];
        NSString *poi_lat = [NSString stringWithFormat:@"%@",lat];
        if (![poi_lat isEqualToString:@"<null>"]){
            self.poi_lat = object[@"poi"][@"lat"];
        }else{
            self.poi_lat = nil;
        }
        NSString *lon = (NSString *)object[@"poi"][@"lon"];
        NSString *poi_lon = [NSString stringWithFormat:@"%@",lon];
        if (![poi_lon isEqualToString:@"<null>"]){
            self.poi_lon = object[@"poi"][@"lon"];
        }else{
            self.poi_lon = nil;
        }
        self.poi_name = object[@"poi"][@"name"];
        self.poi_phone = object[@"poi"][@"phone"];
        self.poi_description = object[@"poi"][@"description"];
        self.poi_web = [[NSString stringWithFormat:@"%@",object[@"poi"][@"web"]] isEqualToString:@"<null>"] ? @"" : object[@"poi"][@"web"];
        
    }
    return self;
}

// Compare items
- (NSComparisonResult) compareInListWith:(Item *)item
{
    NSComparisonResult res = [[self.title lowercaseString] compare:[item.title lowercaseString]];
    return res;
}

+ (Item *)itemWithObject:(id)object
{
    return [[Item alloc] initWithObject:object];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Item %@ %@",self.title,(self.isVideo ? @"video" : @"photo")];
}

@end
