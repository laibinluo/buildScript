<?php
    $cwd = getcwd();
    $dir = basename($cwd);

    if (isset($_REQUEST['pub'])) {
        $pub=$_REQUEST['pub'];
        //$pub_cmd = "sudo -u jenkins /usr/bin/flock -x lock /home/jenkins/workspace/scripts/build/ppbox/amlogic/pub.sh " . $pub . " > pub.log 2>&1";
        $pub_cmd = "sudo -u jenkins /usr/bin/flock -x lock /home/jenkins/workspace/scripts/build/ppbox/amlogic/pub.sh " . $pub;
        system($pub_cmd, $pub_ret); 
    }

    if (isset($_REQUEST['del'])) {
        $del=$_REQUEST['del'];
        $del_cmd = "sudo -u jenkins /usr/bin/flock -x lock rm -rf " . $cwd . "/all/" . $del . " > del.log 2>&1";
        system($del_cmd, $del_ret); 
    }

    if (file_exists("major")) {
      $major = basename(readlink("major"));
      $minor = basename(readlink("minor"));
      $major2 = basename(readlink("pub/" . $major));
      $minor2 = basename(readlink("pub/" . $minor));
    } else {
      $major = "0";
      $minor = "0";
      $major2 = "0";
      $minor2 = "0";
    }

    if (file_exists("last")) {
      $last = basename(readlink("last"));
    } else {
      $last = "0";
    }

    $versions = scandir("pub");

    function file_time($f, $sym = false)
    {
        if ($sym)
           $stat = lstat($f);
        else
           $stat = stat($f);
        return date("Y-m-d H:i:s", $stat['mtime']);
    }
?>
<!doctype html>
<html>
<style type="text/css">
body {background-color: #ffffff; color: #000000;}
body, td, th, h1, h2 {font-family: sans-serif;}
pre {margin: 0px; font-family: monospace;}
a:link {color: #000099; text-decoration: none; background-color: #ffffff;}
a:hover {text-decoration: underline;}
table {border-collapse: collapse;}
.center {text-align: center;}
.center table { margin-left: auto; margin-right: auto; text-align: left;}
.center th { text-align: center !important; }
td, th { border: 1px solid #000000; font-size: 75%; vertical-align: baseline;}
h1 {font-size: 150%;}
h2 {font-size: 125%;}
.p {text-align: left;}
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.h {background-color: #9999cc; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
.vr {background-color: #cccccc; text-align: right; color: #000000;}
img {float: right; border: 0px;}
hr {width: 600px; background-color: #cccccc; border: 0px; height: 1px; color: #000000;}
</style>
<head>
    <title>PPBOX 发布包管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript">
        function view(dir)
        {
            window.open(dir);
        }
        function pub(num)
        {
            window.open("index.php?pub=" + num, "_top");
        }
        function del(num)
        {
            window.open("index.php?del=" + num, "_top");
        }
        function chk(box)
        {
            tr = box.parentNode.parentNode.nextSibling;
            tr.style.display = box.checked ? "" : "none";
        }
    </script>
</head>
<body><center>
    <h3>PPBOX 发布包管理(<?=$dir?>)</h3>
    <h3><a href="..">上级目录<a></h3>
    <?php
        if (isset($_REQUEST['pub'])) {
            print $pub_ret ? "<p>发布失败，请联系管理员</p>" : "<p>发布成功</p>";
        }
        if (isset($_REQUEST['del'])) {
            print $del_ret ? "<p>删除失败，请联系管理员</p>" : "<p>删除成功</p>";
        }
    ?>
    <h2>最近构建版本</h2>
    <table border="0" cellpadding="4" width="600">
        <tr>
            <td class="e">构建号</td>
            <td class="e">构建时间</td>
            <td class="e">操作</td>
        </tr>
        <?php
            for ($i = $minor2 + 1; $i <= $last; $i++) {
                $dir = "all/" . $i;
                if (!file_exists($dir)) continue;
                $diff_file = $dir . "/diff.txt";
                $diff = file_get_contents($diff_file);
                print '<tr>';
                print   '<td class="v">' . $i . '</td>';
                print   '<td class="v">' . file_time($dir) . '</td>';
                print   '<td>';
                print     '<button onclick="view(\'all/' . $i . '\')">查看</button>';
                print     '<button onclick="pub(\'' . $i . '\')">发布</button>';
                print     '<button onclick="del(\'' . $i . '\')">删除</button>';
                print     '<input type="checkbox" onclick="chk(this)">修改记录</input>';
                print   '</td>';
                print '</tr>';
                print '<tr style="display:none;">';
                print   '<td colspan="3">' . str_replace("\n", "<br>", $diff) . '</td>';
                print '</tr>';
            } 
        ?>
    </table>
    </form>
    <h2>最新发布版本</h2>
    <table border="0" cellpadding="4" width="600">
        <tr>
            <td class="e">最新发布主版本</td>
            <td class="v"><?=$major?> (<?=$major2?>)</td>
            <td><button onclick="view('pub/<?=$major?>')">查看</button></td>
        </tr>
        <tr>
            <td class="e">最新发布次版本</td>
            <td class="v"><?=$minor?> (<?=$minor2?>)</td>
            <td><button onclick="view('pub/<?=$minor?>')">查看</button></td>
        </tr>
    </table>
    <h3>所有发布版本</h3>
    <table border="0" cellpadding="4" width="600">
        <tr>
            <td class="e">发布版本</td>
            <td class="e">构建号</td>
            <td class="e">发布时间</td>
            <td class="e">构建时间</td>
            <td class="e">操作</td>
        </tr>
        <?php
            foreach ($versions as $ver) {
                if ($ver == "." || $ver == "..") continue;
                $ver2 = basename(readlink("pub/" . $ver));
                print '<tr>';
                print '<td class="v">' . $ver . '</td>';
                print '<td class="v">' . $ver2 . '</td>';
                print '<td class="v">' . file_time("pub/" . $ver, 1) . '</td>';
                print '<td class="v">' . file_time("all/" . $ver2) . '</td>';
                print '<td><button onclick="view(\'pub/' . $minor . '\')">查看</button></td>';
                print '</tr>';
            } 
        ?>
    </table>
</center></body>

