<?php

namespace Application\Model;

class TrailCover extends AbstractModel
{
    const TABLE_PREFIX ="tc_";
    protected $id;
    protected $trail_id;
    protected $cover;
    protected $is_featured;
    protected $order;
}