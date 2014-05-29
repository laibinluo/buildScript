<?php
error_reporting(E_ALL);
require('CAS.php');

$_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];
//phpCAS::setDebug();
phpCAS::client(SAML_VERSION_1_1, 'sso-cas.pplive.cn', 8443, '/cas');
phpCAS::setNoCasServerValidation();
PHPCas::handleLogoutRequests(true, array());
phpCAS::forceAuthentication();

$user_email = phpCAS::getUser();
$user_name = substr($user_email, 0, strpos($user_email, "@"));

if (!PHPCas::isAuthenticated()) {
    header('Location:index.php');
}

if (isset($_REQUEST['logout'])) {
    phpCAS::logout();
    header('Location:index.php');
}
?>

<html>
<head>
<meta charset="utf-8">
    <style>
        .header ul li { display: inline}
        ul li  { list-style: none}
        table td:hover {opacity:1; background-color:#00BFFF}
        table {margin:10px;padding:10px;table-layout: fixed;width: 800px}
        table td {border:1px solid #000;overflow:hidden;width:100px}
    </style>
</head>
<body>
<script>

    function checkDel() {
        //location.href = '/?checkDel';
    }

    function uploadFile(addFile) {
		document.getElementById("addFile").style.display = 'block';
		document.getElementById("listFile").style.display = 'none';	
		document.getElementById("help").style.display = 'none';
    }

    function showLog(help, listFile) {
	  window.open("http://innrom.pptv.com/gerrit/gitweb?p=ppbox/pptv/apks.git;a=log;h=refs/heads/ppbox-amlogic-m8");
    }

    function showIndex() {
        location.href = './index.php';
    }
	
    function syncApks() {
	    //echo "syncApks";
	    $git_reset = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks reset";
	    $git_clean = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks clean -fd";
	    $git_checkout = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks checkout .";
	    $git_pull = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git  pull";

	    system($git_reset, $ret);
	    system($git_clean, $ret);
	    system($git_checkout, $ret);
	    system($git_pull, $ret);
	   // echo "syncApks end";
           // location.href = './index.php';
    }
   
    function onHelp() {
	document.getElementById("addFile").style.display = 'none';
	document.getElementById("listFile").style.display = 'none';     
	document.getElementById("help").style.display = 'block';       
    }

	function showDelete(delFile, display) {
		document.getElementById("listFile").style.display = 'block';
		document.getElementById("addFile").style.display = 'none';
        document.getElementById("help").style.display = 'none';
		var elements = document.getElementsByClassName(delFile);
        var elements = document.getElementsByClassName(delFile);
        for(var i = 0, length = elements.length; i < length; i++) {
            elements[i].style.display = display;
        }
    }

   var index=1;
   function   addfile(content){   
     	newline=document.all.files.insertRow(-1);
		index++;
        newline.insertCell().innerHTML='<input   type="file"   name="myfile[]" size="150"><input type="button" value="删除此行" onclick="del()"><input type="checkbox" name="package[]" value="'+index+'">.so存放路径特殊'; 
   }   
   function   del(){
	    index--;
  		document.all.files.deleteRow(window.event.srcElement.parentElement.parentElement.rowIndex);   
   }   
    
</script>
<?php
$config['dir'] = './apks/';
$my_path=dirname(__FILE__);
$work_path=$my_path . "/apks";

if (isset($_GET['checkDel'])) {
    $fileContent = file_get_contents('data.txt');
    echo $fileContent;
}

if (isset($_GET['path'])) {
    $tmp = explode('-', $_GET['path']);
    $dir = implode('/', $tmp);
    if (empty($dir)) {
        $dir = $config['dir'];
    }
} else {
    $dir = $config['dir'];
}

if (isset($_POST['delFiles'])) {

    $git_reset = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks reset";
    $git_clean = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks clean -fd";
    $git_checkout = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks checkout .";
    $git_pull = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree " .$work_path . " pull";

    system($git_reset, $ret);
    system($git_clean, $ret);
    system($git_checkout, $ret);
    system($git_pull, $ret);
    
    system("sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git config user.name " . $user_name);
    system("sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git config user.email " . $user_email);

    foreach ($_POST['delFiles'] as $file) {
		$del = "sudo -u jenkins /usr/bin/flock -x lock rm -f ./apks/" . $file;
		system($del, $del_ret);
 		$files = $files . $file . " ";

		$mk_file = str_replace(strrchr($file, "."),"",$file) . ".mk";
		$del = "sudo -u jenkins /usr/bin/flock -x lock rm -f ./apks/" . $mk_file;
		if(file_exists("./apks/" . $mk_file)){
		   system($del, $del_ret);
		   $files = $files . $mk_file . " ";
		}
		var_dump($files);
    }
    $del_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git rm " . $files;
    $cm_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git commit -m \"delete apks\"";
    $push_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks push origin apks:ppbox-amlogic-m8";

    system($del_cmd, $del_ret);
    system($cm_cmd, $cm_ret);
    //system($push_cmd, $push_ret);
    header("Location:index.php");
    exit;
}

if (isset($_POST['delRecycle'])) {
    foreach ($_POST['delRecycle'] as $file) {
        unlink($file);
    }
}

if ($_POST["submit"]) {
   
    $ob_path=$config['dir'];

    $typelist=array("apk", "mk", "log", "txt");
		   			   
    $up_info=$_FILES['myfile'];
	$up_index=$_POST['package'];
	$package="";
	
	
    $flag = TRUE;


    for($i = 0; $i < count($up_info['name']); $i++) {

	if($up_info['error'][$i] > 0){
	    switch($up_info['error'][$i]){
		case 1:
		    $err_info="上传的文件超过了 php.ini 中 upload_max_filesize 选项限制的值";
		    break;
		case 2:
		    $err_info="上传文件的大小超过了 HTML 表单中 MAX_FILE_SIZE 选项指定的值";
		    break;
		case 3:
		    $err_info="文件只有部分被上传";
		    break;
		case 4:
	            $err_info="没有文件被上传";
		    break;
		case 6:
		    $err_info="找不到临时文件夹";
		    break;
		case 7:
		    $err_info="文件写入失败";
		    break;
                default:
		    $err_info="未知的上传错误";
		    break;
	    }	   
	    $flag = FALSE;
            echo $err_info;
	    break;
	}
	
	

    $git_reset = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks reset";
	$git_clean = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks clean -fd";
	$git_checkout = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks checkout .";
	$git_pull = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree " .$work_path . " pull";

	system($git_reset, $ret);
	system($git_clean, $ret);
	system($git_checkout, $ret);
	system($git_pull, $ret);

	if(move_uploaded_file($up_info["tmp_name"][$i], $dir . $up_info['name'][$i])) {
		 $files =$files . $up_info['name'][$i] . " ";
	     echo "Stored success!";
        }
	else {
	     $flag = FALSE;
	     echo "Stored failure";
	     break;
        }
   }
   echo $files;
  if($flag) {
	  for($i = 0; $i < count($up_index); $i++){

		 $index=$up_index[$i]-1;
	//     echo count($up_index);
	//     echo "<br>";
	//	
	//	 echo $up_index[$i];
	//	 echo $index;
	//	 echo "<br>";
	//	 echo count($up_info['name']);
	//	 echo "<br>";
	//	 echo $up_info['name'][$index];
	//	 echo "<br>";

		 if($up_index[$i] <= count($up_info['name'])){
		     $apk="./apks/" . $up_info['name'][$index];
			 echo $apk;
			 echo "<br>";
			 $mk_file=system("sudo -u jenkins /usr/bin/flock -x lock ./apks.sh " . $apk, $ret);
	//		 echo "<br>";
	//		 echo "--------------------";
	//		 echo "<br>";
	//		 echo $mk_file;
	//		 echo "<br>";
			 $files=$files . $mk_file;
		 }
	  }
	  echo $files;  
		
	  system("sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git config user.name " . $user_name);
      system("sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git config user.email " . $user_email);

      $add_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks add " . $files;
      $cmd_comment = "update " . $files;
      $cm_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks commit -m \"update apks\"";
      $push_cmd = "sudo -u jenkins /usr/bin/flock -x lock git --git-dir ./apks/.git --work-tree ./apks push origin apks:ppbox-amlogic-m8";
  
      system($add_cmd, $add_ret);
      system($cm_cmd, $cm_ret);
      //system($push_cmd, $push_ret);
  }
  header("Location:index.php");
  exit; 
}

?>

<div class="header">
    <ul>
        <li><a>已登陆</a></li>
        <li><a href="./?logout">退出</a></li>
    </ul>
</div>

<div class="sidebar" style="border-right-style:solid; border-right-color:#B2B2B2;float:left; height:550px; margin-right: 20px;padding:10px">
    <ul>
	<li><a onclick="showIndex()" href="#">首页</a><li>
	<li><a onclick="showLog()" href="#">查看历史记录</a><li>
        <li><a onclick="uploadFile('addFile')" href="#">添加/替换</a></li>
        <li><a onclick="showDelete('delefile', 'block')" href="#">删除</a></li>
	<li><a onclick="onHelp()" href="#">帮助</a></li>
    </ul>
</div>

<div class="page" id="help" style="display:none"> 
    <?php
     echo  "注意事项：";
     echo  "<br/>";
     echo  "     1.  使用域名账号登陆， 在进行添加，删除操作, 文件名禁止出现中文，文件大小不能超过100M";
     echo  "<br>";
     echo  "     2.  如果提交的apk需要解压.so库，且要放到指定目录时，请在提交时选择复选框(.so存放路径特殊)";
	 echo  "<br>";
	 echo  "	 3.	 如果解压后的.so库没有特殊要求，请不要选择复选框(.so存放路径特殊)";
     echo  "<br>";
     echo  "     4.  上传或删除的文件会提交到本地git仓库，并push到远程服务器git仓库";
     echo  "<br>";
     echo  "<br>";
     echo  "如有问题请联系，e-mail: laibinluo@pptv.com";
    ?>
</div>
 
<div class='page' id='addFile' style='display:none'>
<form action="index.php" method="post" enctype="multipart/form-data">
   <input type="button" onclick="addfile()" value="添加文件">
   <table border="0" id = "files">
       <tr>
	   <td><input type="file" name="myfile[]" size="250"><input type="checkbox" name="package[]" value="1">.so存放路径特殊</td>
       </tr>
   </table>

   <input type="submit" name="submit" value="提交">
</form>
</div>

<div class="container"id="listFile"  style="margin-left: 100px;" >
<form action="index.php" method="post">

<button style="display:none" class="delefile">确定</button>

<?php
function listFolderFiles($dir){
	
    $ffs = scandir($dir);
    echo '<table style="margin:10px;padding:10px">';
    $col = 0;
    $colMax = 3;
    foreach($ffs as $ff){
        if ($col == 0) {
            echo "<tr>";
        }

        if($ff != '.' && $ff != '..'){
   	    if(($ff == '.git') || (substr(strrev($ff), 0, strpos(strrev($ff), ".")) == 'km') ) {
		continue;
	    }
            if(is_dir($dir . '/' .$ff)) {	
                if ($dir != '.') {
                    $param = $dir;
                    $tmp1 = explode('/', $dir);
                    $param = implode('-', $tmp1) . '-' . $ff;
                } else {
                    $param = $ff;
                }
                echo '<td style="width:100px"><a href="./?path=' .$param . '" ><figure><img src="folder.jpg" width="50px"/><figcaption>'.$ff .'</figcaption></figure></td>';
                $col++;
            }
            else {
                 echo '<td style="width:100px"><input style="display:none" class="delefile" type="checkbox" name="delFiles[]" value="'.$ff .'" /><figure><img src="file.jpg" width="50px"><figcaption>'.$ff .'</figcaption></figure></td>';
                 $col++;
            }
        }

        if ($col == $colMax) {
            echo "</tr>";
            $col = 0;
        }
    }
    echo '</table>';
}

(isset($dir)?$dir: $dir='.');
listFolderFiles($dir);
?>

</form>
</div>
</body>
</html>

