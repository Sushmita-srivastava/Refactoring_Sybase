function checkLength(text, min, max)
{
	min = min || 1;
	max = max || 100;

	if (text.length < min || text.length > max) 
	{
		return false;
	}
	return true;
}

function checkRadio(radioButtons)	
{
	for (var i=0; i < radioButtons.length; i++) 
	{
		if (radioButtons[i].checked) 
			return true;
	}
	return false;
}

function checkSelect(text)
{
	if (text==0)
		return false;
	return true;
}

function checkCheckbox(text)
{
	if (text.checked==0)
		return false;
	return true;
}

function checkNumber(text)
{
	if (isNaN(text))
		return false;
	return true;
}

function checkEmail(email)
{
	var atpos=email.indexOf("@");
	var dotpos=email.lastIndexOf(".");
	
	if(email.length<1||(atpos<1 || dotpos<atpos+2 || dotpos+2>=email.length))
		return false;
	return true;
}

function reportErrors(errors)
{
	var msg = "Please enter valid details for :\n";
	var numError;
	for (var i = 0; i<errors.length; i++) 
	{
		numError = i + 1;
		msg += "\n" + numError + ". " + errors[i];
	}
	alert(msg);
}