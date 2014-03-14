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
