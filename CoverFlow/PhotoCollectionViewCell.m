//
//  MyFeedCollectionViewCell.m
//  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory. All rights reserved.

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _lblReload.layer.borderColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0].CGColor;
    _lblReload.layer.borderWidth = 2.0f;
    
    _lblReload.layer.cornerRadius = self.layer.cornerRadius = 6.0f;
    _lblReload.layer.masksToBounds = self.layer.masksToBounds = YES;

}


@end
