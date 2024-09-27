void setup()
{
  String[] settings = loadStrings("Settings.txt");
  String filename = split(settings[0],'|')[1];
  String sepChar = split(settings[1],'|')[1];
  String decChar = split(settings[2],'|')[1];
  String formatSplitChar = split(settings[3],'|')[1];
  //load csv data line by line
  String[] fullLines = loadStrings(filename);
  //get a single line and split it to check how many cells there is on x axis
  String[] calcLine = split(fullLines[0], sepChar);

  //store each csv cell in 2d array
  String[][] cells = new String[fullLines.length][calcLine.length];
  for (int i = 0; i < fullLines.length; i++)
  {
    String[] splitLine = split(fullLines[i], sepChar);
    for (int j = 0; j < splitLine.length; j++)
    {
      cells[i][j] = splitLine[j];
    }
  }

  //array that will store all the final data
  String[] ConvertedData = new String[0];

  //get start positions for all tables
  int[] TableYStartPositions = new int[0];
  for (int j = 0; j < cells[0].length; j++)
  {
    if (!cells[0][j].equals("")) 
    {
      TableYStartPositions = concat(TableYStartPositions, new int[]{j});
    }
  }

  //convert data
  for (int j = 0; j < TableYStartPositions.length; j++)
  {
    //add table name
    ConvertedData = concat(ConvertedData, new String[]{"", cells[0][TableYStartPositions[j]]});

    //save table format and add them to array
    String[] TableFormatOriginal = split(cells[1][TableYStartPositions[j]], formatSplitChar);
    String[] TableFormat = split(cells[1][TableYStartPositions[j]], formatSplitChar);
    for (int k = 0; k < TableFormat.length; k++)
    {
      TableFormatOriginal[k] = TableFormatOriginal[k].toLowerCase();
      if (TableFormatOriginal[k].equals("color"))
      {
        TableFormatOriginal[k] = "Color";
      }
      TableFormat[k] = cells[2][TableYStartPositions[j]+k]+ "," +TableFormatOriginal[k];
    }
    //add table format to converted data
    ConvertedData = concat(ConvertedData, TableFormat);
    ConvertedData = concat(ConvertedData, new String[]{""});

    //calculate table row count
    int rowAmount = 0;
    for (int l = 0; l < TableFormat.length; l++)
    {
      int currentramt = 0;
      for (int k = 3; k < cells.length-1; k++)
      {
        if (!cells[k][TableYStartPositions[j]+l].equals(""))
        {
          currentramt++;
        }
      }
      if (currentramt > rowAmount) {
        rowAmount = currentramt;
      }
    }

    //initialize converted row strings
    String[] currentRows = new String[rowAmount];
    for (int k = 0; k < rowAmount; k++)
    {
      currentRows[k] = "";
    }

    //read row data and add to converted row
    for (int k = 0; k < rowAmount; k++)
    {
      for (int l = 0; l < TableFormat.length; l++)
      {
        String cellvalue = cells[3+k][TableYStartPositions[j]+l];
        //check if cell is empty for autofill
        if (!cellvalue.equals(""))
        {
          if(TableFormatOriginal[l].equals("float"))
          {
            if(cellvalue.indexOf("/") > 0)
            {
              float a = float(split(cellvalue,'/')[0]);
              float b = float(split(cellvalue,'/')[1]);
              cellvalue = str(a/b);
            }
            if(cellvalue.indexOf("%") > 0)
            {
              if(cellvalue.indexOf(".") > 0)
              {
                String nstr = split(cellvalue,"%")[0];
                cellvalue = str(1.0/100.0*float(nstr));
              }
              else if(cellvalue.indexOf(",") > 0)
              {
                String nstr = split(cellvalue,"%")[0];
                nstr = nstr.replace(",",".");
                print(nstr);
                cellvalue = str(1.0/100.0*float(nstr));
              }
              else
              {
                float a = float(cellvalue);
                cellvalue = str(1.0/100.0*a);
              }
            }
          }
          //format color
          if (TableFormatOriginal[l].equals("Color"))
          {
            if (cellvalue.substring(0, 1).equals("#"))
            {
              cellvalue =  split(cellvalue, '#')[1];
            }
          }
          //format bool
          if (TableFormatOriginal[l].equals("bool"))
          {
            cellvalue.toUpperCase();
            if (cellvalue.equals("0")) {
              cellvalue = "FALSE";
            } 
            if (cellvalue.equals("1")) {
              cellvalue = "TRUE";
            }
          }
        } else
        {
          //autofill for each value
          switch(TableFormatOriginal[l])
          {
          case "int"   : 
            cellvalue = "0"; 
            break;
          case "float" : 
            cellvalue = "0.0"; 
            break;
          case "string": 
            cellvalue = "null"; 
            break;
          case "bool"  : 
            cellvalue = "FALSE"; 
            break;
          case "Color" : 
            cellvalue = "FFFFFF"; 
            break;
          default      : 
            cellvalue = "0"; 
            break;
          }
        }
        currentRows[k] += cellvalue;
        if (l < TableFormat.length-1)
        {
          currentRows[k] += "}";
        }
      }
      //convert csv characters to rec room characters
      currentRows[k] = currentRows[k].replace(decChar.charAt(0), '.');
      currentRows[k] = currentRows[k].replace('}', ',');
    }
    //add rows to converted data
    ConvertedData = concat(ConvertedData, currentRows);
  }
  //export
  saveStrings("data.txt", ConvertedData);
  exit();
}
