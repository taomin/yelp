//
//  FilterViewController.m
//  yelp
//
//  Created by Taomin Chang on 9/21/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterToggleCell.h"
#import "FilterSwitchCell.h"

@interface FilterViewController ()
@property (strong, nonatomic) IBOutlet UITableView *FilterTable;
@property (strong, nonatomic) NSArray *TableConfig;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) IBOutlet UIButton *SearchButton;

@end

@implementation FilterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
   
        
        
        if (self.TableConfig == nil) {
            
            self.TableConfig =
                @[
                   [@{
                      @"type": @"switch",
                      @"section": @"Most Popular",
                      @"options": @[
                              [@{ @"name": @"Offering a deal", @"state": @YES } mutableCopy]
                                   ]
                      } mutableCopy],
                   [@{
                      @"type": @"toggle",
                      @"collapse": @YES,
                      @"section": @"Distance",
                      @"options": @[ @"Auto", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles" ],
                      @"selection": @0,
                      @"meters": @[ @0, @482, @1609, @8046, @31287]
                      } mutableCopy],
                   [@{
                      @"type": @"toggle",
                      @"collapse": @YES,
                      @"section": @"Sort by",
                      @"options": @[ @"Best Match", @"Distance", @"Rating" ],
                      @"selection": @0
                      } mutableCopy],
                   [@{
                      @"type": @"switchGroup",
                      @"collapse": @YES,
                      @"section": @"Category",
                      @"options": @[
                              [@{ @"name": @"Food", @"state": @"NO", @"value": @"food" } mutableCopy],
                              [@{ @"name": @"Health & Medical", @"state": @"NO", @"value": @"health" } mutableCopy],
                              [@{ @"name": @"Restaurants", @"state": @"YES", @"value": @"restaurants" } mutableCopy],
                              [@{ @"name": @"Financial Services", @"state": @"NO", @"value": @"financialservices" } mutableCopy],
                              [@{ @"name": @"Doctors", @"state": @"NO", @"value": @"physicians" } mutableCopy],
                              [@{ @"name": @"Home Services", @"state": @"NO", @"value": @"homeservices" } mutableCopy],
                              [@{ @"name": @"Hotels & Travel", @"state": @"NO", @"value": @"hotelstravel" } mutableCopy],
                              [@{ @"name": @"Local Services", @"state": @"NO", @"value": @"localservices" } mutableCopy],
                              [@{ @"name": @"Professional Services", @"state": @"NO", @"value": @"professional" } mutableCopy],
                              [@{ @"name": @"Nightlife", @"state": @"NO", @"value": @"nightlife" } mutableCopy],
                              [@{ @"name": @"Shopping", @"state": @"NO", @"value": @"shopping" } mutableCopy]
                                   ],
                      @"more": @3
                      } mutableCopy]
               ];
//            NSLog(@"table config is %@", self.TableConfig);
        }
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.FilterTable.delegate = self;
    self.FilterTable.dataSource = self;
    [self.FilterTable registerNib:[UINib nibWithNibName:@"FilterToggleCell" bundle:nil] forCellReuseIdentifier:@"FilterToggleCell"];
    [self.FilterTable registerNib:[UINib nibWithNibName:@"FilterSwitchCell" bundle:nil] forCellReuseIdentifier:@"FilterSwitchCell"];
    self.FilterTable.rowHeight = UITableViewAutomaticDimension;
//    [self.MainTable registerNib:[UINib nibWithNibName:@"YelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"YelpTableViewCell"];
    //lets implement 2 sections with expands rows first
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"current config: %@", self.TableConfig);
//    [self.FilterTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.TableConfig count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 300, 16)];
    headerLabel.text = self.TableConfig[section][@"section"];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0f];;
    headerLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
    [headerView addSubview:headerLabel];
    
    CGRect sepFrame = CGRectMake(0, -1, 320, 1);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [headerView addSubview:seperatorView];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    NSMutableDictionary *sectionConfig = self.TableConfig[indexPath.section];
    
    if ([sectionConfig[@"type"] isEqualToString:@"toggle"]) {
        FilterToggleCell *tableCell = [self.FilterTable dequeueReusableCellWithIdentifier:@"FilterToggleCell"];
        
        if ([sectionConfig[@"collapse"] boolValue] == YES) {
            tableCell.OptionsTitle.text = sectionConfig[@"options"][[sectionConfig[@"selection"] integerValue]];
        } else {
            tableCell.OptionsTitle.text = sectionConfig[@"options"][indexPath.row];
        }
        return tableCell;
        
    } else if ([sectionConfig[@"type"] isEqualToString:@"switch"]) {
        FilterSwitchCell *switchCell = [self.FilterTable dequeueReusableCellWithIdentifier:@"FilterSwitchCell"];
        switchCell.OptionsTitle.text = sectionConfig[@"options"][indexPath.row][@"name"];
        switchCell.Switch.on = [sectionConfig[@"options"][indexPath.row][@"state"] boolValue];
        switchCell.IndexPath = indexPath;
        switchCell.Owner = self;
        
        return switchCell;
    } else { // if ([sectionConfig[@"type"] isEqualToString:@"switchGroup") {
        //check if we should render switch cell, or the "See All" cell
        if ([sectionConfig[@"collapse"] boolValue] && indexPath.row == [sectionConfig[@"more"] integerValue]) {
            // render "See All" cell
            FilterToggleCell *seeAllCell = [self.FilterTable dequeueReusableCellWithIdentifier:@"FilterToggleCell"];
            seeAllCell.OptionsTitle.text = @"See All";
            return seeAllCell;
        } else {
            FilterSwitchCell *switchCell = [self.FilterTable dequeueReusableCellWithIdentifier:@"FilterSwitchCell"];
            switchCell.OptionsTitle.text = sectionConfig[@"options"][indexPath.row][@"name"];
            switchCell.Switch.on = [sectionConfig[@"options"][indexPath.row][@"state"] boolValue];
            switchCell.IndexPath = indexPath;
            switchCell.Owner = self;
            
            return switchCell;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //should be depends on sections
    if ([self.TableConfig[section][@"type"] isEqualToString:@"toggle"] && ([self.TableConfig[section][@"collapse"] boolValue] == YES)) {
        return 1;
    }
    
    if ([self.TableConfig[section][@"type"] isEqualToString:@"switchGroup"] && [self.TableConfig[section][@"collapse"] boolValue]) {
        return [self.TableConfig[section][@"more"] integerValue] + 1;
    }
    
    return [self.TableConfig[section][@"options"] count];
}

- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"dismissed");
    }];
}

