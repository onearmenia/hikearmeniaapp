<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;
use Api\Adapter\WundergroundAdapter;
abstract class AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model;
    protected $postType;
    protected $tablePrefix;
    protected $_id ;
    protected $apiAdapter;

    public function __construct(TableGateway $tableGateway)
    {
        $this->tableGateway = $tableGateway;
        $this->adapter = new Adapter($this->tableGateway->getAdapter()->getDriver());
        $this->apiAdapter = WundergroundAdapter::getInstance($this->model);
    }

    public function save(AbstractModel $obj)
    {
        $data = $obj->getArrayCopy();
        if(isset($data['status'])){
            if($data[$this->_id]&&($data[$this->tablePrefix.'_status']=='draft'||$data[$this->tablePrefix.'_status']=='')){
                $data[$this->tablePrefix.'_status']='publish';
            }
        }

        $id = (int) $obj->getId();
        if ($id == 0) {
            $this->tableGateway->insert($data);
            $id = $this->tableGateway->lastInsertValue;
            $object = $this->find($id);
        } else {
            if ($this->find($id)) {
                $this->tableGateway->update($data, array($this->_id => $id));
                $object = $this->find($id);
            } else {
                throw new \Exception('Form id does not exist');
            }
        }
        return $object;
    }

    public function createNew()
    {
        return new $this->model;
    }

    public function find($id)
    {
        $row = $this->tableGateway->select(array($this->_id=>$id));
        if ($row->count() == 0) {
            return false;
        }
        $post = $row->current();
        return $post;
    }
    public function findAll($status=null)
    {
        $where = new \Zend\Db\Sql\Where;
        if(isset($status)){
            $where->equalTo($this->tablePrefix.'_'.'status',$status);
        }
        $resultSet = $this->tableGateway->select($where);


        if ($resultSet->count() == 0) {
            return array();
        }
        $result = array();
        while ($row = $resultSet->current()) {
            $res = $this->find($row->getId());
            if(!property_exists($res, 'status' )|| $res->getStatus()!=='draft'){
                $result[] = $res;
            }
            $resultSet->next();
        }
        return $result;
    }
    public function delete($id)
    {
        $this->tableGateway->delete(array($this->_id => $id));
    }
    public function getNotUsed()
    {
        $result = $this->tableGateway->select(array($this->tablePrefix.'_'.'status'=>'draft'));

        if ($result->count() == 0) {
            $model = $this->createNew();
            $model->setStatus('draft');
            return $this->save($model);
        }


        return $result->current();
    }
    public function moveToTrash($id){
        $this->tableGateway->update(array($this->tablePrefix.'_status'=>'trash'),array($this->_id => $id));
    }

    public function  findAllJson($status='publish'){
        $where = new \Zend\Db\Sql\Where;
        if(property_exists($this->model,'status')){
            if($status=='publish'){
                $where->equalTo( $this->tablePrefix.'_status','publish');
                $where->OR->isNull( $this->tablePrefix.'_status');
            }
            else {
                $where->equalTo( $this->tablePrefix.'_status',$status);
            }
        }
        $resultSet = $this->tableGateway->select($where);
        if ($resultSet->count() == 0) {
            return false;
        }
        $result = array();
        while ($row = $resultSet->current()) {
            $res = $this->find($row->getId());
            $result[] = $res->getJsonArray();
            $resultSet->next();
        }
        return $result;

    }

    public function write(array $args)
    {
        $obj = new $this->model($args);
        return $this->save($obj);
    }
}
