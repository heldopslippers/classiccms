$(document).ready(function() {
  $('#').dataTable( {
    "aoColumnDefs": [ 
      {
        "fnRender": function ( oObj, sVal ) {
          return sVal +' '+ oObj.aData[3];
        },
        "aTargets": [ 0 ]
      },
      { "bVisible": false,  "aTargets": [ 3 ] },
      { "sClass": "center", "aTargets": [ 4 ] }
    ]
  });
});