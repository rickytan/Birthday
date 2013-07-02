//
//  ViewController.m
//  Birthday
//
//  Created by ricky on 13-7-1.
//
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LTransitionImageView.h"
#import "TextView.h"

@interface ViewController ()
{
    AVAudioPlayer                   * _player;
    LTransitionImageView            * _transitionView;
    CALayer                         * _fireLayer;
}
@property (nonatomic, assign) IBOutlet UIView *contentView;
@property (nonatomic, assign) IBOutlet TextView *lastView;
@property (strong) CAEmitterLayer *fireEmitter;
@end

@implementation ViewController
@synthesize fireEmitter = _fireEmitter;

- (void)dealloc
{
    [_player release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    _transitionView = [[LTransitionImageView alloc] initWithFrame:self.view.bounds];
    _transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _transitionView.image = [UIImage imageNamed:@"start.jpg"];
    [self.view insertSubview:_transitionView
                belowSubview:self.contentView];
    [_transitionView release];
    
    _fireLayer = [CALayer layer];
    [self.view.layer addSublayer:_fireLayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"HB"
                                                                                   withExtension:@"mp3"]
                                                     error:NULL];
    _player.numberOfLoops = -1;
    _player.volume = 1.0;
    [_player prepareToPlay];
    [_player play];
    
    //[self lightUpFire];
    self.lastView.block = ^() {
        _transitionView.image = [UIImage imageNamed:@"image5.jpg"];
        [self lightUpFire];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - Methods

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _transitionView.animationDirection = random() % 4;
    _transitionView.image = backgroundImage;
}

- (void)lightUpFire
{
	// Create the fire emitter cell
    
	CAEmitterCell* fire = [CAEmitterCell emitterCell];
	[fire setName:@"fire"];
    
	fire.birthRate			= 100;
	fire.emissionLongitude  = M_PI;
	fire.velocity			= -80;
	fire.velocityRange		= 30;
	fire.emissionRange		= 1.1;
	fire.yAcceleration		= -200;
	fire.scaleSpeed			= 0.3;
	fire.lifetime			= 50;
	fire.lifetimeRange		= (50.0 * 0.15);
    
	fire.color = [[UIColor colorWithRed:0.8 green:0.5 blue:0.2 alpha:0.1] CGColor];
	fire.contents = (id) [[UIImage imageNamed:@"DazFire.png"] CGImage];
	
	
	// Create the smoke emitter cell
	CAEmitterCell* smoke = [CAEmitterCell emitterCell];
	[smoke setName:@"smoke"];
    
	smoke.birthRate			= 1;
	smoke.emissionLongitude = -M_PI / 2;
	smoke.lifetime			= 10;
	smoke.velocity			= -40;
	smoke.velocityRange		= 20;
	smoke.emissionRange		= M_PI / 4;
	smoke.spin				= 1;
	smoke.spinRange			= 6;
	smoke.yAcceleration		= -160;
	smoke.contents			= (id) [[UIImage imageNamed:@"DazSmoke.png"] CGImage];
	smoke.scale				= 0.1;
	smoke.alphaSpeed		= -0.12;
	smoke.scaleSpeed		= 0.7;
	
    
    CGPoint loc[] = {{56, 388},{163,387},{235,177},{393,198},{516,166},{611,172},{722,354},{769,221},{850,400},{993,412},{549,396},{255,386},{414,391}};
    for (int i=0; i < 13; ++i) {
        
        self.fireEmitter	= [CAEmitterLayer layer];
        
        // Place layers just above the tab bar
        self.fireEmitter.emitterPosition = loc[i];
        self.fireEmitter.emitterSize	= CGSizeMake(40, 0);
        self.fireEmitter.emitterMode	= kCAEmitterLayerOutline;
        self.fireEmitter.emitterShape	= kCAEmitterLayerLine;
        // with additive rendering the dense cell distribution will create "hot" areas
        self.fireEmitter.renderMode		= kCAEmitterLayerAdditive;
        
        self.fireEmitter.emitterCells	= [NSArray arrayWithObjects:fire, smoke, nil];
        
        [_fireLayer addSublayer:self.fireEmitter];
    }
	
	[self setFireAmount:0.9];
}

- (void) setFireAmount:(float)zeroToOne
{
    for (CAEmitterLayer *layer in _fireLayer.sublayers) {
        [layer setValue:[NSNumber numberWithInt:(zeroToOne * 500)]
                        forKeyPath:@"emitterCells.fire.birthRate"];
        [layer setValue:[NSNumber numberWithFloat:zeroToOne]
                        forKeyPath:@"emitterCells.fire.lifetime"];
        [layer setValue:[NSNumber numberWithFloat:(zeroToOne * 0.35)]
                        forKeyPath:@"emitterCells.fire.lifetimeRange"];
        layer.emitterSize = CGSizeMake(50 * zeroToOne, 0);
    }
}

@end
