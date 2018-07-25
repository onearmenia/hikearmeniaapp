<?php
namespace Api\Controller;

use Application\Custom\Upload;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class UserController extends AbstractController
{
    public function getList()
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        $user->setTokenId(getallheaders()['X_HTTP_AUTH_TOKEN']);
        return new JsonModel(array("result" =>$user->getJsonArray()));
    }

    public function get($id)
    {
        $user = $this->getUserTable()->find($id);
        return new JsonModel(array("result" =>$user->getJsonArray()));
    }

    public function create($data)
    {
      return new JsonModel(array("returnCode" => 201, "msg" => "create"));
    }

    public function update($id, $data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        $updatedUser = $this->getUserTable()->getUserByEmail($data['email']);
        if($updatedUser && $user->getId()!=$updatedUser->getId()){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "User with that email already exists")));
        }
        $uploader = new Upload($this->getConfig());
        $user->exchangeArray($data);
        if(isset($data['avatar'])){
            $user_avatar = $uploader->uploadFromBase64($data['avatar']);
            $user->setAvatar($user_avatar);
        }


        $this->getUserTable()->save($user);
        $user->setTokenId(getallheaders()['X_HTTP_AUTH_TOKEN']);
        return new JsonModel(array("result" =>$user->getJsonArray()));
    }

    public function delete($id)
    {
        # code...
    }

}