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
            url: "/api.bin/warehouse/?q="+keyword,
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
          { name: "code", type: "text", title: "Code" },
          { name: "name", type: "text", width: 200, title: "Warehouse Name" },
          { name: "country_code", type: "text", title: "County Code"},
          { name: "country", type: "text", title: "Country" },
          { type: "control" }
      ]
  });
});


