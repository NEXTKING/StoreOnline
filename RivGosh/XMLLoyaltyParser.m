//
//  XMLLoyaltyParser.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "XMLLoyaltyParser.h"
#import "DiscountInformation.h"
#import "Logger.h"

@interface XMLLoyaltyParser() <NSXMLParserDelegate>
{
    NSMutableArray *discountsArray;
    DiscountInformation* currentDiscount;
    NSMutableString* elementsString;
}
@property (nonatomic, strong) NSArray* loyaltyArray;
@end

@implementation XMLLoyaltyParser


- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    [Logger log:self method:@"parserDidStartDocument:" format:@"Did start Document"];
    elementsString = [NSMutableString new];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    [Logger log:self method:@"parserDidStartElement:" format:@"%@", elementName];
    [elementsString setString:@""];
    
    if ([elementName isEqualToString:@"ArrayOfItemsLOYALTY"])
        discountsArray = [NSMutableArray new];
    else if ([elementName isEqualToString:@"Items"])
        currentDiscount = [DiscountInformation new];
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Save foundCharacters for later
    [Logger log:self method:@"parserFoundCharacters:" format:@"%@", string];
    
    [elementsString appendString:string];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
 
    [Logger log:self method:@"parserDidStartElement:" format:@"%@", elementName];
    
    if ([elementName isEqualToString:@"Items"])
        [discountsArray addObject:currentDiscount];
    else if ([elementName isEqualToString:@"LOYALTYPROGRAMM"])
        currentDiscount.name = elementsString;
    else if ([elementName isEqualToString:@"BONUSAVAIL"])
        currentDiscount.count = [elementsString integerValue];
    else if ([elementName isEqualToString:@"SUMAVAIL"])
        currentDiscount.maxDiscount = [elementsString doubleValue];
    else if ([elementName isEqualToString:@"DISCSUMM"])
        currentDiscount.discountAmountRub = [elementsString doubleValue];
    else if ([elementName isEqualToString:@"BONUSBALANCE"])
        currentDiscount.bonusBalance = [elementsString integerValue];
    else if ([elementName isEqualToString:@"SUMBALANCE"])
        currentDiscount.sumBalance = [elementsString doubleValue];
    else if ([elementName isEqualToString:@"EDITABLEVALUE"])
    {
        if ([elementsString isEqualToString:@"true"])
            currentDiscount.editable = YES;
        else
            currentDiscount.editable = NO;
    }
    else if ([elementName isEqualToString:@"DISABLED"])
    {
        if ([elementsString isEqualToString:@"true"])
            currentDiscount.enabled = NO;
        else
            currentDiscount.enabled = YES;
    }
    
        
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.loyaltyArray = discountsArray;
    [Logger log:self method:@"parserEndDocument:" format:@"Did end Document"];
}

-(BOOL)parse{
    self.delegate = self;
    return [super parse];
}

@end
