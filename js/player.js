function playVideo() {
    var url = document.getElementById("url").value;
    if (url.indexOf('http') == -1) {
        alert('视频地址不正确！');
        return;
    }
    var api = document.getElementById("sel").value;
    url = api + url;

    var player = document.getElementById("iframePlayer");
    player.setAttribute("src", url);
}