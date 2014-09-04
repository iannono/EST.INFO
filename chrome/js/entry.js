var xmlHttp;
var content = document.getElementById('content');
var sourceurl = "http://estao.info"

function get_entries(){
  xmlHttp = new XMLHttpRequest();
  url = sourceurl + "/entries.json";
  xmlHttp.open("GET",url,true);
  xmlHttp.onreadystatechange = getSuccess;
  xmlHttp.send();
}

function getSuccess(){
  if(xmlHttp.readyState == 4) {
    if(xmlHttp.status == 200) {
      var response = xmlHttp.responseText;
      if (response != null || response.length > 0){
        var responseJson = response.parseJSON();
      }
      var divresult = document.getElementById("result");
      if (responseJson) {
        html = "<table>";
        for(var i=0; i<responseJson.length; i++) {
          var item = responseJson[i];
          if (item.img) {
            html = html + "<tr><td><img src='"+sourceurl+item.img+"' width='64' height='48'></td>";
          } else {
            html = html + "<tr><td><img src='images/no_image.jpg' width='64' height='48'></td>";
          }
          html = html + "<td><div class='detail'><a href='"+item.product+"' target='_blank'><h3>"+item.name+"</h3></a><p>"+item.source+"</p></div></td>";
          if (item.price) {
            html = html + "<td><h3 class='price'>"+item.price+"</h3></td></tr>";
          }else{
            html = html + "<td><h3 class='noprice'>No Price</h3></td></tr>";
          }
        }
        html = html + "</table>";
        content.innerHTML = html;
      }
    }
  }
}

get_entries();
