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
              //i = 0;
              //response.response.data.forEach(element => {
              //  response.response.data[i].row_index = i+1;
              //  i++;
              //});
              //d.resolve(response.response.data);
              d.resolve($.map(response.response.data, function (item, itemIndex) {
                return $.extend(item, { "row_index": itemIndex + 1 });
              }));
            }
          });
          return d.promise();
        }
      },

      fields: [
        { name: "row_index", title: "", width: 20},
        { name: "code", type: "text", title: "Code" },
        { name: "name", type: "text", width: 200, title: "Warehouse Name" },
        { name: "country_code", type: "text", title: "County Code"},
        { name: "country", type: "text", title: "Country" },
        { type: "control" }
      ]
  });
});


