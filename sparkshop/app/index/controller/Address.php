<?php
// +----------------------------------------------------------------------
// | SparkShop 坚持做优秀的商城系统
// +----------------------------------------------------------------------
// | Copyright (c) 2022~2099 http://sparkshop.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( https://opensource.org/licenses/mit-license.php )
// +----------------------------------------------------------------------
// | Author: NickBai
// +----------------------------------------------------------------------
namespace app\index\controller;

use app\index\service\AddressService;
use app\model\user\UserAddress;
use think\facade\View;

class Address extends Base
{
    public function initialize()
    {
        parent::initialize();
        pcLoginCheck();
    }

    /**
     * 添加地址
     */
    public function add()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $addressService = new AddressService();
            $res = $addressService->addUserAddress($param, session('home_user_id'));
            return json($res);
        }

        $ip = request()->ip();
        $location = getLocationByIp($ip, 2);

        if ($location['province'] == "0") {
            $province = "北京市";
            $city = "北京市";
            $county = "东城区";
        } else {
            $province = $location['province'];
            $city = $location['city'];
            $county = "";
        }

        View::assign([
            'province' => $province,
            'city' => $city,
            'county' => $county
        ]);

        return View::fetch();
    }

    /**
     * 编辑地址
     */
    public function edit()
    {
        if (request()->isPost()) {

            $param = input('post.');

            $addressService = new AddressService();
            $res = $addressService->editUserAddress($param, session('home_user_id'));
            return json($res);
        }

        $userAddressModel = new UserAddress();
        View::assign([
            'info' => $userAddressModel->getInfoById(input('param.id'))['data']
        ]);

        return View::fetch();
    }

    /**
     * 删除地址
     */
    public function del()
    {
        if (request()->isAjax()) {

            $id = input('param.id');

            $addressService = new AddressService();
            $res = $addressService->delUserAddress($id, session('home_user_id'));
            return json($res);
        }
    }

    /**
     * 设置默认地址
     */
    public function setDefault()
    {
        if (request()->isAjax()) {

            $id = input('param.id');

            $addressService = new AddressService();
            $res = $addressService->setDefault($id, session('home_user_id'));
            return json($res);
        }
    }

    /**
     * 获取用户地址
     */
    public function getUserAddress()
    {
        if (request()->isAjax()) {

            $addressService = new AddressService();
            $res = $addressService->getUserAddressList(session('home_user_id'));
            return json($res);
        }
    }
}