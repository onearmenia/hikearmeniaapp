<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class TrailCoverTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\TrailCover';
    protected $postType = 'tc';
    protected $tablePrefix = 'tc';
    protected $_id = 'tc_id';
    public function updateFeatured($trail_id,$image_id,$featured){
        if($featured){
            $query = "update trail_covers set tc_is_featured = 0 WHERE tc_trail_id=$trail_id";
            $this->adapter->query($query)->execute();
        }
        $query = "update trail_covers set tc_is_featured = $featured WHERE tc_id=$image_id";
        $this->adapter->query($query)->execute();
        return;
    }
}