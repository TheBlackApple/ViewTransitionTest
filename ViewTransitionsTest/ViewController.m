//
//  ViewController.m
//  ViewTransitionsTest
//
//  Created by Charles Leo on 15/1/6.
//  Copyright (c) 2015年 Charles Leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (retain,nonatomic) UIImageView * frontView;
@property (retain,nonatomic) UIImageView * backView;


@property (nonatomic, retain)  UIBarButtonItem *fadeButton;
@property (nonatomic, retain)  UIBarButtonItem *flipButton;
@property (nonatomic, retain)  UIBarButtonItem *bounceButton;

@property (nonatomic, strong) NSArray *priorConstraints;
@end

@implementation ViewController

- (NSArray *)constrainSubview:(UIView *)subview toMatchWithSuperview:(UIView *)superview
{
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(subview);
    
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|[subview]|"
                            options:0
                            metrics:nil
                            views:viewsDictionary];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:|[subview]|"
                    options:0
                    metrics:nil
                    views:viewsDictionary]];
    [superview addConstraints:constraints];
    
    return constraints;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    self.backView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backView.image = [UIImage imageNamed:@"image2.jpg"];
    [self.view addSubview:self.backView];

    self.frontView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.frontView.image = [UIImage imageNamed:@"image1.jpg"];
    [self.view addSubview:self.frontView];
    self.priorConstraints = [self constrainSubview:self.frontView toMatchWithSuperview:self.view];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"fade" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 200;
    btn1.frame = CGRectMake(0, 0, 80, 44);
    self.fadeButton = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"flip" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 201;
    btn2.frame = CGRectMake(0, 0, 80, 44);
    self.flipButton = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    
    
    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setTitle:@"bounce" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 202;
    btn3.frame = CGRectMake(0, 0, 80, 44);
    self.bounceButton = [[UIBarButtonItem alloc]initWithCustomView:btn3];
    
    
    
    
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSMutableArray *toolbarButtons = [NSMutableArray arrayWithObjects:flexItem, self.fadeButton, self.flipButton, nil];
    if ([[UIView class] respondsToSelector:
         @selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)])
    {
        [toolbarButtons addObject:self.bounceButton];
    }
    [toolbarButtons addObject:flexItem];
    
    self.toolbarItems = toolbarButtons;
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:
            [self performTransiton:UIViewAnimationOptionTransitionCrossDissolve];
            break;
        case 201:
        {
            UIViewAnimationOptions transitionOptions = ([self.frontView superview]!=nil)?UIViewAnimationOptionTransitionFlipFromRight:UIViewAnimationOptionTransitionFlipFromLeft;
            [self performTransiton:transitionOptions];
        }
            break;
        case 202:
        {
            if ([[UIView class] respondsToSelector:
                 @selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)])
            {
                self.navigationController.toolbar.userInteractionEnabled = NO;
                UIView* fromView,*toView;
                if ([self.frontView superview] != nil)
                {
                    fromView = self.frontView;
                    toView = self.backView;
                }
                else
                {
                    fromView = self.backView;
                    toView = self.frontView;
                }
                CGRect startFrame = self.view.frame;
                CGRect endFrame = self.view.frame;
                startFrame.origin.y = -startFrame.size.height;
                endFrame.origin.y = 0;
                toView.frame = startFrame;
                [self.view addSubview:toView];
                NSArray *priorConstraints = self.priorConstraints;
               [UIView animateWithDuration:1.0f delay:0.0 usingSpringWithDamping:0.5f initialSpringVelocity:5.0 options:0 animations:^{
                   toView.frame = endFrame;
               } completion:^(BOOL finished) {
                   if (priorConstraints != nil)
                       [self.view removeConstraints:priorConstraints];
                   [fromView removeFromSuperview];
                   self.navigationController.toolbar.userInteractionEnabled = YES;
               }];
                _priorConstraints = [self constrainSubview:toView toMatchWithSuperview:self.view];
            }
        }
            break;
        default:
            break;
    }
}

- (void)performTransiton:(UIViewAnimationOptions)options
{
    UIView * fromView,*toView;
    if ([self.frontView superview] !=nil) {
        fromView = self.frontView;
        toView = self.backView;
    }
    else
    {
        fromView = self.backView;
        toView = self.frontView;
    }
    NSArray *priorConstraints = self.priorConstraints;
    [UIView transitionFromView:fromView toView:toView duration:1.0 options:options completion:^(BOOL finished) {
        if (priorConstraints != nil)
        {
            [self.view removeConstraints:priorConstraints];
        }
    }];
     _priorConstraints = [self constrainSubview:toView toMatchWithSuperview:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
