function openVMRC(){
    var url = "/rms-mng.web/vguests-mng/4028947341a20fb00141bae1620675a4/openVMRC"
            +"?vmId=vm-2244"+"&decorator=ajax&confirm=true";
    $.get(url,{},function(data) {
        $('#openVmrc').dialog({
            width:900,
            height:550
        });
        $('#openVmrc').html(data);
    });
}

judge=function(obj,type){
    if(type =="accemail"){
        authenAccEmail($(obj).val(),obj);
    }
    else
    if(type =="password")
    {
        authenPass($(obj).val(),obj);
    }
    if(type =="orgname")
    {
        authenOrgName($(obj).val(),obj);
    }
    if(type =="appname")
    {
        authenAppName($(obj).val(),obj);
    }
    if(type =="appinstnum")
    {
        authenAppInstNum($(obj).val(),obj);
    }
    if(type =="sername")
    {
        authenSerName($(obj).val(),obj);
    }
    if(type =="hostname")
    {
        authenHostName($(obj).val(),obj);
    }
}
authenPass=function(value,obj){
   var pwd1=document.getElementById("password").value;
   var pwd2=document.getElementById("password_confirmation").value;
   console.log($(obj).next());
   if(pwd1==pwd2)
       $(obj).next().css("display","");
   else
       $(obj).next().css("display","none");

}

authenAccEmail=function(value,obj){
    $.ajax({type:"GET",
            url:"/adaccount/authented",
            data:{type:"accemail",value:value},
            dataType:"json",
            success:function(result){
                console.log(result["res"]);
                console.log($(obj).next());
                if(result["res"] == "valid")
                {
                    var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
                    if(!myreg.test(value)){}
                    else
                    $(obj).next().css("display","");
                }
                else
                    $(obj).next().css("display","none");
            },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
            });
}
authenOrgName=function(value,obj){
    $.ajax({type:"GET",
        url:"/adaccount/authented",
        data:{type:"orgname",value:value},
        dataType:"json",
        success:function(result){
            console.log(result["res"]);
            console.log($(obj).next());
            if(result["res"] == "valid")
            {
                $(obj).next().css("display","");
            }
            else
                $(obj).next().css("display","none");
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
    });
}
authenAppName=function(value,obj){
    $.ajax({type:"GET",
        url:"/applications/authented",
        data:{type:"appname",value:value},
        dataType:"json",
        success:function(result){
            console.log(result["res"]);
            console.log($(obj).next());
            if(result["res"] == "valid")
            {
                $(obj).next().css("display","");
            }
            else
                $(obj).next().css("display","none");
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
    });
}
authenAppInstNum=function(value,obj){
    var num=document.getElementById("appinsnum").value;
    console.log($(obj).next());
    var reg = new RegExp("^[1-9]$");
    console.log(reg.test(num));
    if(reg.test(num))
        $(obj).next().css("display","");
    else
        $(obj).next().css("display","none");

}
authenSerName=function(value,obj){
    $.ajax({type:"GET",
        url:"/service/authented",
        data:{type:"sername",value:value},
        dataType:"json",
        success:function(result){
            console.log(result["res"]);
            console.log($(obj).next());
            if(result["res"] == "valid")
            {
                $(obj).next().css("display","");
            }
            else
                $(obj).next().css("display","none");
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
    });
}
authenHostName=function(value,obj){
    var domain=document.getElementById("domainname").value;
    $.ajax({type:"GET",
        url:"/applications/authented",
        data:{type:"hostname",value:value,domainname:domain},
        dataType:"json",
        success:function(result){
            console.log(result["res"]);
            console.log($(obj).next());
            if(result["res"] == "valid")
            {
                $(obj).next().css("display","");
            }
            else
                $(obj).next().css("display","none");
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
    });
}
getAppStartInfo=function(statues){
    var a=document.getElementById("preview");
    a.innerHTML="";
    var onep=document.createElement("p");
    onep.appendChild(document.createTextNode("请稍候，正在收集信息。"))
    document.getElementById("preview").appendChild(onep);
    if(statues==false){
        var stopp=document.createElement("p");
        stopp.appendChild(document.createTextNode("当前应用未启动，无信息可查看。"))
        document.getElementById("preview").appendChild(stopp);
    }
    else{
        getAppInfo(0);
        int=setInterval("getAppInfo(1)",3000);
    }

}
getAppInfo=function(times){

    var appid=document.getElementById("appid").value;
    $.ajax({type:"GET",
        url:"/applications/getinfo",
        data:{appid:appid,timetype:times},
        dataType:"json",
        success:function(result){
            console.log(result);
            for(var i=0;i<result.length;i++){
                var onep=document.createElement("p");
                onep.appendChild(document.createTextNode(result[i]['log']))
                document.getElementById("preview").appendChild(onep);
            }
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
            alert(XMLHttpRequest.status);
            alert(XMLHttpRequest.readyState);
            alert(textStatus);
        }
    });
}