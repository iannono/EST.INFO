var xmlHttp;
var content = document.getElementById('content');
var sourceurl = "http://162.243.236.79"

//function my_entries(el){
  //var today=new Date();
  //var h=today.getHours();
  //var m=today.getMinutes();
  //var s=today.getSeconds();
  //m=m>=10?m:('0'+m);
  //s=s>=10?s:('0'+s);
  //el.innerHTML = "<h1>"+ h+":"+m+":"+s + "</h1>";
  //setTimeout(function(){my_entries(el)}, 1000);
//}

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
          html = html + "<td><h3 class='price'>"+(item.price || "No Price")+"</h3></td></tr>";
        }
        html = html + "</table>";
        content.innerHTML = html;
      }
    }
  }
}

//my_entries(content);
get_entries();
