<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;
class TrailReviewTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model='Application\Model\TrailReview';
    protected $postType='tr';
    protected $tablePrefix='tr';
    protected $_id='tr_id';

    public function findUserTrailRating($user_id,$trail_id){
        $row = $this->tableGateway->select(array($this->tablePrefix.'_user_id'=>$user_id,$this->tablePrefix.'_trail_id'=>$trail_id));
        if ($row->count() == 0) {
            return false;
        }
        $post = $row->current();
        return $post;
    }
    public function getTrailReviews($trail_id){
        $trailReviews = array();
        $trailReviewQuery= "SELECT trail_review.* ,
                             users.user_first_name,
                             users.user_last_name,
                             users.user_avatar
                              FROM trail_review
                             LEFT JOIN users ON users.user_id=trail_review.tr_user_id
                             WHERE trail_review.tr_trail_id=$trail_id AND trail_review.tr_status='active' ORDER BY CASE WHEN (tr_user_id=200) THEN 0 ELSE 1 END , tr_id";
        $trailReviewResult = $this->adapter->query($trailReviewQuery)->execute();
        if ($trailReviewResult->count()) {
            while ($trailReviewResult->current()) {
                $trailReviews[] = $trailReviewResult->current();
                $trailReviewResult->next();
            }
        }
        return $trailReviews;
    }
    public function removeUserTrailReviews($user_id)
    {
        $this->tableGateway->delete(array($this-> tablePrefix.'_'.'user_id'=> $user_id));
    }
}