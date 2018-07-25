<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Admin\Model;

use Zend\Authentication\Result;
use Zend\Db\TableGateway\TableGateway;
use Admin\Model\AdminAuth;

class AdminAuthTable
{
    protected $tableGateway;
    protected $_primary = "user_id";

    public function __construct(TableGateway $tableGateway)
    {
        $this->tableGateway = $tableGateway;
    }

    public function fetchAll()
    {
        $resultSet = $this->tableGateway->select();
        return $resultSet;
    }

    public function save(AdminAuth $adminAuth)
    {
        $data = $adminAuth->getArrayCopyForInsert();
        $id = (int)$adminAuth->getId();
        if ($id == 0) {
            $this->tableGateway->insert($data);
            $res = $this->tableGateway->select(array($this->_primary => $this->tableGateway->lastInsertValue))->current();
        } else {
            if ($this->getById($id)) {
                $this->tableGateway->update($data, array($this->_primary => $id));
                $res = $adminAuth;
            } else {
                throw new \Exception('Form id does not exist');
            }
        }
    }

    public function fetchByEmail($email)
    {
        $resultSet = $this->tableGateway->select(array('email' => $email));
        $column = $resultSet->current();
        return $column;
    }

    public function fetchById($id)
    {
        $resultSet = $this->tableGateway->select(array('client_id' => $id));
        $column = $resultSet->current();
        return $column;
    }

    public function authenticate($email, $password)
    {
        $resultSet = $this->tableGateway->select(array('user_email' => $email, 'user_password' => md5($password),'user_type'=>'admin'));
        $code = ($res = $resultSet->current()) ? 1 : -1;
        $res = new Result($code, $res);
        return $res;
    }
}