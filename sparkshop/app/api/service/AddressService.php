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
namespace app\api\service;

use app\api\validate\AddressValidate;
use app\model\user\UserAddress;
use think\exception\ValidateException;

class AddressService
{
    /**
     * 获取默认地址
     * @param $userId
     * @return array
     */
    public function getDefaultAddress($userId)
    {
        $userAddressModel = new UserAddress();
        $addressInfo = $userAddressModel->findOne([
            'user_id' => $userId,
            'is_del' => 1,
            'is_default' => 1
        ])['data'];

        return dataReturn(0, 'success', $addressInfo);
    }

    /**
     * 获取用户的地址
     * @param $userId
     * @return array
     */
    public function getUserAddressList($userId)
    {
        $userAddressModel = new UserAddress();
        $addressList = $userAddressModel->getAllList([
            'user_id' => $userId,
            'is_del' => 1
        ], '*', 'is_default asc, id desc')['data'];

        return dataReturn(0, 'success', $addressList);
    }

    /**
     * 添加用户地址
     * @param $param
     * @param $userId
     * @return array
     */
    public function addUserAddress($param, $userId)
    {
        try {
            validate(AddressValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(0, $e->getError());
        }

        $param['create_time'] = now();
        $param['user_id'] = $userId;

        $userAddressModel = new UserAddress();
        if ($param['is_default'] == 1) {
            $userAddressModel->updateByWehere([
                'is_default' => 2
            ], ['user_id' => $param['user_id']]);
        }

        return $userAddressModel->insertOne($param);
    }

    /**
     * 编辑用户地址
     * @param $param
     * @param $userId
     * @return array
     */
    public function editUserAddress($param, $userId)
    {
        try {
            validate(AddressValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(0, $e->getError());
        }

        $param['update_time'] = now();
        $param['user_id'] = $userId;

        $userAddressModel = new UserAddress();
        if ($param['is_default'] == 1) {
            $userAddressModel->updateByWehere([
                'is_default' => 2
            ], ['user_id' => $param['user_id']]);
        }

        return $userAddressModel->updateByWehere($param, [
            'id' => $param['id'],
            'user_id' => $userId
        ]);
    }

    /**
     * 删除用户地址
     * @param $id
     * @param $userId
     * @return array
     */
    public function delUserAddress($id, $userId)
    {
        $userAddressModel = new UserAddress();
        return $userAddressModel->delByWhere([
            'id' => $id,
            'user_id' => $userId
        ]);
    }

    /**
     * 设置默认地址
     * @param $id
     * @param $userId
     * @return array
     */
    public function setDefault($id, $userId)
    {
        $userAddressModel = new UserAddress();
        $userAddressModel->updateByWehere(['is_default' => 2], [
            'user_id' => $userId
        ]);

        $userAddressModel->updateByWehere(['is_default' => 1], [
            'user_id' => $userId,
            'id' => $id
        ]);

        return dataReturn(0);
    }
}