function wsOnLoad(){ 

    $('textarea').css('white-space' , 'pre-wrap').css('width', '100%');
    //set comment boxes to have 4 rows
    $('textarea').attr('rows', '4');
    //add form control bootstrap 
    $('textarea[name*="TextBox_"]').addClass("form-control");
    //add form control bootstrap 
    $('input[name*="TextBox_"]').addClass("form-control"); // add bootstrap form-control class to TextBox elements
    $('input').addClass("form-control") // add bootstrap form-control class 
    // set all checkboxes to disabled on load
    $('input[name*="CheckBox"]').attr('disabled', 'true')
    //hide the hidden text box that stores value of drop down 
    $('[id$=08]').hide()
    //load the select box and necessary background colors when worksheet loads by checking value in hidden box 
    selectOnLoad();

    //function when the select drop down value is changed. 
    // this will be used to set the color of the row and enable the ready for cutoff checkbox. 
    $("select").change(function(){

        //get value of select box
        var selectedasset = $(this).children("option:selected").val();
        //get ID of select box
        var select_id = $(this).attr('id')
        //get hidden textbox id number 
        let hiddenTextBox_id = select_id.substring(0,5)
        hiddenTextBox_id = hiddenTextBox_id + '08'

        //$('#test').attr('id')
       // This function checks to see if the select drop down is 'Ready to Close'
       // If it is, it then locates the cooresponding textbox by canging the last 2 digits of the id from 07 to 03 
       // it then toggles the prop of disabled. 
       //This creates a 2-step approach to marking the case ready for cutoff 
        if(selectedasset == 'Ready to Close') {
            //enable checkbox
           let checkbox_id = select_id.substring(0,5)
           checkbox_id = checkbox_id + '03'
           $('input[name*="CheckBox_208_'+checkbox_id+'"]').prop("disabled", false)
            //update status
            $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('4')
            //set background color 
           $(this).closest('tr').css("background-color", "seagreen");
        }
        // Handle background color of table row changing effect 

       else if(selectedasset == 'Following'){
            $(this).closest('tr').css("background-color", "yellow");
                  //update status
                  $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('3')
        }

        else if(selectedasset == 'Need DSO'){
            $(this).closest('tr').css("background-color", "slategrey");
                    //update status
                    $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('2')
        }   

        else if(selectedasset == 'Need BAPCPA'){
            $(this).closest('tr').css("background-color", "lightgrey");
                      //update status
                      $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('1')
        }
        else if(selectedasset == 'Audit for PIF'){
            $(this).closest('tr').css("background-color", "#fabd3b");
                      //update status
                      $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('5')
        }

        else {
            let checkbox_id = select_id.substring(0,5)
            checkbox_id = checkbox_id + '03'
            $('input[name*="CheckBox_208_'+checkbox_id+'"]').prop("disabled", true)
            //set background color 
            $(this).closest('tr').css("background-color", "#ffffff");
            $('input[name*="TextBox_208_'+hiddenTextBox_id+'"]').val('')
         }

        // Save the value in the hidden textbox to the database 
         SaveEvent();

    })

    // this function will set the background color and select element of each select field based on the value saved in the hidden textbox. 
    function selectOnLoad(){
        $('.tac_select').find('input[name*="TextBox_"]').each(function()
        {
            //        $("select.asset1").val(document.getElementById("TextBox_193_101").value).change();
            let this_id = this.id 
            let this_value = this.value 
            if (!this_value) return
            let this_hiddenTextBox_id = this_id.substring(12,17)
            this_hiddenTextBox_id = this_hiddenTextBox_id + '08'
            let select_id = this_id.substring(12,17) + '07'
           // console.log(`select_id: ${select_id}`)

         //   console.log(`this_id: ${this_id} this_value: ${this_value} this_hiddenTextBox_id: ${this_hiddenTextBox_id}`)

 
            if (this_value == 1){
                $("#"+select_id).val('Need BAPCPA').change();
                $(this).closest('tr').css("background-color", "lightgrey");

            }
            if (this_value == 2){
                $("#"+select_id).val('Need DSO').change();
                $(this).closest('tr').css("background-color", "slategrey");
            }
            if (this_value == 3){
                $("#"+select_id).val('Following').change();
                $(this).closest('tr').css("background-color", "yellow");
            }
            if (this_value == 4){
                $("#"+select_id).val('Ready to Close').change();
                $(this).closest('tr').css("background-color", "seagreen");
            }
            if (this_value == 5){
                $("#"+select_id).val('Audit for PIF').change();
                $(this).closest('tr').css("background-color", "#fabd3b");
            }
            if (this_value == '') {
                $(this).closest('tr').css("background-color", "#FFFFFF");
            }
            // //console.log($(this))
            //$(this).val(document.getElementById(this.id).change();

        }

        )}



// this function is to save the value in the hidden text box into the tblCaseWorksheetData 
    function SaveEvent(){
        $('.tac_select').find('input[name*="TextBox_"]').each(function()
            {
                    var element = document.getElementById(this.id); 
                        var event; 
                        if(typeof(Event) === 'function') 
                        { // non IE browsers 
                            event = new Event('change'); 
                        }
                        else
                        { // IE 
                            event = document.createEvent('Event'); 
                            event.initEvent('change', true, true); 
                        } 
                        element.dispatchEvent(event);
        })
    }

}