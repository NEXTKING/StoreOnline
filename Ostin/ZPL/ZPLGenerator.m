//
//  ZPLGenerator.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ZPLGenerator.h"
#import "BarcodeFormatter.h"

@implementation ZPLGenerator

+ (NSData*) generateZPLWithItem:(ItemInformation*) item patternPath:(NSString *)path
{
    
    NSStringEncoding outEncoding;
    NSError* error;
    NSString *fileContents = [NSString stringWithContentsOfFile:path
                                               usedEncoding:&outEncoding
                                                          error:&error];
    
   // if (error)
   //     return nil;
    
    NSDate* date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    
    NSString* size      =    [self paramFromItem:item name:@"size"];
    NSString* addSize   =    [self paramFromItem:item name:@"additionalSize"];
    NSString* addInfo   =    [self paramFromItem:item name:@"additionalInfo"];
    NSString* userID    =    @"300";
    NSString* shopID    =    @"123";
    NSString* drop      =    @"";
    NSString* boxType   =    [self paramFromItem:item name:@"boxType"];
    NSString* discountNum  =    [self paramFromItem:item name:@"discount"];
    NSString* discount = (discountNum.integerValue > 0) ? [NSString stringWithFormat:@"Скидка %@%%", discountNum]:@"";
    NSString* retailPrice   = [self paramFromItem:item name:@"retailPrice"];
    NSString* barcode       = [BarcodeFormatter generateCode128WithShopID:@"01234" code:item.barcode price:MIN(item.price, [retailPrice doubleValue])];
    
    NSString* catalogPrice = @"";
    if (discountNum.integerValue > 0)
        catalogPrice = [NSString stringWithFormat:@"%.0f",item.price];
    else
    {
        catalogPrice = [NSString stringWithFormat:@"%.0f,-",item.price];
        retailPrice  = @"";
    }
    
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.PriceHeader$" withString:[NSString stringWithFormat:@"Цены указаны в рублях:"]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.CatalogPrice$" withString:catalogPrice];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.SizeHeader$" withString:[NSString stringWithFormat:@"Размер:"]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.RetailPrice$" withString:retailPrice?retailPrice:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$PrintDate$" withString:[NSString stringWithFormat:@"%@", dateString]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.SizeValue$" withString:size?size:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.CertificationCode$" withString:[NSString stringWithFormat:@""]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.ProdCode$" withString:item.article?item.article:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.AdditionalSize$" withString:addSize?addSize:@""];
    //NSInteger checkSum = [self calculateUPCCheckSum:[NSString stringWithFormat:@"9900%@", item.barcode]];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Barcode$" withString:barcode];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$PrintUser$" withString:userID?userID:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.Drop$" withString:drop?drop:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$ShopNum$" withString:shopID?shopID:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.BoxType$" withString:boxType?boxType:@""];
    fileContents = [fileContents stringByReplacingOccurrencesOfString:@"$Ware.DiscountHeader$" withString:discount];
    
    // Filling an additional info
    
    {
        NSRange startRange = [fileContents rangeOfString:@"========С#=========="];
        NSRange endRange   = [fileContents rangeOfString:@"===================="];
        NSRange contentsRange = NSMakeRange(startRange.location, (endRange.location+endRange.length) - startRange.location);
        NSString* contentsString = [fileContents substringWithRange:contentsRange];
        NSString* additionalZPL = [self additionalInfo:addInfo widht:75 y:214 dy:16 font:@"^A@N,12,0,ARI001.TTF"];
    
        fileContents = [fileContents stringByReplacingOccurrencesOfString:contentsString withString:additionalZPL];
    }
    
    // Filling item description
    
    {
        NSRange startRange = [fileContents rangeOfString:@"========С#=========="];
        NSRange endRange   = [fileContents rangeOfString:@"===================="];
        NSRange contentsRange = NSMakeRange(startRange.location, (endRange.location+endRange.length) - startRange.location);
        NSString* contentsString = [fileContents substringWithRange:contentsRange];
        NSString* additionalZPL = [self additionalInfo:item.name widht:50 y:92 dy:19 font:@"^A@N,17,0,ARI005.TTF"];
        
        fileContents = [fileContents stringByReplacingOccurrencesOfString:contentsString withString:additionalZPL];
    }
    
    if (discountNum.integerValue > 0)
    {
        NSRange startRange = [fileContents rangeOfString:@"========С#=========="];
        NSRange endRange   = [fileContents rangeOfString:@"===================="];
        NSRange contentsRange = NSMakeRange(startRange.location, (endRange.location+endRange.length) - startRange.location);
        NSString* contentsString = [fileContents substringWithRange:contentsRange];
        NSString* additionalZPL = [self drawDLine:catalogPrice retailPrice:retailPrice fontWidth:25 fontHeight:35 thickness:10];
        
        fileContents = [fileContents stringByReplacingOccurrencesOfString:contentsString withString:additionalZPL];
    }
    
    
    return [fileContents dataUsingEncoding:outEncoding];
};

+ (NSString*) paramFromItem:(ItemInformation*) item name:(NSString*)name
{
    ParameterInformation* param = nil;
    for (ParameterInformation *currentParam in item.additionalParameters) {
        if ([currentParam.name isEqualToString:name])
        {
            param = currentParam;
            break;
        }
    }
    
    return param.value;
}

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

+ (NSString*) additionalInfo:(NSString*) info widht:(int) width y:(int)y dy:(int) dy font:(NSString*) font
{
    
    NSString* zpl = [self fieldBlockWithString:info width:width y:y dy:dy font:font];
    //NSString* zpl = [self fieldBlockWithString:text width:80 y:214 dy:16 font:@"^A@N,14,0,ARI001.FNT"];
    NSLog(@"%@", zpl);
    return zpl;
    
    /*^FT3,214^CI17^F8^FDСостав: 100% хлопок Сделано в Бангладеш Изготовлено: 01.2016. Импортер: ООО^FS^A@N,12,0,ARI001.TTF
    ^FT3,230^A@N,12,0,ARI001.TTF^FD''Остин'' 117420, Россия, г. Москва, ул. Профсоюзная, д.61 А, тел. 974 78 72.^FS
    ^A@N,12,0,ARI001.TTF^FT3,246^A@N,12,0,ARI001.TTF^FDИзготовитель: Пи Эн Композит Лтд Амбаг, Конабари, Газипур, Бангладеш. ^FS*/
}

+ (NSString*) itemDescription:(NSString*) info widht:(int) width y:(int)y dy:(int) dy font:(NSString*) font
{
    NSString* zpl = [self fieldBlockWithString:info width:width y:y dy:dy font:font];
    //NSString* zpl = [self fieldBlockWithString:text width:80 y:214 dy:16 font:@"^A@N,14,0,ARI001.FNT"];
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
    NSMutableString* result = [[NSMutableString alloc] initWithFormat:@"^FT3,%d^CI17^F8^FD^FS",y];
    [result appendFormat:@"%@^FT3,%d%@^FD", font,(int)(y),font];
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


+ (NSString*) drawDLine:(NSString*) catalogPrice retailPrice:(NSString*) retailPrice fontWidth:(int) fontWidth fontHeight:(int) fontHeight thickness:(int) thickness
{
    if (retailPrice.length == 0)
        return @"";
    
    int width = fontWidth*(int)catalogPrice.length;
    
    return [NSString stringWithFormat:@"^GD%d,%d,%d^FS", width, fontHeight, thickness];
    
}

@end
