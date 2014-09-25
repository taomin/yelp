//
//  MainViewController.h
//  yelp
//
//  Created by Taomin Chang on 9/20/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FilterViewControllerDelegate>

@end
