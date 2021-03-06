#****************************
#*****Johan Porras 2017******
#****************************
#*******Omnicon S.A**********

#Next Line is to provide rights to execute the scrip on some pcs
#Set-ExecutionPolicy Unrestricted -Scope Proces
#Get Parent Folder
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
#Joint source path to parent folder
$SourceFolder =  Join-Path $executingScriptDirectory "\Views\"
$files = Get-ChildItem  $SourceFolder 
ForEach ($file in $files) 
{
    #Read Log File
    $View = Get-Content $file.FullName
    #Find messages between <Rowsets> Tokens
    # Add Use Case and Call popvoer Function
    $DocReady='$(document).ready(function () {
        $("div.svg").panzoom({ svg: $("div.svg > svg").get(0), viewBox: "0 0 1190.55 841.89" }).removeClass("appear");
        //Read and load json function
        var url = "CANUSFSDREVI.txt";//Specifies DATA FILE
        //Read tghe use case data
        dataUseCase = getJData(url);
        //Rehresh Pop Over
        refreshPopOver(dataUseCase);
    });'
    $lineNumber = 16
   # $View[$lineNumber-1]= $DocReady
   # $View | Set-Content $file.FullName

    #Add libraries Import
    $libraries= '<!-- Import Utilities functions and style for Pop Over -->
    <script src="vp/xlsx.full.min.js" type="text/javascript"></script>
    <script src="vp/utilitiesSP.js" type="text/javascript"></script>
    <script src="vp/utilities.js" type="text/javascript"></script>
    <link href="vp/style_PopOver.css" rel="stylesheet" />'
    $lineNumber = 12
    $View[$lineNumber-1] += $libraries
    $View | Set-Content $file.FullName

    #Appedn the modal screen
    $index = 0
    $theModal='
    <!-- The Modal -->
    <div id="myModal" class="modal">
    <span class="close">&times;</span>
    <img class="modal-content" id="img01">
    <div id="caption"></div>
    </div>'
    $theExcel='
    <input type="file" name="myfile" id="my_file_input" />
    <div id="my_file_output"></div>'
    $View| Foreach-Object { 
        $index = $index + 1
        if ($_ -like "<body>") 
        {
            Write-Host "Line where string is found: "$index
            $View[$index-1] += $theModal
            $View | Set-Content $file.FullName
            

        }
        if ($_ -like "*</svg> Shape Links*") 
        {
            Write-Host "Line where string is found: "$index
            $View[$index+2] += $theExcel
            $View | Set-Content $file.FullName
           # break

        }
    
   }
   
    Write-Host "Press any key to continue ..."
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host
    Write-Host "Next View File....."
    
  }
  
  Write-Host "Press any key to continue ..."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  Write-Host
  Write-Host "Closing..."
