<?php

namespace Application\Model;

use Aws\CloudFront\Exception\Exception;
use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class UserTrailTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\UserTrail';
    protected $tablePrefix = 'ut';
    protected $_id = 'ut_id';

    public function findUserTrail($user_id,$trail_id){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_'.'user_id'=>$user_id,$this->tablePrefix.'_'.'trail_id'=>$trail_id));
        if ($row->count() == 0) {
            return (object) null;
        }
        $post = $row->current();
        return $post;
    }
}