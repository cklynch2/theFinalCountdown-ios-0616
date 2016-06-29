//
//  FISViewController.m
//  theFinalCountdown
//
//  Created by Joe Burgess on 7/9/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (nonatomic) NSUInteger secondsToZero;
@property (strong, nonatomic) NSTimer *countdownTimer;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeLabel.hidden = YES;
    self.pauseButton.enabled = NO;

    [self.view removeConstraints:self.view.constraints];
    self.buttonsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buttonsView removeConstraints:self.buttonsView.constraints];
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startButton removeConstraints:self.startButton.constraints];
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pauseButton removeConstraints:self.pauseButton.constraints];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.datePicker removeConstraints:self.datePicker.constraints];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.timeLabel removeConstraints:self.timeLabel.constraints];
    self.timeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.timeView removeConstraints:self.timeView.constraints];
    
    self.buttonsView.backgroundColor = [UIColor lightGrayColor];
    [self.buttonsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.buttonsView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.buttonsView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.buttonsView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5].active = YES;
    
    self.startButton.backgroundColor = [UIColor whiteColor];
    [self.startButton.leftAnchor constraintEqualToAnchor:self.buttonsView.leftAnchor constant:65.0].active = YES;
    [self.startButton.centerYAnchor constraintEqualToAnchor:self.buttonsView.centerYAnchor].active = YES;
    
    self.pauseButton.backgroundColor = [UIColor whiteColor];
    [self.pauseButton.rightAnchor constraintEqualToAnchor:self.buttonsView.rightAnchor constant:-65.0].active = YES;
    [self.pauseButton.centerYAnchor constraintEqualToAnchor:self.buttonsView.centerYAnchor].active = YES;

    // Realize now that I did not need to create timeView, because datePicker takes up the upper half of the screen and so everything else that is constrained relative to the top half, such as timeLabel, can be constrained to datePicker.
    [self.timeView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.timeView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.timeView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.timeView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.5].active = YES;
    
    [self.datePicker.topAnchor constraintEqualToAnchor:self.timeView.topAnchor].active = YES;
    [self.datePicker.leftAnchor constraintEqualToAnchor:self.timeView.leftAnchor].active = YES;
    [self.datePicker.widthAnchor constraintEqualToAnchor:self.timeView.widthAnchor].active = YES;
    [self.datePicker.heightAnchor constraintEqualToAnchor:self.timeView.heightAnchor].active = YES;
    
    [self.timeLabel.centerYAnchor constraintEqualToAnchor:self.timeView.centerYAnchor].active = YES;
    [self.timeLabel.centerXAnchor constraintEqualToAnchor:self.timeView.centerXAnchor].active = YES;
    [self.timeLabel.widthAnchor constraintEqualToAnchor:self.timeView.widthAnchor multiplier:.85].active = YES;
    [self.timeLabel.heightAnchor constraintEqualToAnchor:self.timeView.heightAnchor multiplier:.75].active = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)updateTimeLabel {
    NSInteger hours = self.secondsToZero/3600;
    NSInteger minutes = (self.secondsToZero % 3600)/60;
    NSInteger seconds = self.secondsToZero - (hours * 3600) - (minutes * 60);
    
    //Update the label with the remaining time. The %02i format specifier indicates that single digit should be preceded by zero. Seconds should be displayed in landscape orientation, only hours and minutes in portrait.
    if (self.traitCollection.verticalSizeClass == 2) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i", hours, minutes];
    } else if (self.traitCollection.verticalSizeClass == 1) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
    }
}

-(void)updateTime
{
    // Exit the method if the timer has run to zero.
    if(self.secondsToZero == 0)
        return;
    
    // Decrement the remaining time until the counter has run to zero by one second. The start button action method calls this updateTime method every second, in correspondence with decrementing secondsToZero.
    self.secondsToZero --;
    [self updateTimeLabel];
}


- (IBAction)startButtonTapped:(id)sender {
    self.datePicker.hidden = YES;
    self.timeLabel.hidden = NO;
    self.pauseButton.enabled = YES;
    [self.startButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    // Set the countdown property secondsToZero equal to the initial duration selected through datePicker.
    NSInteger selectedCountdownTime = self.datePicker.countDownDuration;
    self.secondsToZero = selectedCountdownTime;
    [self updateTimeLabel];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(updateTime)
                                   userInfo:nil
                                    repeats:YES];
}

- (IBAction)pauseButtonTapped:(id)sender {
    [self.countdownTimer invalidate];
}

@end
