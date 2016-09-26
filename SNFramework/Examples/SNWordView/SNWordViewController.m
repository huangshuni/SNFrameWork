//
//  SNWordViewController.m
//  SNFramework
//
//  Created by huangshuni on 16/9/22.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

#import "SNWordViewController.h"
#import "SNSegmentedControl.h"

@interface SNWordViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SNSegmentedControlDelegate>

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) SNSegmentedControl *contentInputAccessoryView;
@property (nonatomic,assign) CGFloat keyboardSpacingHeight;

@end

@implementation SNWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self.view addSubview:self.textView];
    [self.view addSubview:self.contentInputAccessoryView];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 调整视图的位置
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rect = self.view.bounds;
    rect.size.height = 40.0f;
    self.contentInputAccessoryView.frame = rect;
}

-(void)layoutTextView
{
    self.contentInputAccessoryView.frame = CGRectMake(0, SCREEN_HEIGHT - self.keyboardSpacingHeight - 40, SCREEN_WIDTH, 40);
    
//    CGRect rect = self.view.bounds;
//    rect.origin.y = [self.topLayoutGuide length];//使textView的y值在导航栏的下面0开始，不会被导航栏遮住，做适配
//    rect.size.height -= rect.origin.y;
//    self.textView.frame = rect;
//    UIEdgeInsets insets = self.textView.contentInset;
//    insets.bottom = self.keyboardSpacingHeight;
//    self.textView.contentInset = insets;
}

#pragma mark - 键盘
-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.keyboardSpacingHeight == keyboardSize.height) {
        return;
    }
    self.keyboardSpacingHeight = keyboardSize.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if (self.keyboardSpacingHeight == 0) {
        return;
    }
    self.keyboardSpacingHeight = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];
}

#pragma mark - 功能选项
-(void)changeTextInputView:(SNSegmentedControl *)control
{

    switch (control.selectedSegmentIndex) {
        case 0:
        {
        
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
           //选择图片
            [self selectPhoto];
              break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
            
        default:
            [self.textView resignFirstResponder];
            break;
    }
}

#pragma mark - 选择照片
-(void)selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 将图片加到textView里面
-(void)addImageToTextView:(UIImage *)image
{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    CGRect rect = CGRectZero;
    rect.size.width = 100;//image.size.width;
    rect.size.height = 100;//image.size.height;
    textAttachment.bounds = rect;
    textAttachment.image = image;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"\n"];
    [attributedString insertAttributedString:attachmentString atIndex:0];
    [attributedString insertAttributedString:self.textView.attributedText atIndex:0];
    
    self.textView.attributedText = attributedString;
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    _textView.inputAccessoryView = self.inputAccessoryView;
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    _textView.inputAccessoryView = nil;
    return YES;
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self addImageToTextView:image];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SNSegmentedControlDelegate
-(void)sn_segmentedControl:(SNSegmentedControl *)control didTapAtIndex:(NSInteger)index
{
    [control setSelectedSegmentIndex:index animated:YES];
}

#pragma mark - setter / getter
-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
        _textView.delegate = self;
    }
    return _textView;
}

-(SNSegmentedControl *)contentInputAccessoryView
{
    if (!_contentInputAccessoryView) {
        NSArray *items = @[
                           [UIImage imageNamed:@"ABC_icon"],
                           [UIImage imageNamed:@"style_icon"],
                           [UIImage imageNamed:@"img_icon"],
                           [UIImage imageNamed:@"@_icon"],
                           [UIImage imageNamed:@"comment_icon"],
                           [UIImage imageNamed:@"clear_icon"]
                           ];
        _contentInputAccessoryView = [[SNSegmentedControl alloc]initWithItems:items];
        _contentInputAccessoryView.delegate = self;
        [_contentInputAccessoryView addTarget:self action:@selector(changeTextInputView:) forControlEvents:UIControlEventValueChanged];
    }
    return _contentInputAccessoryView;
}

@end
