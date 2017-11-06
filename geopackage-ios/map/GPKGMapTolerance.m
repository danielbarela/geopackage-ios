//
//  GPKGMapTolerance.m
//  AFNetworking
//
//  Created by Brian Osborn on 11/6/17.
//

#import "GPKGMapTolerance.h"

@implementation GPKGMapTolerance

-(instancetype) init{
    return [self initWithDistance:0 andScreen:0];
}

-(instancetype) initWithDistance: (double) distance andScreen: (double) screen{
    self = [super init];
    if(self != nil){
        self.distance = distance;
        self.screen = screen;
    }
    return self;
}

@end
