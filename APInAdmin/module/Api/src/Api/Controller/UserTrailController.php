<?php
namespace Api\Controller;

use Zend\Mvc\Application;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Application\Custom\XmlParser;

class UserTrailController extends AbstractController
{

    public function get($id)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }

            $userTrail = $this->getUserTrailTable()->findUserTrail($user->getId(),$id);
            if((array) $userTrail){
                $userTrail = $userTrail->getJsonArrayCopy();
            }

        return new JsonModel(array("result" => $userTrail));
    }

}