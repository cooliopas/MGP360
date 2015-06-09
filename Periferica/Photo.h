//
//  Photo.h
//  Periferica
//
//  Created by fede on 4/23/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

    @property NSString *pId;
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
    @property NSString *poi_description;


    - (id)initWithObject:(id)object;
    + (Photo *)photoWithObject:(id)object;

@end
