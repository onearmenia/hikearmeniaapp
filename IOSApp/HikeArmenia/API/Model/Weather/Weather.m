//
//  Weather.m
//  HikeArmenia
//
//  Created by Lusine Hovhannisyan on 6/16/16.
//  Copyright © 2016 BigBek LLC. All rights reserved.
//

#import "Weather.h"
#import "StringUtils.h"
#import "NSMutableDictionary+Additions.h"

@implementation Weather

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
    Weather *newWeather = [[[self class] alloc] init];
    if(newWeather) {
        [newWeather setTemperature:[self temperature]];
        [newWeather setWeatherIcon:[self weatherIcon]];
    }
    return newWeather;
}

+ (id)objectFromJSON:(id)json {
    Weather *weather = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        weather = [[Weather alloc] init];
        
        weather.temperature = [json objectForKey:@"weather_temperature"];
        weather.weatherIcon = [json objectForKey:@"weather_icon"];
    }
    return weather;
}

- (NSDictionary *)objectToDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict safeSetObject:[StringUtils safeStringWithString:self.temperature] forKey:@"weather_temperature"];
    [dict safeSetObject:[StringUtils safeStringWithString:self.weatherIcon] forKey:@"weather_icon"];
    
    return [dict copy];
}

@end
