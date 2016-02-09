//
//  ViewController.h
//  image playground
//
//  Created by Michael Nolan on 11/4/15.
//  Copyright © 2015 Michael Nolan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface ViewController : NSViewController
@property NSImage* image;

@end
#include "vector.h"
//				AABBGGRR
#define GREEN 0xff00FF00
#define RED 0xFF0000FF
#define BLUE 0xFFFF0000
#define MAGENTA 0xFFFF00FF