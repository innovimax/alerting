
/* Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. */


function updateDelivery()
{
    var action=document.getElementsByName("act")[0].value;
//    alert(action);

//    var sms=document.getElementsByName("controlsms");
//    var email=document.getElementsByName("controlemail");

    if (action == "sms")
    {
        document.getElementById("controlphone").style.display = "";
        document.getElementById("controlprovider").style.display = "";
//        for(var i=0;i<sms.length;i++){sms[i].style.display = "";}
    }
    else
    {
        document.getElementById("controlphone").style.display = "none";
        document.getElementById("controlprovider").style.display = "none";
//        for(var i=0;i<sms.length;i++){sms[i].style.display = "none";}
    }
    
    if (action == "email" || action == "aggregate")
    {
//        alert("email yes " + email.length);
//        for(var i=0;i<email.length;i++){email[i].style.display = "";}
        document.getElementById("controlemail").style.display = "";
    }
    else
    {
//        alert("email no " + email.length);
//        for(var i=0;i<email.length;i++){email[i].style.display = "none";}
        document.getElementById("controlemail").style.display = "none";
    }
    
}

function ruleFormCheck(currentForm)
{
    var action = document.getElementsByName("act")[0].value;
    
    if (isEmpty('Title')) { return false; }

    if (isEmpty('Keywords')) { return false; }

    if (action == "sms")
    {
        if (isEmpty('Phone')) { return false; }
        var phoneNum = document.getElementById('Phone').value;
        var regExpObj = /^\d\d\d\d\d\d\d\d\d\d$/;
        if(regExpObj.exec(phoneNum) == null)
        {
            alert(phoneNum + " is not a valid phone number.");
            return false;
        }
    }

    if (action == "email" || action == "aggregate")
    {
        if(isEmpty('Email')) { return false; }
        var emailAddr = document.getElementById('Email').value;
        var regExpObj = /^[a-zA-Z0-9\.\_\-]*\@[a-zA-Z0-9\.\_\-]*$/;
        if(regExpObj.exec(emailAddr) == null)
        {
            alert(emailAddr + " is not a valid email address.");
            return false;
        }
    }

    return true;
}

function isEmpty(fieldName){
    if(document.getElementById(fieldName).value.length == 0){
        alert('Field "' + fieldName + '" is empty.');
        return true;
    }
    return false;
} 

/*
function validateContentForm(currentForm)
{


var validForm = false;
var inputs = currentForm.getElementsByTagName("input");

for (i = 0; i < inputs.length; i++)
{
	if (inputs[i].name.substring(0,4) == "vis-")
	{
		if (inputs[i].checked == true)
		{
			validForm = true;
		}
	}
}

if (validForm == false)
{
    alert("Must mark checkbox for at least one role.");
}

return validForm;

}
*/

