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
namespace strategy\express\impl;

use app\model\order\OrderExpress;
use strategy\express\ExpressInterface;

class AliyunImpl implements ExpressInterface
{
    /**
     * 物流查询
     *  status 0:正常查询 201:快递单号错误 203:快递公司不存在 204:快递公司识别失败 205:没有信息 207:该单号被限制，错误单号
     * deliverystatus: 0：快递收件(揽件)1.在途中 2.正在派件 3.已签收 4.派送失败 5.疑难件 6.退件签收
     * @param $param
     */
    public function search($param)
    {
        $host = "https://wuliu.market.alicloudapi.com"; // api访问链接
        $path = "/kdi"; // API访问后缀
        $method = "GET";
        $config = getConfByType('express');
        $appcode = $config['app_code']; // 开通服务后 买家中心-查看AppCode
        $headers = [];
        array_push($headers, "Authorization:APPCODE " . $appcode);
        $querys = http_build_query($param);  // 参数写在这里
        $bodys = "";
        $url = $host . $path . "?" . $querys;

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_CUSTOMREQUEST, $method);
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($curl, CURLOPT_FAILONERROR, false);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, true);
        if (1 == strpos("$" . $host, "https://")) {
            curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        }
        $out_put = curl_exec($curl);

        $httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);

        list($header, $body) = explode("\r\n\r\n", $out_put, 2);
        if ($httpCode == 200) {

            $isEnd = false;
            $res = json_decode($body, true);
            if ($res['status'] == 0 && isset($res['result']['deliverystatus'])) {
                if ($res['result']['deliverystatus'] >= 3) {
                    $isEnd = true;
                }
            }

            // 更新物流
            $orderExpressModel = new OrderExpress();
            $orderExpressModel->updateById([
                'order_id' => $param['order_id'],
                'end_flag' => $isEnd ? 1 : 2,
                'express' => $body,
                'update_time' => now()
            ], $param['id']);

            return dataReturn(0, '查询成功', $body);
        } else {
            if ($httpCode == 400 && strpos($header, "Invalid Param Location") !== false) {
                return dataReturn(-1, '参数错误');
            } elseif ($httpCode == 400 && strpos($header, "Invalid AppCode") !== false) {
                return dataReturn(-2, 'AppCode错误');
            } elseif ($httpCode == 400 && strpos($header, "Invalid Url") !== false) {
                return dataReturn(-3, '请求的 Method、Path 或者环境错误');
            } elseif ($httpCode == 403 && strpos($header, "Unauthorized") !== false) {
                return dataReturn(-4, '服务未被授权（或URL和Path不正确）');
            } elseif ($httpCode == 403 && strpos($header, "Quota Exhausted") !== false) {
                return dataReturn(-5, '套餐包次数用完');
            } elseif ($httpCode == 403 && strpos($header, "Api Market Subscription quota exhausted") !== false) {
                return dataReturn(-6, '套餐包次数用完，请续购套餐');
            } elseif ($httpCode == 500) {
                return dataReturn(-7, 'API网关错误');
            } elseif ($httpCode == 0) {
                return dataReturn(-8, 'URL错误');
            } else {
                $headers = explode("\r\n", $header);
                $headList = array();
                foreach ($headers as $head) {
                    $value = explode(':', $head);
                    $headList[$value[0]] = $value[1];
                }

                return dataReturn(-7, "参数名错误 或 其他错误", $headList['x-ca-error-message']);
            }
        }
    }
}