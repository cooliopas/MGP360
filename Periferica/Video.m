//
//  Video.m
//  Periferica
//
//  Created by fede on 4/22/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "Video.h"

@implementation Video

-(id)initWithObject:(id)object {
    if (self = [super init]) {
        self.vId = [object valueForKey:@"id"];
        self.thumbnail = [object valueForKey:@"thumbnail"];
        self.title = [object valueForKey:@"title"];
        self.file_name = [object valueForKey:@"video_file_name"];
        self.file_size = [object valueForKey:@"video_file_size"];
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

+ (Video *)videoWithObject:(id)object
{
    return [[Video alloc] initWithObject:object];
}

@end
