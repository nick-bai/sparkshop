# think-log-viewer
thinkphp6 log日志的视图扩展包

### 页面展示
![image](https://s3.bmp.ovh/imgs/2022/06/26/3385b1106dbd178f.png)

### 1.配置路由
~~~
Route::get('log_view', "\Shiroi\ThinkLogViewer\LogServer@index");
~~~



### 2.运行thinkphp服务
~~~ 
php think run
~~~



### 3.访问浏览器 `http://127.0.0.1:8000/log_view`即可