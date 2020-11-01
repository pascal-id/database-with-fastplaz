var keyword = '';//$('#q').val();

$(function () {

  $("#q").keypress(function(event){
    var key = (event.keyCode ? event.keyCode : event.which); 
    var ch=String.fromCharCode(key);
    if (13 == key){
      event.preventDefault();
      $('#btn-Search').click();
      //keyword = $('#q').val();
      //$("#client-grid").jsGrid('loadData');
      }
  });
  $('#btn-Search').click(function(event){
    event.preventDefault();
    keyword = $('#q').val();
    $("#client-grid").jsGrid('loadData');
  });


  $("#client-grid").jsGrid({
      height: "auto",
      width: "100%",

      sorting: true,
      paging: true,
      autoload: true,
      editing: false,

      controller: {
        loadData: function() {
          var d = $.Deferred();
          $.ajax({
            url: "/client_ajax/?q="+keyword,
            dataType: "json"
          }).done(function(response) {
            if (0 == response.code){
              d.resolve(response.data);
            }
          });
          return d.promise();
        }
      },

      fields: [
          { name: "name", type: "text" },
          { name: "description", type: "text", width: 200, title: "Description" },
          { name: "expired", type: "text", title: "Expired"},
          { name: "status_id", type: "checkbox", title: "Status" },
          { type: "control" }
      ]
  });
});
