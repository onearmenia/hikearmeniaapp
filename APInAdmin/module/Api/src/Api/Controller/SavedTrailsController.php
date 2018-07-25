<?php
namespace Api\Controller;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class SavedTrailsController extends AbstractController
{
    public function create($data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        if(!$this->checkArguments($data,array('trail_id'))){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Missing Arguments")));
        }
        $this->getTrailTable()->saveTrail($data['trail_id'],$user->getId());
        return new JsonModel(array("result" =>array("code" => 200)));
    }
    public function update($id,$data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        $this->getTrailTable()->saveTrail($id,$user->getId());
        return new JsonModel(array("result" =>array("code" => 200)));
    }

    public function delete($id)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        $this->getTrailTable()->deleteSavedTrail($id,$user->getId());
        return new JsonModel(array("result" =>array("code" => 200)));
    }

}