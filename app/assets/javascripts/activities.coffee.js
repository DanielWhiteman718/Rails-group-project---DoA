$(document).ready(function(){
    $('#uni_module').change(function(){
        $selected_value=$('#uni_module option:selected').val();
        var id = $(this).children(":selected").val();     
        var params = 'module_id=' + id;
        $.ajax({
            url: "/activities/change_module",
            data: params
        })
    });

    // allows select2 search in the modal
    $.fn.modal.Constructor.prototype._enforceFocus = function() {};
});


$(document).ready(function(){   
    $('#checkAll').click(function(){     
            
    }); 
});