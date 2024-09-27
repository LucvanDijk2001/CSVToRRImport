-======={Created by spocx}=======-
as of this moment Rewards and Inventory Items are not supported due to rec room referencing them by obfuscated strings
might work on this in the future but likely not.

program needs latest install of java 8.

supported types are int, float, bool, string and color.

To set up your conversion make sure "Settings.txt" is correct
Settings has a few settings.
file name is the file the program will scan for in the same folder
cell seperation character is the character used  in your data to seperate cells
float decimal character is the character used for floating point numbers (, or .)
Table format split character is the character you've used to define your data table format. this value can not be the same as the cell seperation character.

open example xlsx file to see how to format your sheet.

To convert, follow examplesheet format, save your file as "CSV UTF-8(comma delimited)" type.

The file name should be "DataSheet.csv". 

save csv file in same location as "ConvertTool.exe" and run the tool.

Converted output is saved to "data.txt"

program source can be found in source/ConvertTool. Program is made using processing3. feel free to adjust code as needed
The code is quite messy and was made very quickly, so good luck to you if you decide to adjust it.
-=================================-