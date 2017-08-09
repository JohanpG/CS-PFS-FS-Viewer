/////////////////////////////////
//-----------------------------//
//--------Omnicon S.A ---------//
//--------Johan Porras --------//
/////////////////////////////////


//Variable array with the objects from the use case
var dataUseCase = [];
//Funtion to create and refrest the pop over for each each based on the use case data loaded
    function refreshPopOver(Data)
    {
        var dataUseCase = Data;
        //console.log(dataUseCase);
        var diagramData = window.svgpublish.shapes;
        //Get the modal
        var modal = document.getElementById('myModal');
        
        $.each(diagramData, function (shapeId, shapeData) {

            var props = shapeData.Props;
            //var props = Datajsonformat.;
            if (!props)
                return;

            //Get Object matching the usecase 
            function getValue(useCaseID) {
                var val=[];
                $.each(dataUseCase, function (i,e) {
                    if (e["Use Case ID"].indexOf(useCaseID) >= 0) {
                        val = e;
                        return false;
                    }
                });
                return val;
            };

            if (typeof props["Use Case ID"] !== "undefined")//Only when the shae has the property Use Case ID (Only Activities)
            {
                 var useCaseActivity = getValue(props["Use Case ID"]);
                //Split Steps 
                var steps ="";
                if (typeof useCaseActivity["Steps"] !== "undefined") {
                    steps = useCaseActivity["Steps"].replace(/\n/g, '<br />');
                }


                var $shape = $("#" + shapeId);
                //Dinamic content 
                var existingContent = '' +'<p>';
                //Activity Name
                if (typeof useCaseActivity["Activity Name"] !== "undefined") {
                    existingContent = existingContent + '<span style="color: #658D1B" class= "h4" > ' + useCaseActivity["Activity Name"] + '<br/></div>';
                }
                //Certified Activity Name
                if (typeof useCaseActivity["Certified Activity Name"] !== "undefined") {
                    existingContent = existingContent + '<span style="color: #658D1B" class= "h4" > ' + useCaseActivity["Certified Activity Name"] + '<br/></div>';
                }
                //Use Case ID
                if (typeof useCaseActivity["Use Case ID"] !== "undefined") {
                    existingContent = existingContent + '<span class="text-muted small"> ' + useCaseActivity["Use Case ID"] + '</span>';
                }
                existingContent = existingContent + '</p>';
                //Actor
                if (typeof useCaseActivity["Actor"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Actor:</b> ' + useCaseActivity["Actor"] + '</p>';
                }
                //Location
                if (typeof useCaseActivity["Location"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Location:</b> ' + useCaseActivity["Location"] + '</p>';
                }
                //Description
                if (typeof useCaseActivity["Description"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Description:</b> <p>' + useCaseActivity["Description"] + '</p></p>';
                }
                //Steps
                if (typeof useCaseActivity["Steps"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Steps:</b><p>' + useCaseActivity["Steps"] + '</p></p>';
                }

                //Variations
                if (typeof useCaseActivity["Variations"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Variations:</b><p>' + useCaseActivity["Variations"] + '</p></p>';
                }
                //Activity notes
                if (typeof useCaseActivity["Activity Notes"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Notes:</b> <p>' + useCaseActivity["Activity Notes"] + '</p></p>';
                }
                //Related Documents
                if (typeof useCaseActivity["Related Documents"] !== "undefined") {
                    existingContent = existingContent + '<p><b>Documents:</b><p> ' + useCaseActivity["Related Documents"] + '</p></p>';
                }
                //Mockup
                if (typeof useCaseActivity["Certified Mockups ID"] !== "undefined" && useCaseActivity["Certified Mockups ID"] != "") {
                    existingContent = existingContent + '<p><b>Mockup:</b><a onclick="displayModal(' + "'" + shapeId + "'" + ',' + "'" + useCaseActivity["Certified Mockups ID"] + "'" + ')">   View</button></p>';
                }
                //Add Breaks 
                existingContent = existingContent.replace(/\n/g, '<br />');

                // build options for popover: placement function, iframe url from properties
                var options = {
                    placement: function (context, source) {
                        var position = $(source).position();
                        if (position.right > 500)
                            return "left";
                        if (position.left < 500)
                            return "right";
                        if (position.top < 300)
                            return "bottom";
                        return "top";
                    },
                    trigger: "manual",
                    container: "html",
                    html: true,
                    //Populate Pop over
                    content: existingContent,
                    title:"Activity Information"
                    //useCaseActivity["Activity Name"]
                };

                // create the popover for the shape        
                $shape.popover(options);

                // decorate the shape with "hand" cursor
                $shape.css("cursor", "pointer");

                // hide the popover hiding when clicked outside
                $('body').on('click', function (e) {
                    //Ignore when modal image close button clicked
                    if (e.target.className == "close")
                        return;
                    $shape.popover('hide');
                    //modal.style.display = "none";
                });

                $shape.on('click', function (evt) {
                    evt.stopPropagation();
                    $shape.popover('toggle');
                });

                $shape.on('mouseover', function () {
                    $(this).attr('filter', 'url(#hover)');
                });

                $shape.on('mouseout', function () {
                    $(this).removeAttr('filter');
                });

                $shape.tooltip({
                    container: "body",
                    title: props.Name
                });
                
            }
        });
}

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

function getJSONP(url, success) {

    var ud = '_' + +new Date,
        script = document.createElement('script'),
        head = document.getElementsByTagName('head')[0]
               || document.documentElement;

    window[ud] = function (data) {
        head.removeChild(script);
        success && success(data);
    };

    script.src = url.replace('callback=?', 'callback=' + ud);
    head.appendChild(script);

}

  
//fUNCTION TO DISPLAY MODAL IMAGE SFOR MOCKUPS
    function displayModal(shapeId, code) {
        //Hide Pop Overs
        $("body").trigger("click")
        var caption = code;
        //Hide Pop Overs
       var $shape = $("#" + shapeId);
        // Get the modal
        var modal = document.getElementById('myModal');
        // Get the image and insert it inside the modal - use its "alt" text as a caption
        var modalImg = document.getElementById("img01");
        var captionText = document.getElementById("caption");
        modal.style.display = "block";
        //Set mock up patch
        var Folder = '../Mockups%20Library/';
        var fullPath = Folder + code +'.png';
        modalImg.src = fullPath;
        captionText.innerHTML = caption;

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks on <span> (x), close the modal
        span.onclick = function () {
            modal.style.display = "none";
            $shape.popover('toggle');

        }
    }

  