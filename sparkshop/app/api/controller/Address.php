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
namespace app\api\controller;

use app\admin\service\CityService;
use app\api\service\AddressService;

class Address extends Base
{
    /**
     * 添加地址
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $addressService = new AddressService();
            $res = $addressService->addUserAddress($param, $this->user['id']);
            return json($res);
        }
    }

    /**
     * 编辑地址
     */
    public function edit()
    {
        $param = input('post.');

        $addressService = new AddressService();
        $res = $addressService->editUserAddress($param, $this->user['id']);
        return json($res);
    }

    /**
     * 删除地址
     */
    public function del()
    {
        $id = input('param.id');

        $addressService = new AddressService();
        $res = $addressService->delUserAddress($id, $this->user['id']);
        return json($res);
    }

    /**
     * 设置默认地址
     */
    public function setDefault()
    {
        $id = input('param.id');

        $addressService = new AddressService();
        $res = $addressService->setDefault($id, $this->user['id']);
        return json($res);
    }

    /**
     * 获取默认的地址
     */
    public function getDefaultAddress()
    {
        $addressService = new AddressService();
        $res = $addressService->getDefaultAddress($this->user['id']);
        return json($res);
    }

    /**
     * 获取用户地址
     */
    public function getUserAddress()
    {
        $addressService = new AddressService();
        $res = $addressService->getUserAddressList($this->user['id']);
        return json($res);
    }

    /**
     * 省市区数据
     */
    public function area()
    {
        $cityService = new CityService();
        $res = $cityService->getAreaTree();
        return json($res);
    }
}