//Variable with the objects form the use case
var dataUseCase = [];
//Funtion to create and refrest the pop over for each each bases on the data laoded
    //Funtions to Read XLSX
    var oFileIn;

    $(function()
    {
        oFileIn = document.getElementById('my_file_input');
        if(oFileIn.addEventListener)
        {
            oFileIn.addEventListener('change', filePicked, false);
        }
    });

    //Read and load json function
    var getJData = function (url) {
        var data = null;
        $.ajax({
            method: "GET",
            url: url,
            dataType: "json",
            async: false
        }).done(function (dd) {
            data = dd;
        });
        return data;
    }

    function filePicked(oEvent) 
    {
        // Get The File From The Input
        files = [];
        var oFile = oEvent.target.files[0];
        var sFilename = oFile.name;
        // Create A File Reader HTML5
        var reader = new FileReader();


        // Ready The Event For When A File Gets Selected
        reader.onload = function(e) 
        {
            var data = e.target.result;
            var workbook = XLSX.read(data, {type : 'binary'});

            /* DO SOMETHING WITH workbook HERE */
            var first_sheet_name = workbook.SheetNames[2];
            /* Get worksheet */
            var worksheet = workbook.Sheets[first_sheet_name];

            var Datajsonformat = XLSX.utils.sheet_to_json(worksheet);
            dataUseCase = Datajsonformat;
           // console.log(Datajsonformat);
            console.log(JSON.stringify(Datajsonformat));//To print entire json as string
            refreshPopOver();
        }
        reader.readAsBinaryString(oFile);
    }
