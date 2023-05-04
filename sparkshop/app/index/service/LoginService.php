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

namespace app\index\service;

use app\index\validate\LoginValidate;
use app\model\user\User;
use think\exception\ValidateException;

class LoginService
{
    /**
     * 处理登陆
     * @param $param
     * @return array
     */
    public function doLogin($param)
    {
        try {
            validate(LoginValidate::class)->scene('login_' . $param['loginType'])->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        try {

            $userModel = new User();
            if ($param['loginType'] == 1) {

                $userInfo = $userModel->where('phone', $param['phone'])->find();
                if (empty($userInfo)) {
                    return dataReturn(-2, "用户名密码错误");
                }

                if (makePassword($param['password']) != $userInfo['password']) {
                    return dataReturn(-3, "用户名密码错误");
                }

                session('home_user_id', $userInfo['id']);
                session('home_user_name', $userInfo['nickname']);
                session('home_user_avatar', $userInfo['avatar']);
                $userModel->updateById([
                    'last_visit_time' => now()
                ], $userInfo['id']);
            } else if ($param['loginType'] == 2) {

                // 检测验证码
                $code = cache($param['phone'] . '_' . $param['type']);
                if ($param['code'] != $code) {
                    return dataReturn(-3, "验证码错误");
                }
                cache($param['phone'] . '_' . $param['type'], null);

                $userInfo = $userModel->where('phone', $param['phone'])->find();
                if (empty($userInfo)) {
                    return dataReturn(-4, "该用户尚未注册");
                }

                session('home_user_id', $userInfo['id']);
                session('home_user_name', $userInfo['nickname']);
                session('home_user_avatar', $userInfo['avatar']);
                $userModel->updateById([
                    'last_visit_time' => now()
                ], $userInfo['id']);
            }

            return dataReturn(0, "登陆成功");

        } catch (\Exception $e) {

            return dataReturn(-5, $e->getMessage());
        }
    }

    /**
     * 处理注册
     * @param $param
     * @return array
     */
    public function doReg($param)
    {
        try {
            validate(LoginValidate::class)->scene('reg')->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        try {

            // 检测验证码
            $code = cache($param['phone'] . '_' . $param['type']);
            if ($param['code'] != $code) {
                return dataReturn(-3, "验证码错误");
            }
            cache($param['phone'] . '_' . $param['type'], null);

            $userModel = new User();
            $has = $userModel->field('id')->where('phone', $param['phone'])->find();
            if (!empty($has)) {
                return dataReturn(-2, "该用手机号已经注册，请直接登录。");
            }

            $regParam = [
                'code' => uniqid(),
                'source_id' => 3,
                'nickname' => $param['phone'],
                'phone' => $param['phone'],
                'avatar' => '/default/static/image/default.jpg',
                'password' => makePassword($param['password']),
                'register_time' => now(),
                'create_time' => now()
            ];

            $res = $userModel->insertOne($regParam);
            if ($res['code'] == 0) {
                $res['msg'] = '注册成功';
            }

            return $res;
        } catch (\Exception $e) {

            return dataReturn(-5, $e->getMessage());
        }
    }

    /**
     * 忘记密码
     * @param $param
     * @return array
     */
    public function forgetPassword($param)
    {
        try {
            validate(LoginValidate::class)->check($param);
        } catch (ValidateException $e) {
            return dataReturn(-1, $e->getError());
        }

        try {

            // 检测验证码
            $code = cache($param['phone'] . '_' . $param['type']);
            if ($param['code'] != $code) {
                return dataReturn(-3, "验证码错误");
            }
            cache($param['phone'] . '_' . $param['type'], null);

            $userModel = new User();
            $has = $userModel->field('id')->where('phone', $param['phone'])->find();
            if (empty($has)) {
                return dataReturn(-2, "该用手机号未注册");
            }

            $updateParam = [
                'password' => makePassword($param['password']),
                'update_time' => now()
            ];

            $res = $userModel->updateById($updateParam, $has['id']);
            if ($res['code'] == 0) {
                $res['msg'] = '重置成功';
            }

            return $res;
        } catch (\Exception $e) {

            return dataReturn(-5, $e->getMessage());
        }
    }
}