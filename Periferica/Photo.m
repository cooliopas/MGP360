//
//  Photo.m
//  Periferica
//
//  Created by fede on 4/23/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(id)initWithObject:(id)object {
    if (self = [super init]) {
        self.pId = [object valueForKey:@"id"];
        self.thumbnail = [object valueForKey:@"thumbnail"];
        self.title = [object valueForKey:@"title"];
        self.file_name = [object valueForKey:@"photo_file_name"];
        self.file_size = [object valueForKey:@"photo_file_size"];
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
        
    }
    return self;
}

+ (Photo *)photoWithObject:(id)object
{
    return [[Photo alloc] initWithObject:object];
}

@end
