#****************************
#*****Johan Porras 2017******
#****************************
#*******Omnicon S.A**********

#Next Line is to provide rights to execute the scrip on some pcs
#Set-ExecutionPolicy Unrestricted -Scope Proces
#Get Parent Folder
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
#Joint source path to parent folder
$SourceFolder =  Join-Path $executingScriptDirectory "\LogFiles\"
$files = Get-ChildItem  $SourceFolder 
ForEach ($file in $files) 
{
    #Read Log File
    $Log = Get-Content $file.FullName
    #Find messages between <Rowsets> Tokens
    $msj = [regex]::match($Log,'(?si)<Rowsets>(.*?)</Rowsets>')
    #Get message type 
    $MessageType = [regex]::match($msj.Value,'(?si)<MessageType>(.*?)</MessageType>').Groups[1].Value
    #Set Proper labels
    $MatMasLabel="MATMAS"
    $ProdLabel="PRODSCHED"
    $ProdConfLabel="PRODORDCONF"
    $InspLabel="INSPSCHED"
    $RcvLabel="RECEIVESCHED"
    $RcvConfLabel="RECEIVECONF"
    $ShpLabel="SHIPSCHED"
    $ShpConfLabel="SHIPCONF"
    #Material master
    if($MessageType.Contains($MatMasLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<SAPMaterialNumber>(.*?)</SAPMaterialNumber>').Groups[1].Value
    }
    #Production Schedule
    if($MessageType.Contains($ProdLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<ProcessOrderNumber>(.*?)</ProcessOrderNumber>').Groups[1].Value

    }
    #Production Confirmation
    if($MessageType.Contains($ProdConfLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<ProcessOrderNumber>(.*?)</ProcessOrderNumber>').Groups[1].Value

    }
    #Inspection Lot
    if($MessageType.Contains($InspLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryNumber>(.*?)</DeliveryNumber>').Groups[1].Value

    }
    #Receiving Schedule
    if($MessageType.Contains($RcvLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryOrderNum>(.*?)</DeliveryOrderNum>').Groups[1].Value

    }
    #Receiving Conf
    if($MessageType.Contains($RcvConfLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryOrderNum>(.*?)</DeliveryOrderNum>').Groups[1].Value

    }
    #Shippign Schedule
    if($MessageType.Contains($ShpLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<ShipOrderNum>(.*?)</ShipOrderNum>').Groups[1].Value

    }
    #Shippign Schedule
    if($MessageType.Contains($ShpConfLabel))
    {
        $ERPCode = [regex]::match($msj.Value,'(?si)<ShipOrderNum>(.*?)</ShipOrderNum>').Groups[1].Value

    }

    #Create New File 
    $OutputFile="\OutputMessages\"+ $MessageType +"_"+ $ERPCode + ".xml"
    $DestinationFile =  Join-Path $executingScriptDirectory $OutputFile
    New-Item $DestinationFile -type file -force
    write-output $msj.Value | add-content $DestinationFile
    # Iterate to get all the SAP Messages
    while(1)
    {
        #Get  next Message on the file
        $msj= $msj.NextMatch()

        if($msj.Success)
        {
            #Replace for production
            $Replaced = $msj.Value -replace "<ProductionOrderHeader>", "<Rowset>"
            $Replaced = $Replaced -replace "</ProductionOrderHeader>", "</Rowset>"
            $Replaced = $Replaced -replace "<ProductionOrderHeader_Columns>", "<Columns>"
            $Replaced = $Replaced -replace "</ProductionOrderHeader_Columns>", "</Columns>"
            $Replaced = $Replaced -replace "<ProductionOrderHeader_Row>", "<Row>"
            $Replaced = $Replaced -replace "</ProductionOrderHeader_Row>", "</Row>"
            $Replaced = $Replaced -replace "<ProductionOrderOperationPhase>", "<Rowset>"
            $Replaced = $Replaced -replace "</ProductionOrderOperationPhase>", "</Rowset>"
            $Replaced = $Replaced -replace "<ProductionOrderOperationPhase_Columns>", "<Columns>"
            $Replaced = $Replaced -replace "</ProductionOrderOperationPhase_Columns>", "</Columns>"
            $Replaced = $Replaced -replace "<ProductionOrderOperationPhase_Row>", "<Row>"
            $Replaced = $Replaced -replace "</ProductionOrderOperationPhase_Row>", "</Row>"
            $Replaced = $Replaced -replace "<ProductionOrderItems>", "<Rowset>"
            $Replaced = $Replaced -replace "</ProductionOrderItems>", "</Rowset>"
            $Replaced = $Replaced -replace "<ProductionOrderItems_Columns>", "<Columns>"
            $Replaced = $Replaced -replace "</ProductionOrderItems_Columns>", "</Columns>"
            $Replaced = $Replaced -replace "<ProductionOrderItems_Row>", "<Row>"
            $Replaced = $Replaced -replace "</ProductionOrderItems_Row>", "</Row>"
            $Replaced = $Replaced -replace "<ProductionOrderCharacteristics>", "<Rowset>"
            $Replaced = $Replaced -replace "</ProductionOrderCharacteristics>", "</Rowset>"
            $Replaced = $Replaced -replace "<ProductionOrderCharacteristics_Columns>", "<Columns>"
            $Replaced = $Replaced -replace "</ProductionOrderCharacteristics_Columns>", "</Columns>"
            $Replaced = $Replaced -replace "<ProductionOrderCharacteristics_Row>", "<Row>"
            $Replaced = $Replaced -replace "</ProductionOrderCharacteristics_Row>", "</Row>"
            
            #Get message type 
            $MessageType = [regex]::match($msj.Value,'(?si)<MessageType>(.*?)</MessageType>').Groups[1].Value
            #Material master
            if($MessageType.Contains($MatMasLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<SAPMaterialNumber>(.*?)</SAPMaterialNumber>').Groups[1].Value
            }
            #Production Schedule
            if($MessageType.Contains($ProdLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<ProcessOrderNumber>(.*?)</ProcessOrderNumber>').Groups[1].Value

            }
            #Production Confirmation
            if($MessageType.Contains($ProdConfLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<ProcessOrderNumber>(.*?)</ProcessOrderNumber>').Groups[1].Value

            }
            #Inspection Lot
            if($MessageType.Contains($InspLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryNumber>(.*?)</DeliveryNumber>').Groups[1].Value

            }
            #Receiving Schedule
            if($MessageType.Contains($RcvLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryOrderNum>(.*?)</DeliveryOrderNum>').Groups[1].Value

            }
            #Receiving Conf
            if($MessageType.Contains($RcvConfLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<DeliveryOrderNum>(.*?)</DeliveryOrderNum>').Groups[1].Value

            }
            #Shippign Schedule
            if($MessageType.Contains($ShpLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<ShipOrderNum>(.*?)</ShipOrderNum>').Groups[1].Value

            }
            #Shippign Schedule
            if($MessageType.Contains($ShpConfLabel))
            {
                $ERPCode = [regex]::match($msj.Value,'(?si)<ShipOrderNum>(.*?)</ShipOrderNum>').Groups[1].Value

            }
            #Set New File Name 
            $OutputFile="\OutputMessages\"+ $MessageType +"_"+ $ERPCode + ".xml"
            $DestinationFile =  Join-Path $executingScriptDirectory $OutputFile
            #Write-Host $Replaced
            #Create New File 
            New-Item  $DestinationFile -type file -force
            write-output $Replaced | add-content  $DestinationFile  

          
        }
        else
        {
            Write-Host "Press any key to continue ..."
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            Write-Host
            Write-Host "Next Log File....."
            
            break 
        }
            
    }
  }
  
  Write-Host "Press any key to continue ..."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  Write-Host
  Write-Host "Closing..."
