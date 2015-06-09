//
//  VideoListVC.m
//  Periferica
//
//  Created by fede on 4/22/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "VideoListVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "VideoCell.h"
#import "Constants.h"
#import "Video.h"
#import "Photo.h"
#import "DetailTableViewController.h"
#import "CreditsVC.h"
#import "UIViewController+Orientation.h"
#import "MBProgressHUD.h"

#define NO_NETWORK_MESSAGE @"No hay conexión a Internet."

@interface VideoListVC (){
    int apiCount; // Api calls counter, needed to know if the apps get all photos and the videos.
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSMutableArray *videoList;
@property (strong,nonatomic) NSMutableArray *photoList;
@property (strong,nonatomic) NSMutableArray *items;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImg;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@end

@implementation VideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    apiCount = 0;
    
    self.navigationItem.hidesBackButton = YES;
    //Set TableView Without Line Separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //Hide Scrollview indicator
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];  
    self.items = [[NSMutableArray alloc] init];
    
    //Hide empty view img and message label
    self.emptyImg.hidden = TRUE;
    self.emptyLabel.hidden = TRUE;
    
    [self addLogoItem];
    [self addMapItem];
    [self authenticate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Portrait
    [self setOrientation:UIInterfaceOrientationMaskPortrait];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![self isInternetReachable]) {
        self.emptyImg.hidden = FALSE;
        self.emptyLabel.hidden = FALSE;
        self.emptyLabel.text = NO_NETWORK_MESSAGE;
        [self.tableView setHidden:YES];
        return;
    }
}

- (void)addLogoItem{
    //Add App Logo Item Navbar
    UIImage *appLogoImage = [UIImage imageNamed:@"credits_icon"];
    UIBarButtonItem *appLogoItem = [[UIBarButtonItem alloc] initWithImage:appLogoImage style:UIBarButtonItemStylePlain target:self action:@selector(toCredits)];
    NSArray *actionButtonItems = @[appLogoItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems;
}

- (void)addMapItem{
    //Add Map Item Navbar
    UIImage *appLogoImage = [UIImage imageNamed:@"pin_icon_menu"];
    UIBarButtonItem *mapLogoItem = [[UIBarButtonItem alloc] initWithImage:appLogoImage style:UIBarButtonItemStylePlain target:self action:@selector(toMap)];
    self.navigationItem.rightBarButtonItem = mapLogoItem;
}

- (void)toMap{
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:authUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        self.token = [responseObject valueForKey:@"access_token"];
        [self getAllItems];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)getAllItems
{
    self.videoList = [NSMutableArray array];
    self.photoList = [NSMutableArray array];
    self.items = [NSMutableArray array];
    [self getVideos:self.token];
    [self getPhotos:self.token];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET:videoListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        self.videoList = [[NSMutableArray alloc] init];
        id videos = [responseObject valueForKey:@"videos"];
        
        for (id object in videos){
            Item *video = [Item itemWithObject:object];
            video.isVideo = YES;
            [self.videoList addObject:video];
        }
        apiCount++;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET:photoListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"JSON: %@", responseObject);
        self.photoList = [[NSMutableArray alloc] init];
        id photos = [responseObject valueForKey:@"photo"];
        
        for (id object in photos){
            Item *photo = [Item itemWithObject:object];
            photo.isVideo = NO;
            [self.photoList addObject:photo];
        }
        apiCount++;
        [self addItems:self.photoList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)addItems:(NSMutableArray *)items{
    [self.items addObjectsFromArray:items];
    if (apiCount >=2){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        apiCount = 0;
        self.items = [[self sortList:self.items] mutableCopy];
        [self.tableView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItemDetail" bundle:nil];
    DetailTableViewController *detailView = (DetailTableViewController*)[storyboard instantiateInitialViewController];
    
    Item *item = [self.items objectAtIndex:indexPath.row];
    detailView.item = item;
    detailView.token = self.token;
    [self.navigationController pushViewController:detailView animated:YES];
    
}

- (NSArray*)sortList:(NSArray*)array
{
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Item *item1 = (Item*)obj1;
        Item *item2 = (Item*)obj2;
        return [item1 compareInListWith:item2];
    }];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Item *item = [self.items objectAtIndex:indexPath.row];
    cell.videoTitle.text = item.title;
    cell.videoAddress.text = item.poi_address;
    
    UIImage *icon;
    if (item.isVideo) {
        icon = [UIImage imageNamed: @"video_icon"];
    }else{
        icon = [UIImage imageNamed: @"camera_icon"];
    }
    cell.icon.image = icon;
    cell.videoThumbnail.clipsToBounds = YES;
    [cell.videoThumbnail setImageWithURL:[NSURL URLWithString:item.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(BOOL) isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    VideoDetailVC *vc = [segue destinationViewController];
//    vc.video = [self.videoList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
//    vc.token = self.token;
//}


@end
