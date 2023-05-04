<!DOCTYPE html>
<html>

<head>
    <title>log</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <style>
        <?php echo include_once __DIR__."/css/bootstrap.min.css"?>
        <?php echo include_once __DIR__."/css/style.css"?>
    </style>
</head>

<body>
<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
    <div class="navbar-brand-wrapper d-flex justify-content-center">
        <div class="navbar-brand-inner-wrapper d-flex justify-content-between align-items-center w-100">
            <a class="navbar-brand brand-logo" href="#">
                <div style="color:#999;font-size:36px;font-weight:bold;position:fixed;display:block;">log view</div>
            </a>
        </div>
    </div>
    <div class="navbar-menu-wrapper d-flex align-items-center justify-content-end">
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Search now">
        </div>
    </div>
</nav>
<div class="container-fluid page-body-wrapper">
    <nav class="sidebar sidebar-offcanvas">
        <ul class="nav">
            <?php  foreach ($this->all_log as $path => $files) { ?>
                <li class="nav-item active">
                    <a class="nav-link" href="#">
                        <span class="menu-title"><?=$path?></span>
                    </a>
                </li>
                <?php  foreach ($files as $file) {  ?>
                    <li class="nav-item active" style="padding-left: 30px;">
                        <a class="nav-link change" style="<?php if (($this->param['file']??'') == ($path.'/'.$file)) {echo 'background-color:#ffc100;';} ?>" href="?file=<?=$path.'/'.$file?>">
                            <span class="menu-title"><?=$file?></span>
                        </a>
                    </li>
                <?php }?>
            <?php }?>
        </ul>
    </nav>
    <div class="main-panel">
        <div class="content-wrapper">
            <div class="row">
                <div class="col-md-12 stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <p class="card-title">Recent Purchases</p>
                            <div class="table-responsive">
                                <div class="dataTables_wrapper container-fluid dt-bootstrap4 no-footer">
                                    <table class="table dataTable no-footer">
                                        <thead>
                                        <tr>
                                            <th class="sorting_asc">level</th>
                                            <th class="sorting">content</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <?php  foreach ($this->splice_content_arr as $v) {  ?>
                                            <tr class="<?php
                                            switch ($v['level']) {
                                                case "error":
                                                    echo 'danger';break;
                                                case "warning":
                                                    echo 'warning';break;
                                                case "sql":
                                                case "info":
                                                    echo 'info';break;
                                                case "debug":
                                                    echo 'success';break;
                                                default:
                                                    echo 'default';break;
                                            }
                                            ?>">
                                                <td><?=$v['level']?></td>
                                                <td><?=$v['content']?></td>
                                            </tr>
                                        <?php }?>
                                        </tbody>
                                    </table>
                                </div>
                                <ul class="pagination">
                                    <li>
                                        <a href="?<?php $this->param['page'] = 1;
                                        echo http_build_query($this->param); ?>">&laquo;</a>
                                    </li>
                                    <li>
                                        <a href="?<?php $this->param['page'] = isset($_GET['page'])?(($_GET['page']==1) ? 1: $_GET['page']-1):1;
                                        echo http_build_query($this->param); ?>"><</a>
                                    </li>
                                    <?php for ($i = ($_GET['page']??1); $i <= $this->totalPage; $i++) { ?>
                                        <?php if($i < ((isset($_GET['page'])?$_GET['page']:1) + 5) || $i > ($this->totalPage - 4)) { ?>
                                            <li><a href="?<?php $this->param['page'] = $i;echo http_build_query($this->param); ?>"><?=$i?></a></li>
                                        <?php } ?>
                                    <?php } ?>
                                    <li>
                                        <a href="?<?php $this->param['page'] = isset($_GET['page'])? (($_GET['page']==$this->totalPage)? $this->totalPage: $_GET['page']+1): $this->totalPage;
                                        echo http_build_query($this->param); ?>">></a>
                                    </li>
                                    <li>
                                        <a href="?<?php $this->param['page'] = $this->totalPage;
                                        echo http_build_query($this->param); ?>">&raquo;</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>