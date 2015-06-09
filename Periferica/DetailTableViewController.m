//
//  DetailTableViewController.m
//  Periferica
//
//  Created by nifer on 4/23/15.
//  Copyright (c) 2015 lateralview. All rights reserved.
//

#import "DetailTableViewController.h"
#import "PlayerViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"
#import "UIViewController+Orientation.h"
#import "CardboardScreenVC.h"
#import <MapKit/MapKit.h>

static CGFloat kImageOriginHight = 280.f;
#define kTitleTag 101
#define kDetailTag 102
#define kViewTag 103
#define kIconTag 201

@interface DetailTableViewController (){
    BOOL cardboardTaped;
}

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@end

@implementation DetailTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UIImage *appLogoImage = [UIImage imageNamed:@"cardboard_icon"];
    UIBarButtonItem *mapLogoItem = [[UIBarButtonItem alloc] initWithImage:appLogoImage style:UIBarButtonItemStylePlain target:self action:@selector(goToCardboard)];
    self.navigationItem.rightBarButtonItem = mapLogoItem;
    
    if (_item){
        [self getItemInfo];
        [_homeImage setImageWithURL:[NSURL URLWithString:_item.thumbnail] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self setTitle:_item.title];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set Portrait
      NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
      [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
      [self setOrientation:UIInterfaceOrientationMaskPortrait];
    
    cardboardTaped = NO;
    
    [self setAnimation];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
}

- (void)getItemInfo{
    
    //Get Video Info
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *tokenHeaderValue = [NSString stringWithFormat:@"Token token=%@", self.token];
    [manager.requestSerializer setValue:tokenHeaderValue forHTTPHeaderField:@"Authorization"];
    
    NSString *url = _item.isVideo ? [NSString stringWithFormat:@"%@videos/%@.json",BaseUrl,[_item key]] : [NSString stringWithFormat:@"%@photos/%@.json",BaseUrl,[_item key]];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _item = _item.isVideo ? [_item initVideoWithObject:responseObject] : [_item initImageWithObject:responseObject];
        _item.url = _item.isVideo ? [responseObject valueForKey:@"video_url"] : [responseObject valueForKey:@"photo_url"];
        _item.desc = [responseObject valueForKey:@"description"];
        NSDictionary *poi = [responseObject valueForKey:@"poi"];
        _item.poi_phone = poi[@"phone"];
        _item.poi_description = poi[@"description"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Detaildentifier" forIndexPath:indexPath];
    UILabel *cellTitle = (UILabel*)[cell viewWithTag:kTitleTag];
    UILabel *cellDetail = (UILabel*)[cell viewWithTag:kDetailTag];
    UIView *cellView = (UIView*)[cell viewWithTag:kViewTag];
    UIImageView *cellIcon = (UIImageView*)[cell viewWithTag:kIconTag];
    
    cellView.layer.cornerRadius = 4;
    cellView.layer.masksToBounds = YES;
    
    switch (indexPath.row) {
        case 0:
        {
            cellTitle.text = @"Descripción";
            cellDetail.text = _item.desc;
            [cellIcon setImage:[UIImage imageNamed:@"desc_icon"]];
        }
            break;
        case 1:
        {
            cellTitle.text = _item.poi_name;
            cellDetail.text = _item.poi_address;
            cellDetail.textColor = [UIColor colorWithRed:55.f/255 green:144.f/255 blue:215.f/255 alpha:1.f];
            [cellIcon setImage:[UIImage imageNamed:@"loc_icon"]];
        }
            break;
        case 2:
        {
            cellTitle.text = @"Primario";
            cellDetail.text = _item.poi_phone;
            [cellIcon setImage:[UIImage imageNamed:@"data_icon"]];
        }
            break;
        case 3:
        {
            cellTitle.text = @"Sitio Web";
            cellDetail.text = _item.poi_web;
            [cellIcon setImage:[UIImage imageNamed:@"home_icon"]];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1){
        [self openInMaps];
    }
}

-(void)openInMaps{
    // Create an MKMapItem to pass to the Maps app
    CLLocationCoordinate2D coordinate =
    CLLocationCoordinate2DMake(self.item.poi_lat.doubleValue,self.item.poi_lon.doubleValue);
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:self.item.poi_name];
    
    // Set the directions mode to "Walking"
    // Can use MKLaunchOptionsDirectionsModeDriving instead
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    // Get the "Current User Location" MKMapItem
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    // Pass the current location and destination map items to the Maps app
    // Set the direction mode in the launchOptions dictionary
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                   launchOptions:launchOptions];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"";
    switch (indexPath.row) {
        case 0:
        {
            text = _item.desc;
        }
            break;
        case 1:
        {
            text = _item.poi_address;
        }
            break;
        case 2:
        {
            text = _item.poi_phone;
        }
            break;
        case 3:
        {
            text = _item.poi_web;
        }
            break;
            
        default:
            break;
    }

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat widthSpace = screenRect.size.width - 74;
    
    float lableHeight = [self getHeightForText:text andWidth:widthSpace];
    return 59+lableHeight;
}

#pragma mark - Navigation

- (void)goToCardboard {
    cardboardTaped = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItemDetail" bundle:nil];
    CardboardScreenVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"preCardboardScreen"];
    vc.cardboard = cardboardTaped;
    vc.item = _item;
    [self.navigationController pushViewController:vc animated:true];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PlayerViewController *player = [segue destinationViewController];
    player.item = _item;
    player.cardboard = cardboardTaped;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < 0) {
        CGRect f = _homeImage.frame;
        f.origin.y = yOffset;
        f.size.height =  kImageOriginHight-yOffset;
        _homeImage.frame = f;
        _overlayView.frame = f;
        [self.contentView setNeedsDisplay];
        [self.contentView layoutIfNeeded];
    }
}

-(BOOL)shouldAutorotate
{
    return  NO;
}

#pragma mark - Aux

-(float) getHeightForText:(NSString*) text andWidth:(float) width{
    
    if ([text isEqualToString:@""]) return 0.f;
    
    UIFont *font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15.0f];
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    float totalHeight;
    
    if ([text respondsToSelector: @selector(boundingRectWithSize:options:attributes:context:)] == YES) {
        title_size = [text boundingRectWithSize: constraint options: NSStringDrawingUsesLineFragmentOrigin
                                     attributes: @{ NSFontAttributeName: font } context: nil].size;
        totalHeight = ceil(title_size.height);
    } else {
        title_size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight = title_size.height;
    }
    
    CGFloat height = MAX(totalHeight, 20.0f);
    return height;
    
}

#pragma mark - NavTransition

-(void)setAnimation
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:43/255 green:132/255 blue:210/255 alpha:1.f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:43/255 green:132/255 blue:210/255 alpha:1.f];
    [UIView animateWithDuration:0.6f animations:^{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
    }];
}

@end
