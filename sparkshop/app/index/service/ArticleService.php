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

use app\model\system\Article;

class ArticleService
{
    /**
     * 文章内容
     * @param $id
     * @return array
     */
    public function getArticleInfo($id)
    {
        $articleModel = new Article();
        $articleInfo = $articleModel->findOne([
            'id' => $id
        ])['data'];

        return dataReturn(0, 'success', $articleInfo);
    }
}