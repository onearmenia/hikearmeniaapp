<?php

namespace Application\Model;

class ForgotPassword extends AbstractModel
{
    const TABLE_PREFIX ="fp_";
    protected $id;
    protected $token;
    protected $user_id;
    public function getJsonArray(){
        $ratings=array();
        foreach ($this->getRatings() AS $rating){
            if($rating){
                $ratings[] = $rating->getJsonArray();
            }
        }
        return array(
            'id'=>$this->getId(),
            'token' => $this->getToken(),
            'user_id' => $this->getUserId()
        );
    }
}