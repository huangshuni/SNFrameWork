//
//  SNSegmentedControl.h
//  SNFramework
//
//  Created by huangshuni on 16/9/23.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNSegmentedControl;

@protocol SNSegmentedControlDelegate <NSObject>

-(void)sn_segmentedControl:(SNSegmentedControl *)control didTapAtIndex:(NSInteger)index;

@end

@interface SNSegmentedControl : UIControl

@property (nonatomic,weak) id<SNSegmentedControlDelegate>delegate;
@property (nonatomic,assign) NSInteger selectedSegmentIndex ;

-(instancetype)initWithItems:(NSArray<UIImage *> *)items;

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated;

@end
