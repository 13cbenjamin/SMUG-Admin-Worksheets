function wsOnLoad(){ 
  //<!--
  //import SMTP JS file
 $('head').append('<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js"> </script>');
 $('head').append('<script type="text/javascript"> (function(){emailjs.init("3WixQ7OKoH2-xsQOS");})()</script>')
  $('textarea').css('white-space' , 'pre-wrap').css('width', '100%');
  $('input[name*="TextBox_"]').addClass("form-control"); // add bootstrap form-control class to TextBox elements
  $('input[name*="CheckBox_"]').addClass("form-check-input"); // add bootstrap form-check-input class to CheckBox elements
  $('textarea[name*="TextBox_"]').addClass("form-control"); // add bootstrap form-control class to CommentBox elements

  // Set Date TextBoxes to be Date Pickers
  //Set all date pickers in step payments to date pickers. 
$("#TextBox_216_3,#TextBox_216_300,#TextBox_216_301").attr({type:"date"})
$("#TextBox_216_4,#TextBox_216_800,#TextBox_216_801,#TextBox_216_200,#TextBox_216_900").attr({type:"time"})

// when Show example is clicked for disbursement video
$("#showDisbursementInstructionVideo").on("click", function (){ 
$("#disbursementvideo").fadeToggle().toggleClass("collapse");
})
$("#showDisbursementInstructionVideo2").on("click", function (){ 
$("#disbursementvideo2").fadeToggle().toggleClass("collapse");
})

// Update first check number from Step 4 to Step 12 to avoid repeating entry
// we will also set the box in step 12 to disabled and add a title tag
$("#TextBox_216_400").on("change", function () {
  console.log('setting Step 12 first check number to ' + $(this).val())
  $("#TextBox_216_121").val($(this).val())
  $("#TextBox_216_121").attr("disabled", true)
  $("#TextBox_216_121").css("border", "1px solid blue")
  $("#TextBox_216_121").prop("title", "This box is set when performing step 4. \nIf this number is wrong, go back and review step 4 \nAlso ensure the first check in printer did not change")
  let element = document.getElementById('TextBox_216_121')
  triggerEvent(element, 'change');
})
// Update next good check number from Step 12 to Step 17 to avoid repeating entry
// we will also set the box in step 17 to disabled and add a title tag
$("#TextBox_216_123").on("change", function () {
  console.log('setting Step 12 first check number to ' + $(this).val())
  $("#TextBox_216_171").val($(this).val())
  $("#TextBox_216_171").attr("disabled", true)
  $("#TextBox_216_171").css("border", "1px solid blue")
  $("#TextBox_216_171").prop("title", "This box is set when performing step 12. \nIf this number is wrong, go back and review step 12 \nAlso ensure the first check in printer did not change")
  let element = document.getElementById('TextBox_216_171')
  triggerEvent(element, 'change');
})

// Function to check if the cutoff date is a date other than today, this will indicate if worksheet has values from a previous month remaining. 
$("#TextBox_216_3").each(function () {
  let myDate = new Date();
  let newDate = []
newDate.push(myDate.getFullYear(), '-', myDate.getMonth()+1, '-', myDate.getDate())
console.log('newDate ' + newDate);
console.log('newDate.join()' + newDate.join(''))
console.log('Today' + $(this).val())
  if ($(this).val() !== newDate.join('')) {
    alert("If this is a new disbursement, You Must Click Reset before proceeding")
  }
})

// Disbursement Backup Old Instructions
$("#showOldDisbursementInstructions").on("click", function() {
  $("#oldDisbursementInstructions").fadeToggle().toggleClass("collapse");
})
// Disbursement Backup Old Instructions
$("#showOldDisbursementInstructions2").on("click", function() {
  $("#oldDisbursementInstructions2").fadeToggle().toggleClass("collapse");
})


// Completed BOXES -  When a completed Checkbox is Checked, change closest Table Header to Green background 
$("[id^=CheckBox_216_9]").on("click",function () {
  if ($(this).is(":Checked")) {
      $(this).closest("tr").css("background", "#288000"); // change background color
    } else {
      $(this).closest("tr").css("background", "#FFF"); // change background color
    }
})

// COmpleted Boxes - When worksheet loads, if box was checked, then change background color. This is to preserve refreshes
$("[id^=CheckBox_216_9]").each(function () {
  if ($(this).is(":Checked")) {
      $(this).closest("tr").css("background", "#288000"); // change background color
    } else {
      $(this).closest("tr").css("background", "#FFF"); // change background color
    }
})

$("#sendEmailButton").on('click', function () {
  $("#sendEmailButton").val("Sending...").removeClass("bg-info").addClass("bg-warn")
    var data = {
      service_id: 'service_d29hxe5',
      template_id: 'template_ou3n0h7',
      user_id: '3WixQ7OKoH2-xsQOS',
      template_params: {
          'subject': 'Cutoff Starting',
          'body': 'We are commencing cutoff. Please log out of TNG. You may log back in with the inquiry password: perusal '
      }
    };

    $.ajax('https://api.emailjs.com/api/v1.0/email/send', {
      type: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json'
    }).done(function() {
      alert('Email Sent Successfully!');
      $("#sendEmailButton").val("Send Email").removeClass("bg-warn").addClass("bg-info")
    }).fail(function(error) {
      alert('Oops... Mail Failed, Error: ' + JSON.stringify(error));
      $("#sendEmailButton").val("Send Email").removeClass("bg-warn").addClass("bg-info")
    });
    });


    $("#cutoffDoneEmailButton").on('click', function () {
      $("#cutoffDoneEmailButton").val("Sending...").removeClass("bg-info").addClass("bg-warn")
        var data = {
          service_id: 'service_d29hxe5',
          template_id: 'template_ccsz626',
          user_id: '3WixQ7OKoH2-xsQOS',
          template_params: {
              'subject': 'Cutoff Complete',
              'body': 'Cutoff is complete. Thank you for your patience. You may log back in now using your normal TNG account'
          }
        };
  
        $.ajax('https://api.emailjs.com/api/v1.0/email/send', {
          type: 'POST',
          data: JSON.stringify(data),
          contentType: 'application/json'
        }).done(function() {
          alert('Email Sent Successfully!');
          $("#cutoffDoneEmailButton").val("Send Email").removeClass("bg-warn").addClass("bg-info")
        }).fail(function(error) {
          alert('Oops... Mail Failed, Error: ' + JSON.stringify(error));
          $("#cutoffDoneEmailButton").val("Send Email").removeClass("bg-warn").addClass("bg-info")
        });
  
        });

}

// called when an event needs triggered so that worksheet will recognize a Change has occurred and update tblCaseWorksheetData
function triggerEvent(element, eventName) {
  var event = new Event(eventName);
  element.dispatchEvent(event);
}