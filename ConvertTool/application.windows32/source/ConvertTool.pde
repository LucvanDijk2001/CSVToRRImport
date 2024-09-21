void setup()
{
  String filename = loadStrings("Filename.txt")[0];
  //load csv data line by line
  String[] fullLines = loadStrings(filename);
  //get a single line and split it to check how many cells there is on x axis
  String[] calcLine = split(fullLines[0], ';');
  
  //store each csv cell in 2d array
  String[][] cells = new String[fullLines.length][calcLine.length];
  for (int i = 0; i < fullLines.length; i++)
  {
    String[] splitLine = split(fullLines[i], ';');
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
    if (cells[0][j].length() >= 1) 
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
    String[] TableFormat = split(cells[1][TableYStartPositions[j]], ',');
    for (int k = 0; k < TableFormat.length; k++)
    {
      TableFormat[k] =  cells[2][TableYStartPositions[j]+k]+ "," +TableFormat[k].toLowerCase();
      if(TableFormat[k] == "color")
      {
         TableFormat[k] = "Color"; 
      }
    }
    //add table format to converted data
    ConvertedData = concat(ConvertedData, TableFormat);
    ConvertedData = concat(ConvertedData, new String[]{""});
    
    //calculate table row count
    int rowAmount = 0;
    for (int k = 3; k < cells.length-1; k++)
    {
      if (cells[k][TableYStartPositions[j]].length() >= 1)
      {
        rowAmount++;
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
        if(TableFormat[l] == "Color")
        {
           if(cellvalue.substring(0,1) == "#")
           {
            cellvalue =  split(cellvalue,'#')[1];
           }
        }
        if(TableFormat[l] == "bool")
        {
           cellvalue.toUpperCase();
           if(cellvalue == "0"){cellvalue = "FALSE";} 
           if(cellvalue == "1"){cellvalue = "TRUE";} 
        }
        currentRows[k] += cellvalue;
        if (l < TableFormat.length-1)
        {
          currentRows[k] += "-";
        }
      }
      //convert csv characters to rec room characters
      currentRows[k] = currentRows[k].replace(',', '.');
      currentRows[k] = currentRows[k].replace('-', ',');
    }
    //add rows to converted data
    ConvertedData = concat(ConvertedData, currentRows);
  }
  //export
  saveStrings("data.txt", ConvertedData);
  exit();
}
