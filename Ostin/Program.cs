using System;
using System.Collections.Generic;

namespace Print
{
   internal class Program
    {
        private static void Main(string[] args)
        {

            string str ="LR1C73 55 XS Платье джинсовое,Straight denim dress, with decorative stitching on collar, shoulder strap";
            string wareDescription = FieldBlock(str, 50, 92, 19, @"^A@N,17,0,ARI003.FNT");
            
       //     Console.Write(wareDescription);
       //     Console.ReadLine();

            string str1 = "Состав Верх нр100% хлок Сделано в Бангладеш Изготовлено р07.2014. ГОСТ 31408-2009. Импртер ООО Спортмастер юр.адрес р117437, г. Москва, ул. Миклухо-Маклая, д. 18, корпус 2, ком. 102. Изготовитель Соннет Текстайл Индастрис Лтд МОХИД ТАУЭР ХОЛДИНГ #807/859 БАРИК МИА ХАЙ-СКУЛ ЛЕЙН ГОШАИЛДАНГА, БАНДЕР, ЧИТТАГОНГ БАНГЛАДЕШ";
            string wareAdditionalInfo = FieldBlock(str1, 80, 214, 16, @"^A@N,14,0,ARI001.FNT");
            
            Console.Write(wareAdditionalInfo);
            Console.ReadLine();
            
            
            Console.WriteLine();
            
            string line = DrawDLine("4545", "", 25, 35, 10);
            Console.WriteLine(line);
            Console.ReadLine();
            
        }


        public static string FieldBlock(string str, int width, int y, int dy, string font)
        {
            string result = @"^FT3," + y + @"^CI17^F8^FD";
            List<string> line = Wrap(str, width);
            for (int index = 0; index < line.Count; index++)
            {
                result += line[index] + @"^FS";
                if (index < line.Count - 1)
                {
                    result += font+ @"^FT3," + (int)(y + dy * (index + 1)) + font + "^FD";
                }
            }
            return result;
        }

        public static List<String> Wrap(string text, int maxLength)
        {
            if (text.Length == 0) return new List<string>();
            var words = text.Split(' ');
            var lines = new List<string>();
            var currentLine = "";
            foreach (var currentWord in words)
            {
                if ((currentLine.Length > maxLength) ||
                    ((currentLine.Length + currentWord.Length) > maxLength))
                {
                    lines.Add(currentLine);
                    currentLine = "";
                }
                if (currentLine.Length > 0)
                {
                    currentLine += " " + currentWord;
                }
                else
                {
                    currentLine += currentWord;
                }
            }
            if (currentLine.Length > 0)
            {
                lines.Add(currentLine);
            }
            return lines;
        }
        
        
        
       public static String DrawDLine(string catalogPrice, string retailPrice, int fontWidth, int fontHeight, int thickness)
       {
       	
       	if (retailPrice.Length == 0)
       	{
       		return "";
       	}
       	
       	int width = fontWidth * catalogPrice.Length;
       	
       	String str = @"^GD" + width + "," + fontHeight + "," + thickness + @"^FS";
       	  
       	        	 	
       	 return str;
       }
       
        
    }
}