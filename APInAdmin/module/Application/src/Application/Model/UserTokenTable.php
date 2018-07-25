<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;
use Application\Custom\HashGenerator;
class UserTokenTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model='Application\Model\UserToken';
    protected $postType='user_token';
    protected $tablePrefix='ut';
    protected $_id='ut_id';

    public function getToken(AbstractModel $user){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_'.'user_id'=>$user->getId()));
        if($row->count() > 0){
            return $row->current($user);
        }
        else return $this->generateToken($user);
    }
    public function deleteUdId($udid)
    {
        $this->tableGateway->delete(array($this->tablePrefix.'_'.'udid' => $udid));
    }
    public function deleteToken($token){
        $this->tableGateway->delete(array($this->tablePrefix.'_'.'token_id' => $token));
    }
}