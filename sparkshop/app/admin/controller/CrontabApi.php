<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai  <876337011@qq.com>
// +----------------------------------------------------------------------

namespace app\admin\controller;

use think\facade\View;

class CrontabApi extends Base
{
    protected $host = 'http://127.0.0.1:2345';

    /**
     * 获取列表
     */
    public function index()
    {
        if (request()->isAjax()) {
            $param = input('param.');

            $res = curlGet($this->host . '/crontab/index', $param);
            if (!empty($res['data']['list'])) {
                foreach ($res['data']['list'] as $key => $vo) {
                    $res['data']['list'][$key]['create_time'] = date('Y-m-d H:i:s', $vo['create_time']);
                }
            }

            return json($res);
        }

        return View::fetch();
    }

    /**
     * 创建任务
     */
    public function add()
    {
        $param = input('post.');
        $param['frequency'] = $this->getTimerStr($param['frequency']);
        $param['remark'] = '';

        $res = curlPost($this->host . '/crontab/add', $param);
        return json($res);
    }

    /**
     * 编辑任务
     */
    public function edit()
    {
        $param = input('post.');

        $res = curlPost($this->host . '/crontab/modify', $param);
        return json($res);
    }

    /**
     * 删除任务
     */
    public function del()
    {
        $param = input('post.');

        $res = curlPost($this->host . '/crontab/delete', $param);
        return json($res);
    }

    /**
     * 重启服务
     */
    public function reload()
    {
        $param = input('post.');

        $res = curlPost($this->host . '/crontab/reload', $param);
        return json($res);
    }

    /**
     * 执行日志
     */
    public function flow()
    {
        $param = input('param.');

        $res = curlGet($this->host . '/crontab/flow', $param);
        if (!empty($res['data']['list'])) {
            foreach ($res['data']['list'] as $key => $vo) {
                $res['data']['list'][$key]['create_time'] = date('Y-m-d H:i:s', $vo['create_time']);
            }
        }

        return json($res);
    }

    public function getTimerStr($data): string
    {
        $timeStr = '';
        switch ($data['type']) {
            case 1:
                $timeStr = '*/' . $data['second'] . ' * * * * *';
                break;
            case 2:
                $timeStr = '0 */' . $data['minute'] . ' * * * *';
                break;
            case 3:
                $timeStr = '0 0 */' . $data['hour'] . ' * * *';
                break;
            case 4:
                $timeStr = '0 0 0 */' . $data['day'] . ' * *';
                break;
            case 5:
                $timeStr = $data['second'] . ' ' . $data['minute'] . ' ' . $data['hour'] . ' * * *';
                break;
            case 6:
                $timeStr = $data['second'] . ' ' . $data['minute'] . ' ' . $data['hour'] . ' * * ' . ($data['week'] == 7 ? 0 : $data['week']);
                break;
            case 7:
                $timeStr = $data['second'] . ' ' . $data['minute'] . ' ' . $data['hour'] . ' ' . $data['day'] . ' * *';
                break;
        }
        return $timeStr;
    }
}