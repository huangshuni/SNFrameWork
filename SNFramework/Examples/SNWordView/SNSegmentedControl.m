//
//  SNSegmentedControl.m
//  SNFramework
//
//  Created by huangshuni on 16/9/23.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNSegmentedControl.h"
@interface SNSegmentedControl ()

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSMutableArray *itemViews;

@end

@implementation SNSegmentedControl

-(instancetype)initWithItems:(NSArray<UIImage *> *)items;
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        _items = [NSArray arrayWithArray:items];
        _itemViews = [NSMutableArray arrayWithCapacity:items.count];
        for (UIImage *image in items) {
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            [_itemViews addObject:imageView];
            [self addSubview:imageView];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat itemWidth = CGRectGetWidth(rect) / self.items.count;
    CGFloat itemHeight = CGRectGetHeight(rect) - 4.0f;
    
    for (int i = 0; i<_itemViews.count; i++) {
        UIImageView *imageView = _itemViews[i];
        imageView.frame = CGRectMake(itemWidth*i, 0, itemWidth, itemHeight);
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    CGFloat itemWidth = CGRectGetWidth(self.bounds) / self.itemViews.count;
    NSInteger index = point.x / itemWidth;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sn_segmentedControl:didTapAtIndex:)]) {
        [self.delegate sn_segmentedControl:self didTapAtIndex:index];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated{
    
    if (_selectedSegmentIndex == selectedSegmentIndex) {
        return;
    }
    _selectedSegmentIndex = selectedSegmentIndex;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
