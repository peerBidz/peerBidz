$(document).ready(function(){

    //When checkbox is checked
    $("#checksellerbox").click(function(){
        alert("ajax working");
        callAjax();
    });

    function callAjax(){

        $('#ajax_ccard_info').load('creditck.html #ajax_group');
        return false;

/*
        $.ajax({
                type: "GET",
                url: "./items/creditck.html",
                data: "",
                success: function (data) {
                $("#ajax_ccard_info").html(data);
                //alert("success?");
                },
                error: function () {
                alert('ajax failure:');
                }
        });
*/
    }

});