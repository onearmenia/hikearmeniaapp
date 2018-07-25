<?php
namespace Api\Controller;

use Api\Controller\AbstractController;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class ChangePasswordController extends AbstractController
{
    public function create($data){
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 400, "message" => "Must be logged in to perform this action")));
        }
        if(!isset($data['old_password'])||!isset($data['new_password'])){
            return new JsonModel(array("error" =>array("code" => 422, "message" => "Missing arguments")));
        }
        if($user->getPassword()==md5($data['old_password'])){
            $user->setPassword(md5($data['new_password']));
            $this->getUserTable()->save($user);
            return new JsonModel(array("result" =>array("code" => 200)));
        }
        else{
            return new JsonModel(array("error" =>array("code" => 400, "message" => "wrong password")));
        }
    }
}