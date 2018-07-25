<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;
class AccommodationTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model='Application\Model\Accommodation';
    protected $postType='acc';
    protected $tablePrefix='acc';
    protected $_id='acc_id';

    public function getTrailAccommodationCount($trail_id){
        $query="SELECT * FROM  rel_accommodation_trail WHERE rat_trail_id=$trail_id";
        $rows = $this->adapter->query($query)->execute();
        return $rows->count();
    }
}