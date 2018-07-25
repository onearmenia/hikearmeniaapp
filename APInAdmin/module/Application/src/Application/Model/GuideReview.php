<?php

namespace Application\Model;

class GuideReview extends AbstractModel
{
    const TABLE_PREFIX ="gr_";
    protected $id;
    protected $guide_id;
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