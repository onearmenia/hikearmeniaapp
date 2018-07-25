<?php
namespace Api\Controller;

use Api\Controller\AbstractController;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class LogoutController extends AbstractController
{
    public function create($data){

        $this->getUserTokenTable()->deleteToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        return new JsonModel(array("result" =>array("code" => 200)));
    }
}