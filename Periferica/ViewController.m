//
//  ViewController.m
//  Periferica
//
//  Created by fede on 4/22/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ViewController.h"
#import "VideoListVC.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "Video.h"
#import "Photo.h"
#import "CustomAnnotation.h"
#import "DetailTableViewController.h"
#import "CreditsVC.h"
#import "UIViewController+Orientation.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSMutableArray *videoList;
@property (strong,nonatomic) NSMutableArray *photoList;
@property (strong,nonatomic) NSMutableArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Add App Logo Item Navbar
    UIImage *appLogoImage = [UIImage imageNamed:@"credits_icon"];
    UIBarButtonItem *appLogoItem = [[UIBarButtonItem alloc] initWithImage:appLogoImage style:UIBarButtonItemStylePlain target:self action:@selector(toCredits)];
    NSArray *actionButtonItems = @[appLogoItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
    
    //Add List Item Navbar
    UIImage *listImage = [UIImage imageNamed:@"list_icon"];
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithImage:listImage style:UIBarButtonItemStylePlain target:self action:@selector(toVideoList)];
    self.navigationItem.rightBarButtonItem = listItem;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];  
    self.items = [[NSMutableArray alloc] init];
    
    //Set Map Coordinates to Mar Del Plata
    CLLocationCoordinate2D mdqCoordinate;
    mdqCoordinate.latitude = -38.017427;
    mdqCoordinate.longitude = -57.548695;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mdqCoordinate, 12000, 12000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Portrait
    [self setOrientation:UIInterfaceOrientationMaskPortrait];
    
    //Get Map Points
    [self authenticate];
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (id currentAnnotation in self.mapView.annotations) {
        if ([currentAnnotation isKindOfClass:[CustomAnnotation class]]) {
            [self.mapView deselectAnnotation:currentAnnotation animated:NO];
        }
    }
}

- (void)toVideoList{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoListVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"VideoList"];
    

    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
    [UIView commitAnimations];
}

- (void)toCredits{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreditsVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"Credits"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)authenticate{
    
    //Authenticate
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": User, @"password": Password};
    
    //Build Authorization Url
    NSString *authUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,AuthPath];
    
    [manager POST:authUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.token = [responseObject valueForKey:@"access_token"];
        [self getVideos:self.token];
        [self getPhotos:self.token];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)getVideos:(NSString *)token{
    
    //Get Videos
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *tokenHeaderValue = [NSString stringWithFormat:@"Token token=%@", token];
    [manager.requestSerializer setValue:tokenHeaderValue forHTTPHeaderField:@"Authorization"];
    
    //Build Video List Url
    NSString *videoListUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,VideoListPath];
    
    [manager GET:videoListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.videoList = [[NSMutableArray alloc] init];
        id videos = [responseObject valueForKey:@"videos"];
        
        for (id object in videos){
            Item *item = [Item itemWithObject:object];
            item.isVideo = YES;
            [self.videoList addObject:item];
//            NSLog(@"object: %@", object);
//            NSLog(@"item: %@", item);
        }
        
        [self addItems:self.videoList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getPhotos:(NSString *)token{
    
    //Get Videos
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *tokenHeaderValue = [NSString stringWithFormat:@"Token token=%@", token];
    [manager.requestSerializer setValue:tokenHeaderValue forHTTPHeaderField:@"Authorization"];
    
    //Build Video List Url
    NSString *photoListUrl = [NSString stringWithFormat:@"%@%@",BaseUrl,PhotoListPath];
    
    [manager GET:photoListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.photoList = [[NSMutableArray alloc] init];
        id photos = [responseObject valueForKey:@"photo"];
        
        for (id object in photos){
            Item *item = [Item itemWithObject:object];
            item.isVideo = NO;
            [self.photoList addObject:item];
        }
        
        [self addItems:self.photoList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)addItems:(NSMutableArray *)items{
    [self.items addObjectsFromArray:items];
    [self addPointsToMap:items];
}

- (void)addPointsToMap:(NSMutableArray *)items{
    // Add an annotation
    if (items.count){
        for (Item *item in items){
            if (item.poi_lat && item.poi_lon){
                CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
                CLLocationCoordinate2D myCoordinate;
                myCoordinate.latitude = [item.poi_lat doubleValue];
                myCoordinate.longitude= [item.poi_lon doubleValue];
                annotation.coordinate = myCoordinate;
                NSString *title = [item.title substringToIndex: MIN(23, [item.title length])];
                annotation.title = title;
                annotation.subtitle = item.poi_address;
                annotation.item = item;
                [self.mapView addAnnotation:annotation];
            }
        }
    }
   
}

#pragma mark MKMapViewDelegate
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    CustomAnnotation *Myannotation = annotation;
    //UIButton *advertButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[advertButton addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    /*MyPin.rightCalloutAccessoryView = advertButton;
     MyPin.draggable = YES;
     
     MyPin.animatesDrop=TRUE;
     MyPin.canShowCallout = YES;*/
    //MyPin.highlighted = NO;
    MyPin.image = [UIImage imageNamed:@"pin_icon"];
    MyPin.canShowCallout = YES;
    MyPin.calloutOffset = CGPointMake(0, 0);

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MyPin.rightCalloutAccessoryView = rightButton;
    
    // Add a custom image depending on annotation containing video or photo
    if (Myannotation.item.isVideo){
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_icon_blue"]];
        MyPin.leftCalloutAccessoryView = myCustomImage;
    }else{
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_icon_blue"]];
        MyPin.leftCalloutAccessoryView = myCustomImage;
    }
    
    return MyPin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CustomAnnotation *annotation = view.annotation;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItemDetail" bundle:nil];
    DetailTableViewController *detailView = (DetailTableViewController*)[storyboard instantiateInitialViewController];
    [detailView setItem:annotation.item];
    [detailView setToken:self.token];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
