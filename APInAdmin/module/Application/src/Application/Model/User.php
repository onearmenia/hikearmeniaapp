<?php

namespace Application\Model;

class User extends AbstractModel
{
    const TABLE_PREFIX ="user_";
    protected $id;
    protected $first_name;
    protected $last_name;
    protected $email;
    protected $phone;
    protected $password;
    protected $status;
    protected $avatar='';
    protected $fb_id;
    protected $type;
    protected $saved_trails=array();

    public function getJsonArray(){
        return array(
            'id'=>$this->getId(),
            'first_name'=>$this->getFirstName(),
            'last_name'=>$this->getLastName(),
            'email'=>$this->getEmail(),
            'phone'=>$this->getPhone(),
            'avatar'=>$this->getAvatar(),
            'token' => $this->getTokenId(),
        );
    }
}


