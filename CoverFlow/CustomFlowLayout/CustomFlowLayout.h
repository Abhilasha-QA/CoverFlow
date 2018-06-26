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

//... call when cell move left
- (void)cellDidMovedLeft:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//... call when cell move right
- (void)cellDidMovedRight:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//... call when cell not move
- (void)cellDidNotMoved:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//... check cell should move up or not
- (BOOL)shouldCellMoveUpForIndexPath:(NSIndexPath *)indexpath;

@end

@interface CustomFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>
@property id <FlowLayoutDelegate> delegate;

@end
