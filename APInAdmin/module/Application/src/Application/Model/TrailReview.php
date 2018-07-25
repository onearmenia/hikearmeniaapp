<?php

namespace Application\Model;

class TrailReview extends AbstractModel
{
    const TABLE_PREFIX ="tr_";
    protected $id;
    protected $trail_id;
    protected $user_id;
    protected $review;
    protected $rating;
    protected $status;
    public function getJsonArray(){
        $ratings=array();
        return array(
            'id'=>$this->getId(),
            'guide_id'=>$this->getFirstName(),
            'user_id'=>$this->getLastName(),
            'review'=>$this->getPhone(),
            'rating'=>$this->getEmail(),
        );
    }
}