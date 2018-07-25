<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:10 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth\Model;

use Zend\Db\TableGateway\TableGateway;
use Auth\Model\Auth;
use Zend\Db\Adapter\Adapter;

class AuthTable
{
    protected $tableGateway;
    protected $_primary = "user_id";
    protected $adapter;

    public function __construct(TableGateway $tableGateway)
    {
        $this->tableGateway = $tableGateway;
        $this->adapter = new Adapter($this->tableGateway->getAdapter()->getDriver());
    }

    public function fetchAll()
    {
        $resultSet = $this->tableGateway->select();
        return $resultSet;
    }

    public function save(Auth $auth)
    {
        $data = $auth->getArrayCopyForInsert();

        $id = (int) $auth->getId();
        if ($id == 0) {
            $this->tableGateway->insert($data);
            $id = $this->tableGateway->lastInsertValue;
            $res = $this->tableGateway->select(array($this->_primary => $id))->current();
        } else {
            if ($this->tableGateway->select(array($this->_primary => $id))->count()) {
                $this->tableGateway->update($data, array($this->_primary => $id));
                $res = $this->tableGateway->select(array($this->_primary => $id))->current();
            } else {
                throw new \Exception('Form id does not exist');
            }
        }
        return $res;
    }

    public function fetchByEmail($email)
    {
        $resultSet = $this->tableGateway->select(array('user_email'=>$email));
        $row=$resultSet->current();
        if (!$row) {
            return false;
        }
        return $row;
    }

    public function getById($id)
    {
        $id  = (int) $id;
        $rowset = $this->tableGateway->select(array($this->_primary => $id));
        $row = $rowset->current();
        if (!$row) {
            return false;
        }
        return $row;
    }

    public function fetchByFbId($fid)
    {
        $rowset = $this->tableGateway->select(array('user_fb_id'=> $fid));
        $row = $rowset->current();
        if (!$row) {
            return false;
        }
        return $row;
    }

    public function saveFbUser($fbid,$firstname,$lastname)
    {
        $this->tableGateway->insert(array('fb_id'=>$fbid,'firstname'=>$firstname,'lastname'=>$lastname,'points'=>25000));
        $memberId=$this->tableGateway->lastInsertValue;
        $member = $this->tableGateway->select(array('member_id' => $memberId))->current();
        return $member;
    }

    public function getBy(array $args)
    {
        $rowset = $this->tableGateway->select($args);
        $row = $rowset->current();
        if (!$row) {
            return false;
        }
        return $row;
    }

    public function connectSocialAccount($userId, $accountId, $accountName, $accessToken = false,
                                         $accessTokenSecret = false, $expirationDate = false)
    {
        $sql = "SELECT * FROM rel_social_accounts WHERE account_name = '" . $accountName . "' AND account_id = " . $accountId;
        $res = $this->adapter->query($sql)->execute();
        if ($res->count() == 0) {
            $sql = "INSERT INTO rel_social_accounts
                        SET member_id = " . $userId . ", account_id = " . $accountId . ", account_name = '" . $accountName . "'";
            if ($accessToken != false)
                $sql .= ", access_token = '" . $accessToken . "'";
            if ($accessTokenSecret != false)
                $sql .= ", access_token_secret = '" . $accessTokenSecret . "'";
            if ($expirationDate != false)
                $sql .= ", expiration_date = '" . $expirationDate . "'";
            $r = $this->adapter->query($sql)->execute();

            if (!$r) {
                return false;
            }
            return true;
        } else {
            $socialAccount = $res->current();
            if ($userId != $socialAccount["member_id"]) {
                return false;
            }

            $sql = "UPDATE rel_social_accounts SET access_token = ";
            $sql .= ($accessToken == false) ? "NULL" : "'" . $accessToken . "'";
            $sql .= ", access_token_secret = ";
            $sql .= ($accessTokenSecret == false) ? "NULL" : "'" . $accessTokenSecret . "'";
            if ($expirationDate != false) {
                $sql .= ", expiration_date = '" . $expirationDate . "' ";
            }
            $sql .= ", member_id = " . $userId . " WHERE account_id = " . $accountId;
            $r = $this->adapter->query($sql)->execute();
            if (!$r) {
                return false;
            }

            return true;
        }
    }

    public function getForAdmin(array $args, $search_query, $from_to, $market_id = false, $order = "", $page = 1, $count = 6)
    {
        $where = array();
        if(!empty($args)) {
            foreach ($args as $k => $v) {
                $where[] = "$k = '" . $v . "'";
            }
        }

        $limit = " LIMIT " . ($page-1) * $count . ", " . $count;
        if($from_to['from_date']) {
            $where[] = "DATE(" . $from_to['date_type'] . ") >= DATE('" . $from_to['from_date'] ."')";
        }
        if($from_to['to_date']) {
            $where[] = "DATE(" . $from_to['date_type'] . ") <= DATE('" . $from_to['to_date'] ."')";
        }
        if(empty($where)) {
            $where = "";
        } else {
            $where = " WHERE ".implode(" AND ", $where);
        }

        if($market_id) {
            $where .= " AND (region_id = {$market_id} OR region2_id = {$market_id}) ";
        }

        if($search_query) {
            if(!$where) {
                $where = " WHERE ";
            } else {
                $where .= " AND ";
            }
            $where .= " (CONCAT(imembers.firstname, ' ', imembers.lastname) LIKE '%{$search_query}%' OR imembers.zip LIKE '%{$search_query}%') ";
        }

        $sql = "SELECT * FROM imembers
                                            {$where}
                                            {$order}
                                            {$limit}";

        $rows = $this->adapter->query($sql)->execute();

        if ($rows->count() == 0) {
            return false;
        }

        while ($row = $rows->current()) {
            $row['created_date'] = date("F d, Y", strtotime($row['created_at']));
            $result[] = $row;
            $rows->next();
        }

        return $result;
    }

    public function getForAdminPageCount(array $args, $search_query, $from_to, $market_id = false, $count = 6)
    {
        $where = array();
        if(!empty($args)) {
            foreach ($args as $k => $v) {
                $where[] = "$k = '" . $v . "'";
            }
        }

        if($from_to['from_date']) {
            $where[] = "DATE(" . $from_to['date_type'] . ") >= DATE('" . $from_to['from_date'] ."')";
        }
        if($from_to['to_date']) {
            $where[] = "DATE(" . $from_to['date_type'] . ") <= DATE('" . $from_to['to_date'] ."')";
        }
        if(empty($where)) {
            $where = "";
        } else {
            $where = " WHERE ".implode(" AND ", $where);
        }

        if($market_id) {
            $where .= " AND (region_id = {$market_id} OR region2_id = {$market_id}) ";
        }

        if($search_query) {
            if(!$where) {
                $where = " WHERE ";
            } else {
                $where .= " AND ";
            }
            $where .= " (CONCAT(imembers.firstname, ' ', imembers.lastname) LIKE '%{$search_query}%' OR imembers.zip LIKE '%{$search_query}%') ";
        }

        $rows = $this->adapter->query("SELECT count(*) AS c FROM imembers
                                            {$where}")->execute();

        if ($rows->count() == 0) {
            return false;
        }

        $row = $rows->current();

        return ($row['c'] % $count) == 0 ? floor($row['c'] / $count) : floor($row['c'] / $count) + 1;
    }

}