- (IBAction)SearchClicked:(id)sender {
    [self.delegate addFilterViewController:self didFinishEnteringFilters:self.TableConfig];
    
    [self dismissViewControllerAnimated:YES completion:^{
        // NSLog(@"dismissed");
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *sectionConfig = self.TableConfig[indexPath.section];
    
    // for toggle buttons
    if ([sectionConfig[@"type"] isEqualToString:@"toggle"]) {
        
        sectionConfig[@"collapse"] = @(![sectionConfig[@"collapse"] boolValue]);
        sectionConfig[@"selection"] = @(indexPath.row);
        [tableView reloadSections: [NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // for toggleGroup
                          
    if ([sectionConfig[@"type"] isEqualToString:@"switchGroup"] && indexPath.row == [sectionConfig[@"more"] integerValue] && [sectionConfig[@"collapse"] boolValue]) {
        
        sectionConfig[@"collapse"] = @(![sectionConfig[@"collapse"] boolValue]);
        [tableView reloadSections: [NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

-(void)onSwitchValueChanged:(id)sender {

    FilterSwitchCell *cell = sender;
    NSMutableDictionary *sectionConfig = self.TableConfig[cell.IndexPath.section][@"options"][cell.IndexPath.row];
    sectionConfig[@"state"] = @(cell.on);
    NSLog(@"current config: %@", self.TableConfig);

}

@end
