authenUserName=function(value,obj){
	$.get("/login/authented",{"type":"name","value":value},function(data){
		console.log(data);
		console.log($(obj).next())
		if(data != null)
			$(obj).next().css("display","");
		else
			$(obj).next().css("display","none");
			
	},"json");
}
authenPass=function(value,obj){
	$.get("/login/authented",{"type":"pass","value":value},function(data){
		
		if(data != null)
		{
			$(obj).next().css("display","");	
//			$("#submit").removeClass("disabled");
		}
		else{
			$(obj).next().css("display","none");	
//			$("#submit").addClass("disabled");
		}
	},"json");
}
judge=function(obj,type){
	if(type =="name"){
		authenUserName($(obj).val(),obj);
	}
	else 
	if(type =="pass")
	{
		authenPass($(obj).val(),obj);
	}
}
//$(function(){
//	var userSel = "input[placeholder=Username]";
//	var passSel = "input[placeholder=Password]";
//	var username=$(userSel).val();
//	var pass=$(passSel).val();
//	authenUserName(username,$(userSel));
//	authenPass(pass,$(passSel));
//});