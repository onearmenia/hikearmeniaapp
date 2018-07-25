//
//  WeatherMO.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 8/12/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "WeatherMO.h"
#import <UIKit/UIKit.h>

@implementation WeatherMO

@dynamic temperature;
@dynamic weatherIcon;

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.temperature forKey:@"weather_temperature"];
    [encoder encodeObject:self.weatherIcon forKey:@"weather_icon"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
        self.temperature = [decoder decodeObjectForKey:@"weather_temperature"];
        self.weatherIcon = [decoder decodeObjectForKey:@"weather_icon"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    WeatherMO *newWeather = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherMO" inManagedObjectContext:[[self class] managedObjectContext]];
    if(newWeather) {
        [newWeather setTemperature:[self temperature]];
        [newWeather setWeatherIcon:[self weatherIcon]];
    }
    return newWeather;
}

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
