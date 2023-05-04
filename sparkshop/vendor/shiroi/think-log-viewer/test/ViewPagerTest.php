<?php
namespace test;

use PHPUnit\Framework\TestCase;
use Shiroi\ThinkLogViewer\LogServer;

class ViewPagerTest extends TestCase
{
    /**
     * 调试
     * @doesNotPerformAssertions
     */
    public function testViewPager() {
        $pager = new LogServer();
        $pager->index();
    }
}