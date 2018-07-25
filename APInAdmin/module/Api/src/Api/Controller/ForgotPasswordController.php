<?php
namespace Api\Controller;

use Api\Controller\AbstractController;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\ViewModel;
use Zend\View\Model\JsonModel;
use Application\Custom\HashGenerator;
use Zend\View\Model;
use Zend\View\Renderer\PhpRenderer;
use Zend\View\Resolver\TemplateMapResolver;

class ForgotPasswordController extends AbstractController
{
    public function create($data){
        $headers = 'From: HikeArmenia';
        if(!isset($data['email'])){
            return new JsonModel(array("error" =>array("code" => 400, "message" => "Missing arguments")));
        }
        $user = $this->getUserTable()->getUserByEmail($data['email']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 400, "message" => "User does not exist")));
        }
        $email=$user->getEmail();
        $token = HashGenerator::generate(32);
        $this->sendMail($user,$token);

        $fpRequest = $this->getForgotPasswordTable()->createNew();
        $fpRequest->setUserId($user->getId());
        $fpRequest->setToken($token);
        $this->getForgotPasswordTable()->save($fpRequest);
        return new JsonModel(array("result" =>array("code" => 200)));
    }
    public function sendMail($user,$token){

        $view = new PhpRenderer();
        $resolver = new TemplateMapResolver();
        $view->setResolver($resolver);

        $resolver->setMap(array(
            'mailLayout' => __DIR__ . '/../../../view/layout/layout.phtml',
            'mailTemplate' => __DIR__ . '/../../../view/forgot_password.phtml'
        ));
        $args = array(
            'userFirstName' =>$user->getFirstName(),
            'token' =>$token
        );
        $headers = "From: HikeArmenia\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $subject = 'Forgot your HIKEArmenia password';
        $viewModel = new ViewModel($args);
        $viewModel->setTemplate("mailTemplate");
        $content =  $view->render($viewModel);
        mail($user->getEmail(),$subject,$content,$headers);
        return;
    }
   /* public function getList(){
        $view = new PhpRenderer();
        $resolver = new TemplateMapResolver();
        $view->setResolver($resolver);

        $resolver->setMap(array(
            'mailLayout' => __DIR__ . '/../../../view/layout/layout.phtml',
            'mailTemplate' => __DIR__ . '/../../../view/forgot_password.phtml'
        ));
        $args = array(
            'userFirstName' =>'Konstantin',
            'token' =>'barev'
        );
        $headers = "From: HikeArmenia\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $subject = 'Forgot your HIKEArmenia password';
        $viewModel = new ViewModel($args);
        $viewModel->setTemplate("mailTemplate");
        $content =  $view->render($viewModel);
        mail('konstantin.sargsyan@gmail.com',$subject,$content,$headers);
        exit();
    }*/
}