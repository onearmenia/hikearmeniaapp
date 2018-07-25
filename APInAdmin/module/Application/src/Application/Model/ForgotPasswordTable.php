<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;
class ForgotPasswordTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model='Application\Model\ForgotPassword';
    protected $postType='fp';
    protected $tablePrefix='fp';
    protected $_id='fp_id';


    public function findByToken($token){
        $where = new \Zend\Db\Sql\Where;
        $where->equalTo($this->tablePrefix.'_'.'token',$token);
        $result = $this->tableGateway->select($where);
        return $result->current();
    }

}