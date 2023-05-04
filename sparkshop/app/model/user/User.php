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

namespace app\model\user;

use app\model\BaseModel;

class User extends BaseModel
{
    public function level()
    {
        return $this->hasOne(UserLevel::class, 'id', 'level_id');
    }

    public function group()
    {
        return $this->hasOne(UserGroup::class, 'id', 'group_id');
    }
}

