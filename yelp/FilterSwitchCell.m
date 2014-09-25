//
//  FilterSwitchCell.m
//  yelp
//
//  Created by Taomin Chang on 9/21/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "FilterSwitchCell.h"

@implementation FilterSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onToggle:(UISwitch *)sender forEvent:(UIEvent *)event {
//    NSLog(@"sender on which row and on/off ?: %d, %d, %i", self.IndexPath.section, self.IndexPath.row, sender.on);
    self.on = sender.on;
    [self.Owner performSelector:@selector(onSwitchValueChanged:) withObject:self afterDelay:0];
}

@end
