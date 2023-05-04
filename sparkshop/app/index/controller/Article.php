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

use app\index\service\ArticleService;
use think\facade\View;

class Article extends Base
{
    // 文章内容
    public function index()
    {
        $id = input('param.id');

        $articleService = new ArticleService();
        $articleInfo = $articleService->getArticleInfo($id)['data'];

        View::assign([
            'info' => $articleInfo
        ]);

        return View::fetch();
    }
}