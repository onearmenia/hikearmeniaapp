<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class GuideReviewTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\GuideReview';
    protected $postType = 'gr';
    protected $tablePrefix = 'gr';
    protected $_id = 'gr_id';

    public function findUserGuideRating($user_id, $guide_id)
    {
        $row = $this->tableGateway->select(array($this->tablePrefix . '_user_id' => $user_id, $this->tablePrefix . '_guide_id' => $guide_id));
        if ($row->count() == 0) {
            return false;
        }
        $post = $row->current();
        return $post;
    }

    public function findGuideReviews($guide_id)
    {

        $where = new \Zend\Db\Sql\Where;
        $where->equalTo($this->tablePrefix . '_' . 'guide_id', $guide_id);
        $where->AND->equalTo($this->tablePrefix . '_' . 'status', 'active');
        $resultSet = $this->tableGateway->select($where);
        if ($resultSet->count() == 0) {
            return [];
        }
        $result = array();
        while ($row = $resultSet->current()) {
            $res = $this->find($row->getId());
            $result[] = $res;
            $resultSet->next();
        }
        return $result;
    }

    public function removeUserGuideReviews($user_id)
    {
        $this->tableGateway->delete(array($this-> tablePrefix.'_'.'user_id'=> $user_id));
    }
}