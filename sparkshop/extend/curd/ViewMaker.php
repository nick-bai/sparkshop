<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2011~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------

namespace curd;

use think\facade\App;
use think\helper\Str;

class ViewMaker
{
    public static function getTpl($flag)
    {
        $path = App::getRootPath() . 'extend' . DS . 'curd' . DS . 'tpl' . DS . $flag . '.tpl';
        if (!file_exists($path)) {
            return dataReturn(-1, '模板不存在');
        }

        $content = file_get_contents($path);
        return dataReturn(0, 'success', $content);
    }

    public static function makeIndex($param)
    {
        $indexTplContent = self::getTpl('index')['data'];

        $tableDataArr = $param['show_fields'];

        $tableHeader = '';
        $tableData = '';
        foreach ($tableDataArr as $vo) {
            if (isset($param['fields'][$vo])) {
                $tableHeader .= '<th>' . $param['fields'][$vo] . '</th>' . PHP_EOL . str_repeat(' ', 32);
                $tableData .= '<td>{{ item.' . $vo . ' }}</td>' . PHP_EOL . str_repeat(' ', 8);
            }
        }

        $title = $param['method_name'];
        $addUrl = '{:myUrl("' . $param['name'] . '/add")}';
        $listUrl = '{:myUrl("' . $param['name'] . '/index")}';
        $editUrl = '{:substr(myUrl("' . $param['name'] . '/edit"), 0, -5)}';
        $delUrl = '{:myUrl("' . $param['name'] . '/del")}';

        $replacedContent = str_replace([
            '<<title>>',
            '<<tableHeader>>',
            '<<tableData>>',
            '<<addUrl>>',
            '<<listUrl>>',
            '<<editUrl>>',
            '<<delUrl>>'
        ], [
            $title,
            $tableHeader,
            $tableData,
            $addUrl,
            $listUrl,
            $editUrl,
            $delUrl,

        ], $indexTplContent);

        $dir = App::getAppPath() . config('view.view_dir_name') . DS . Str::snake(lcfirst($param['name']));
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }
        $indexViewPath = $dir . DS . 'index.html';
        file_put_contents($indexViewPath, $replacedContent);
    }

    public static function makeAdd($param)
    {
        $addTplContent = self::getTpl('add')['data'];

        $addUrl = '{:myUrl("' . $param['name'] . '/add")}';

        $item = <<<EOL
<div class="layui-form-item">
    <label class="layui-form-label" style="width: 100px"><em style="color:#FF5722">*</em> <name></label>
    <div class="layui-input-block">
        <input type="text" name="<filed>" required  lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
    </div>
</div>
EOL;
        $formField = '';
        foreach ($param['show_form'] as $vo) {

            $formItem = str_replace([
                '<name>',
                '<filed>'
            ], [
                $param['form'][$vo],
                $vo
            ], $item);

            $formField .= $formItem . PHP_EOL;
        }

        $replacedContent = str_replace([
            '<<formField>>',
            '<<addUrl>>'
        ], [
            $formField,
            $addUrl
        ], $addTplContent);

        $dir = App::getAppPath() . config('view.view_dir_name') . DS . Str::snake(lcfirst($param['name']));
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }
        $indexViewPath = $dir . DS . 'add.html';
        file_put_contents($indexViewPath, $replacedContent);
    }

    public static function makeEdit($param)
    {
        $addTplContent = self::getTpl('edit')['data'];

        $editUrl = '{:myUrl("' . $param['name'] . '/edit")}';

        $item = <<<EOL
<div class="layui-form-item">
    <label class="layui-form-label" style="width: 100px"><em style="color:#FF5722">*</em> <name></label>
    <div class="layui-input-block">
        <input type="text" name="<filed>" required  lay-verify="required" autocomplete="off" placeholder="" class="layui-input" value="{\$info['<filed>']}">
    </div>
</div>
EOL;
        $formField = '';
        foreach ($param['show_form'] as $vo) {

            $formItem = str_replace([
                '<name>',
                '<filed>'
            ], [
                $param['form'][$vo],
                $vo
            ], $item);

            $formField .= $formItem . PHP_EOL;
        }

        $replacedContent = str_replace([
            '<<formField>>',
            '<<editUrl>>'
        ], [
            $formField,
            $editUrl
        ], $addTplContent);

        $dir = App::getAppPath() . config('view.view_dir_name') . DS . Str::snake(lcfirst($param['name']));
        if (!is_dir($dir)) {
            mkdir($dir, 0755, true);
        }
        $indexViewPath = $dir . DS . 'edit.html';
        file_put_contents($indexViewPath, $replacedContent);
    }
}