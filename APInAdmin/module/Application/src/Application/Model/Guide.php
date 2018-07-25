<?php

namespace Application\Model;

class Guide extends AbstractModel
{
    const TABLE_PREFIX ="guide_";
    protected $id;
    protected $first_name;
    protected $last_name;
    protected $phone;
    protected $email;
    protected $status;
    protected $image;
    protected $description='';
    protected $rating_count = 0;
    protected $rating = 0;
    public function getJsonArray(){
        $ratings=array();
        return array(
            'id'=>$this->getId(),
            'first_name'=>$this->getFirstName(),
            'last_name'=>$this->getLastName(),
            'phone'=>$this->getPhone(),
            'email'=>$this->getEmail(),
        );
    }
}