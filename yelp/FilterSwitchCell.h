//
//  FilterSwitchCell.h
//  yelp
//
//  Created by Taomin Chang on 9/21/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface FilterSwitchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *OptionsTitle;
@property (strong, nonatomic) IBOutlet UISwitch *Switch;
@property (strong, nonatomic) FilterViewController *Owner;
@property (strong, nonatomic) NSIndexPath *IndexPath;
@property BOOL on;
@end
