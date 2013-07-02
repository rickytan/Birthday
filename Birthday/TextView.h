//
//  TextView.h
//  Birthday
//
//  Created by ricky on 13-7-1.
//
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(void);

@interface TextView : UIView
{
    UIView                  * _bgView;
    UITextView              * _textView;
    UIButton                * _button;
}
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, copy) ButtonBlock block;
@property (nonatomic, assign) IBOutlet TextView *nextView;
@end
