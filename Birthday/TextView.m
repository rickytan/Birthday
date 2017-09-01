//
//  TextView.m
//  Birthday
//
//  Created by ricky on 13-7-1.
//
//

#import "TextView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@implementation TextView
@synthesize imageName = _imageName;

- (void)dealloc
{
    self.block = nil;
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 220, 768)];
}

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1.0;
    
    _bgView = [[UIView alloc] initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.7;
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_bgView];
    [_bgView release];
    
    _textView = [[UITextView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(20, 20, 20, 20))];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:24];
    _textView.editable = NO;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_textView];
    [_textView release];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.showsTouchWhenHighlighted = YES;
    _button.hidden = YES;
    _button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [_button setBackgroundImage:[UIImage imageNamed:@"arrow.png"]
                       forState:UIControlStateNormal];
    [_button addTarget:self
                action:@selector(onButton:)
      forControlEvents:UIControlEventTouchUpInside];
    [_button sizeToFit];
    CGRect rect = _button.frame;
    rect.origin.y = self.bounds.size.height - rect.size.height - 12;
    rect.origin.x = self.bounds.size.width - rect.size.width - 20;
    _button.frame = rect;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _button.transform = CGAffineTransformMakeTranslation(8, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self addSubview:_button];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)onButton:(id)sender
{
    self.nextView.hidden = NO;
    self.nextView.alpha = 0.0;
    ((ViewController*)[UIApplication sharedApplication].keyWindow.rootViewController).backgroundImage = [UIImage imageNamed:self.nextView.imageName];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                         self.nextView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
    if (self.block)
        self.block();
}

- (void)setText:(NSString *)text
{
    [_textView setValue:[NSString stringWithFormat:@"<meta charset=utf-8><style type='text/css'>html,body{color:#fff;font-size:24px;}h1,h2,h3,h4,p{margin:4px;color:#fff;}</style>%@<br />&emsp;",text]
                 forKey:@"ContentToHTMLString"];
    [_textView setNeedsLayout];
}

- (void)setNextView:(TextView *)nextView
{
    if (_nextView != nextView) {
        [_nextView release];
        _nextView = [nextView retain];
        _button.hidden = (_nextView == nil);
    }
}

@end
