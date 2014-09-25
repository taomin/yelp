//
//  MainViewController.m
//  yelp
//
//  Created by Taomin Chang on 9/20/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "MainViewController.h"
#import "UIImageView+AFNetworking.h"
#import "YelpTableViewCell.h"
#import "YelpClient.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *MainTable;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) NSArray *filterConfig;
@property (strong, nonatomic) NSString *term;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *cll;
@end

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filterConfig = nil;
        self.term = @"Thai"; // default query term;
        self.location = @"San Francisco"; // default location
        self.cll = @"37.776095, -122.421088"; //defeault lat/lon
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];

        NSDictionary *config = @{@"term": @"Thai", @"location" : @"San Francisco"};
        [self doSearch: config];
            }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search";
    
    self.navigationController.navigationBar.backgroundColor =  [UIColor colorWithRed:150 green:20 blue:20 alpha:1];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(onFilterButton)];
    filterButton.tintColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    self.navigationItem.leftBarButtonItem = filterButton;
    
    self.MainTable.delegate = self;
    self.MainTable.dataSource = self;
    [self.MainTable registerNib:[UINib nibWithNibName:@"YelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"YelpTableViewCell"];
    self.MainTable.rowHeight = UITableViewAutomaticDimension;
    self.MainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // add search bar
    self.SearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 63, 320, 44)];
    self.SearchBar.delegate = self;
    self.SearchBar.placeholder = @"Thai";
    self.navigationItem.titleView = self.SearchBar;
    
}

- (void)onFilterButton {
    FilterViewController *filterView = [FilterViewController new];
    
    filterView.delegate = self;
    
    [self.navigationController presentViewController:filterView animated:YES completion:^{
        NSLog(@"load modal view");
    }];

}

- (void)addFilterViewController:(FilterViewController *)controller didFinishEnteringFilters:(NSArray *)filters {
    
    self.filterConfig = filters;
    [self doSearch:[self formatSearchConfig]];
    
}

- (NSMutableDictionary *)formatSearchConfig {
    
    
    NSMutableDictionary *config = [@{
                                     @"term": self.term,
                                     @"location": self.location,
                                     @"cll": self.cll
                                     } mutableCopy];
    
    if (self.filterConfig != nil) {
        [config setValue:self.filterConfig[2][@"selection"] forKey:@"sort"];
        [config setValue:self.filterConfig[3][@"id"][[self.filterConfig[3][@"selection"] integerValue]] forKey:@"category"];
    
        NSInteger radius = [self.filterConfig[1][@"meters"][[self.filterConfig[1][@"selection"] integerValue]] integerValue];
        
        if (radius != 0) {
            [config setValue:@(radius) forKey:@"radius_filter"];
        }
        
        BOOL deals = [self.filterConfig[0][@"options"][0][@"state"] boolValue];
        if (deals) {
            [config setValue:@(deals) forKey:@"deals_filter"];
        }
        
        NSMutableArray *categories = [@[] mutableCopy];
        for (NSMutableDictionary *category in self.filterConfig[3][@"options"]) {
            if ([category[@"state"] boolValue]) {
                [categories addObject:category[@"value"]];
            }
        }
        if ([categories count] > 0) {
            [config setValue:[categories componentsJoinedByString:@","] forKey:@"category_filter"];
        }
        
    }
    NSLog(@"now we have query settings: %@", config);
    return config;

}

- (void)doSearch:(NSDictionary *)config {

    [self.client searchWithConfigs:config success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSDictionary *resp = response;
        self.restaurants = resp[@"businesses"];
        NSLog(@"data, %@", self.restaurants);
        [self.MainTable reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.restaurants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *restaurant = self.restaurants[indexPath.row];

    YelpTableViewCell *tableCell = [self.MainTable dequeueReusableCellWithIdentifier:@"YelpTableViewCell"];

    tableCell.RestaurantName.text = restaurant[@"name"];
    tableCell.RestaurantName.font = [UIFont boldSystemFontOfSize:14.0f];
    tableCell.RestaurantAddr.text = [restaurant[@"location"][@"address"] componentsJoinedByString:@" "];
    tableCell.RestaurantReviews.text = [NSString stringWithFormat:@"%d Reviews", [restaurant[@"review_count"] integerValue]];
    tableCell.RestaurantReviews.font = [UIFont systemFontOfSize:11.0f];
    
    tableCell.RestaurantType.text = restaurant[@"categories"][0][0];
    [tableCell.Thumbnail setImageWithURL:[NSURL URLWithString:restaurant[@"image_url"]]];
    [tableCell.RestaurantRating setImageWithURL:[NSURL URLWithString:restaurant[@"rating_img_url"]]];
    [[tableCell.Thumbnail layer] setCornerRadius:4.0f];
    [[tableCell.Thumbnail layer] setMasksToBounds:YES];
    return tableCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.MainTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.term = searchBar.text;
    [self.view endEditing:YES];

    // reloading search results
    [self doSearch:[self formatSearchConfig]];
}


@end
