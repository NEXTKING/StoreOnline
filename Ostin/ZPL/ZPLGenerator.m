//
//  ZPLGenerator.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ZPLGenerator.h"

@implementation ZPLGenerator

+ (NSData*) generateZPLWithItem:(ItemInformation*) item patternPath:(NSString *)path
{
    
    NSStringEncoding outEncoding;
    NSError* error;
    NSString *fileContents = [NSString stringWithContentsOfFile:path
                                               usedEncoding:&outEncoding
                                                          error:&error];
    
    if (error)
        return nil;
    
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.PriceHeader$" withString:[NSString stringWithFormat:@"Цены указаны в рублях:"]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.CatalogPrice$" withString:[NSString stringWithFormat:@"%.0f,-",item.price]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.SizeHeader$" withString:[NSString stringWithFormat:@"Размер:"]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.RetailPrice$" withString:[NSString stringWithFormat:@""]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$PrintDate$" withString:[NSString stringWithFormat:@"%@", dateString]];
    
    NSInteger checkSum = [self calculateUPCCheckSum:[NSString stringWithFormat:@"9900%@", item.barcode]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Barcode$" withString:[NSString stringWithFormat:@"%@%ld", item.barcode,(long)checkSum]];
    
    
    
    
    return [fileContents dataUsingEncoding:outEncoding];
};

+ (NSInteger) calculateUPCCheckSum:(NSString*) code
{
    
    NSUInteger len = [code length];
    unichar buffer[len+1];
    
    [code getCharacters:buffer range:NSMakeRange(0, len)];
    
    int oddSum = 0;
    int evenSum = 0;
    
    for(int i = 0; i < len; i+=2) {
        int digit = buffer[i] - '0';
        
        if (i%2)
            evenSum += digit*3;
        else
            oddSum += digit;
    }
    
    int sum = oddSum + evenSum;
    int checkSum = 0;
    while (sum % 10 != 0) {
        sum++;
        checkSum++;
    }
    
    return checkSum;
}

+ (NSString*) additionalInfo
{
    NSString* text = @"Состав Верх нр100% хлок Сделано в Бангладеш Изготовлено р07.2014. ГОСТ 31408-2009. Импртер ООО Спортмастер юр.адрес р117437, г. Москва, ул. Миклухо-Маклая, д. 18, корпус 2, ком. 102. Изготовитель Соннет Текстайл Индастрис Лтд МОХИД ТАУЭР ХОЛДИНГ #807/859 БАРИК МИА ХАЙ-СКУЛ ЛЕЙН ГОШАИЛДАНГА, БАНДЕР, ЧИТТАГОНГ БАНГЛАДЕШ";
    
    NSString* zpl = [self fieldBlockWithString:text width:80 y:214 dy:16 font:@"^A@N,14,0,ARI001.FNT"];
    NSLog(@"%@", zpl);
    return zpl;
}

+ (NSString*) description
{
    NSString* text = @"LR1C73 55 XS Платье джинсовое,Straight denim dress, with decorative stitching on collar, shoulder strap";
    NSString* zpl = [self fieldBlockWithString:text width:50 y:92 dy:19 font:@"^A@N,17,0,ARIMAC.TTF"];
    NSLog(@"%@", zpl);
    return zpl;
}

+ (NSString*) fieldBlockWithString: (NSString*) str width: (int) width y:(int) y dy: (int) dy font:(NSString*) font
{
    // NSMutableString* result = [[NSMutableString alloc] initWithFormat:@"^FT3,%d^CI17^F8^FD",y];
    NSMutableString* result = [[NSMutableString alloc] initWithFormat:@"^FT3,%d^CI17^F8^FD",y];
    NSArray *line = [ZPLGenerator wrapString:str maxLength:width];
    for (int index = 0; index < line.count; index++)
    {
        [result appendFormat:@"%@^FS", line[index]];
        if (index < line.count - 1)
        {
            [result appendFormat:@"%@^FT3,%d%@^FD", font,(int)(y + dy * (index + 1)),font];
        }
    }
    return result;
}

+ (NSArray<NSString*>*) wrapString: (NSString*)text maxLength:(int) maxLength
{
    if (text.length == 0) return [NSArray new];
    NSArray* words = [text componentsSeparatedByString:@" "];
    NSMutableArray<NSString*>*lines = [NSMutableArray new];
    NSMutableString* currentLine = [[NSMutableString alloc] initWithString:@""];
    for (NSString* currentWord in words)
    {
        if ((currentLine.length > maxLength) ||
            ((currentLine.length + currentWord.length) > maxLength))
        {
            [lines addObject:currentLine];
            currentLine = [[NSMutableString alloc] initWithString:@""];;
        }
        if (currentLine.length > 0)
        {
            [currentLine appendFormat:@" %@", currentWord];
        }
        else
        {
            [currentLine appendString:currentWord];
        }
    }
    if (currentLine.length > 0)
    {
        [lines addObject:currentLine];
    }
    return lines;
}

@end
