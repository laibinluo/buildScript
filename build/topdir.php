<?php
    $branches = scandir(".");
?>
<!doctype html>
<html>
<head>
    <title>PPBOX 发布包管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body><center>
    <?php
        foreach ($branches as $b) {
            if ($b == "." || $b == "..") continue;
            if ($b == "index.php") continue;
            print '<p/>';
            print '<a href="' . $b. '">' . $b . '</a>';
        }
   ?>
</center></body>

