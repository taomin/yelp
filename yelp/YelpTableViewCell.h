//
//  YelpTableViewCell.h
//  yelp
//
//  Created by Taomin Chang on 9/20/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Thumbnail;
@property (strong, nonatomic) IBOutlet UILabel *RestaurantName;
@property (strong, nonatomic) IBOutlet UILabel *RestaurantAddr;
@property (strong, nonatomic) IBOutlet UILabel *RestaurantType;
@property (strong, nonatomic) IBOutlet UIImageView *RestaurantRating;
@property (strong, nonatomic) IBOutlet UILabel *RestaurantReviews;

@end
