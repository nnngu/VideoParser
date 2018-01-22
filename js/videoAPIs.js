window.onload = function () {
    var data = [
        {name: "通用解析1", url: "https://api.47ks.com/webcloud/?v="},
        {name: "通用解析2", url: "http://api.mp4la.net/?url="},
        {name: "通用解析3", url: "http://v.72du.com/api/?url="},
        {name: "通用解析4", url: "http://api.47ks.com/webcloud/?v="},
        {name: "通用解析5", url: "http://jx.71ki.com/index.php?url="},
        {name: "通用解析6", url: "http://000o.cc/jx/ty.php?url="},
        {name: "通用解析7", url: "http://www.yydy8.com/Common/?url="},
        {name: "通用解析8", url: "http://yun.mt2t.com/yun?url="},
        {name: "通用解析9", url: "http://api.mp4la.net/?url="},
        {name: "通用解析10", url: "http://yyygwz.com/index.php?url="},
        {name: "通用解析11", url: "http://v.72du.com/api/?url="},
        {name: "通用解析12", url: "http://api.47ks.com/webcloud/?v="},
        {name: "通用解析13", url: "http://jx.71ki.com/index.php?url="},
        {name: "通用解析14", url: "http://www.97zxkan.com/jiexi/97zxkanapi.php?url="},
        {name: "通用解析15", url: "http://www.wmxz.wang/video.php?url="},
        {name: "通用解析16", url: "http://www.bbshanxiucao.top/video.php?url="},
        {name: "通用解析17", url: "http://www.xiguaso.com/api/index.php?url="},
        {name: "通用解析18", url: "http://www.kppev.cn/jiexi/5/1/1.php?url="},
        {name: "通用解析19", url: "http://api.mp4la.net/?url="},
        {name: "通用解析20", url: "http://v.72du.com/api/?url="},
        {name: "通用解析21", url: "http://api.47ks.com/webcloud/?v="},
        {name: "通用解析22", url: "http://jx.71ki.com/index.php?url="},
        {name: "通用解析23", url: "http://000o.cc/jx/ty.php?url="},
        {name: "通用解析24", url: "http://5qiyi.sdyhy.cn/5qiyi/5qiyi2.php?url="},
        {name: "通用解析25", url: "http://vip.sdyhy.cn/ckflv/?url="},
        {name: "通用解析26", url: "http://player.gakui.top/?url="},
        {name: "通用解析27", url: "http://qtzr.net/s/?qt="},
        {name: "乐视解析", url: "http://apn.zhibo99.cn/mdparse/letv.php?id="},
        {name: "优酷云解析1", url: "http://api.baiyug.cn/vip/index.php?url="},
        {name: "优酷云解析2", url: "http://977345961.kezi.wang/ykyun/c.php?vid="},
    ];
    for (var i in  data) {
        var opt = document.createElement("option");
        opt.value = data[i].url;
        opt.innerText = data[i].name;
        document.getElementById('sel').appendChild(opt);
    }
}


function play() {
    var url = document.getElementById("url").value;
    if (url.indexOf('http') == -1) {
        alert('视频地址不正确！');
        return;
    }
    var api = document.getElementById("sel").value;
    var open = document.getElementById("open").value;
    url = api + url;
    switch (open) {
        case '0':
            window.open(url);
            console.log(0);
            break;
        case '1':
            window.location = url;
            console.log(1);
            break;
    }
}

