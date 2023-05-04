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

namespace app\api\validate;

use think\Validate;

class UserCollectionValidate extends Validate
{
    protected $rule = [
        'goods_id|商品id' => 'require|number',
        'goods_name|商品名称' => 'require',
        'goods_pic|商品图片' => 'require',
        'price|商品价格' => 'require'
    ];
}