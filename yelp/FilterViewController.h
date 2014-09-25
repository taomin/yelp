//
//  FilterViewController.h
//  yelp
//
//  Created by Taomin Chang on 9/21/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)addFilterViewController:(FilterViewController *)controller didFinishEnteringFilters:(NSArray *)filters;

@end



@interface FilterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;
-(void)onSwitchValueChanged:(id)sender;

@end
