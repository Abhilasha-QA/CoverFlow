//
//  CustomFlowLayout.h
//  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory All rights reserved.

#import <UIKit/UIKit.h>

@protocol FlowLayoutDelegate <NSObject>

//... call when cell move up
- (void)cellDidMovedUp:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;


//... check cell should move up or not
- (BOOL)shouldCellMoveUpForIndexPath:(NSIndexPath *)indexpath;

@end

@interface CustomFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>
@property id <FlowLayoutDelegate> delegate;

@end
