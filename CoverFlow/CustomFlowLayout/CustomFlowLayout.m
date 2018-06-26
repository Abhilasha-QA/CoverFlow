//
//  CustomFlowLayout.m
//  CoverFlow
//
//  Created by Mindinventory on 6/12/17.
//  Copyright © 2017 MindInventory. All rights reserved.

#import "CustomFlowLayout.h"

#define ITEM_SPACING    0.0
#define EDGE_OFFSET     0.0

#define minimumXPanDistanceToSwipe      100.0
#define minimumYPanDistanceToSwipe      200.0
#define StackMaximumSize                3
#define CellOffset                      10
#define MaxItemY                        70
#define CellPadding                     0
#define minimumDistanceLikeUnlike       35  // Display like and unlike button according this value

#define ROTATION_STRENGTH               100 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle

#define CViewWidth(v)                        v.frame.size.width
#define CViewHeight(v)                       v.frame.size.height



@interface CustomFlowLayout ()
{
    NSIndexPath *draggedItemPath;
    
    CGPoint initialItemCenter;
}

@end

@implementation CustomFlowLayout 

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.collectionView.numberOfSections == 0)
        return;
    
    // Add Pan Gesture to Collection view
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
   [self.collectionView addGestureRecognizer:panGesture];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
   
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (int itemIndex = 0; itemIndex < numberOfItems; itemIndex ++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
        UICollectionViewLayoutAttributes *cellAttribs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:cellAttribs];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat xPosition = CellPadding;
    CGFloat yPosition = 0.0f;
    
    if (indexPath.row < StackMaximumSize && indexPath.row < numberOfItems-1)
    {
        CGFloat maxYPosition = CellOffset*(StackMaximumSize - (indexPath.row+1));
        xPosition = CellOffset*(attributes.indexPath.row);
        yPosition = maxYPosition;//MIN(yPosition, maxYPosition);
        attributes.hidden = NO;
    }
    else
    {
        attributes.hidden = numberOfItems > 1;
    }
    
    CGFloat cWidth = CViewWidth(self.collectionView) - xPosition*2;
    CGFloat cHeight = CViewHeight(self.collectionView) - CellOffset*(StackMaximumSize - 1);
    
    attributes.zIndex = numberOfItems - indexPath.item;
  
    attributes.frame = CGRectMake(xPosition, yPosition, cWidth, cHeight);
   
    return attributes;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint initialPoint = [sender locationInView:self.collectionView];
            [self findDraggingCellByCoordinate:initialPoint];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint newCenter = [sender translationInView:self.collectionView];
            [self updateCenterPositionOfDraggingCell:newCenter];
            break;
        }
        default:
        {
            
            // Release pan gesture
            if (draggedItemPath)
                [self finishedDragging:[self.collectionView cellForItemAtIndexPath:draggedItemPath]];
            
            break;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL result = YES;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGesture velocityInView:self.collectionView];
        result = abs((int)velocity.y) < 250;
    }
    return result;
}



- (void)findDraggingCellByCoordinate:(CGPoint)coordinate
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    if (indexPath)
    {
        //... Find cell for pan gesture tapped coordinate
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell)
        {
            draggedItemPath = indexPath;
            initialItemCenter = cell.center;
            
            [self.collectionView bringSubviewToFront:cell];
        }
    }
}

- (void)updateCenterPositionOfDraggingCell:(CGPoint)coordinate
{
    if (draggedItemPath && draggedItemPath.row == 0 && coordinate.y < 0)
    {
        if ([self.delegate respondsToSelector:@selector(shouldCellMoveUpForIndexPath:)])
        {
            if(![self.delegate shouldCellMoveUpForIndexPath:draggedItemPath])
                return;
        }
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:draggedItemPath];
        
        if (cell)
        {
         
            NSLog(@"coordinate %@", NSStringFromCGPoint(coordinate));
            
            CGFloat newCenterX = initialItemCenter.x + coordinate.x;
            CGFloat newCenterY = initialItemCenter.y + coordinate.y;
            cell.center = CGPointMake(newCenterX, newCenterY);
            
            CGFloat rotationStrength = coordinate.x / ROTATION_STRENGTH;
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% apply transformations
            cell.transform = transform;
            
            //Check cell move left or Right
            if (coordinate.x > minimumDistanceLikeUnlike) {
                if ([self.delegate respondsToSelector:@selector(cellDidMovedRight:indexPath:)])
                    [self.delegate cellDidMovedRight:cell indexPath:draggedItemPath];
            }else if (coordinate.x < -(minimumDistanceLikeUnlike))
            {
                if ([self.delegate respondsToSelector:@selector(cellDidMovedLeft:indexPath:)])
                    [self.delegate cellDidMovedLeft:cell indexPath:draggedItemPath];
            }else
            {
                if ([self.delegate respondsToSelector:@selector(cellDidNotMoved:indexPath:)])
                    [self.delegate cellDidNotMoved:cell indexPath:draggedItemPath];
            }
        }
    }
}

- (void)finishedDragging:(UICollectionViewCell *)cell
{
    if (draggedItemPath)
    {
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.layer.borderWidth = 0.0f;
        
        CGFloat deltaX = (cell.center.x - initialItemCenter.x);
        CGFloat deltaY = (cell.center.y - initialItemCenter.y);
        BOOL shouldSnapBack =  YES;
        
        if((fabs(deltaX) > minimumXPanDistanceToSwipe))
        {
            
            shouldSnapBack = NO;
            
        }
        else if((fabs(deltaY) > minimumYPanDistanceToSwipe))
        {
            
            shouldSnapBack = NO;
            
        }
        
        if (shouldSnapBack)
        {
            [UIView setAnimationsEnabled:NO];
            [self.collectionView reloadItemsAtIndexPaths:@[draggedItemPath]];
            [UIView setAnimationsEnabled:YES];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(cellDidMovedUp:indexPath:)])
                [self.delegate cellDidMovedUp:cell indexPath:draggedItemPath];
            
            initialItemCenter = CGPointZero;
            draggedItemPath = nil;
        }
    }
}

@end
