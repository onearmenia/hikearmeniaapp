<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;
class UserTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model='Application\Model\User';
    protected $postType='user';
    protected $tablePrefix='user';
    protected $_id='user_id';

    public function login($email,$password){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_'.'email'=>$email,$this->tablePrefix.'_'.'password'=>$password));
        if($row->count() > 0){
            $user = $row->current();
            return $user;
        }
        else return false;
    }
    public function loginWithFacebook($fb_id){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_'.'fb_id'=>$fb_id));
        if($row->count() > 0){
            $user = $row->current();
            return $user;
        }
        else return false;
    }
    public function generateToken($user){
        $user->setTokenId(HashGenerator::generate(64));
        return $this->save($user);
    }
    public function getUserByEmail($email){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_'.'email'=>$email));
        if($row->count() > 0){
            return $row->current();
        }
        return false;
    }
    public function getUserByToken($token){
        $row = $this->adapter->query("SELECT * from user_tokens WHERE ut_token_id='{$token}'")->execute();
        if($row->current()){
            return $this->find($row->current()['ut_user_id']);
        }
        return false;
    }
    public function findByType($type)
    {
        $where = new \Zend\Db\Sql\Where;
        $where->equalTo($this->tablePrefix.'_'.'status','active');
        if(isset($type)){
            $where->equalTo($this->tablePrefix.'_'.'type',$type);
        }
        $resultSet = $this->tableGateway->select($where);


        if ($resultSet->count() == 0) {
            return false;
        }
        $result = array();
        while ($row = $resultSet->current()) {
            $res = $this->find($row->getId());
            $result[] = $res;
            $resultSet->next();
        }
        return $result;
    }

}