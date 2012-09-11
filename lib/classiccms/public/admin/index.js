$(document).ready(function() {
  $('#example').dataTable( {
    "bProcessing": true,
    "bServerSide": true,
    "sAjaxSource": "/admin/load",
    "fnServerParams": function ( aoData ) {
       model_name = $('input[name=model]').first().val();
       aoData.push( { "name": "model", "value": model_name} );
    }
  });
});