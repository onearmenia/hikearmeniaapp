<?php
namespace Api\Controller;

use Api\Controller\AbstractController;
use Application\Custom\Upload;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Zend\View\Model\ViewModel;
use Zend\View\Renderer\PhpRenderer;
use Zend\View\Resolver\TemplateMapResolver;

class RegisterController extends AbstractController
{

    public function create($data)
    {
        try {

            if (!isset($data['password']) || !isset($data['first_name']) || !isset($data['last_name'])|| !isset($data['email'])) {
                return new JsonModel(array("error" =>array("code" => 422, "message" => "Missing arguments")));
            }
            if (!filter_var(  $data['email'], FILTER_VALIDATE_EMAIL)) {
                return new JsonModel(array("returnCode" => 201, "msg" => "Invalid email"));
            }
            if($this->getUserTable()->getUserByEmail($data['email'])){
                return new JsonModel(array("error" =>array("code" => 400, "message" => "User Already Exists")));
            }
            $uploader = new Upload($this->getConfig());

            $user = $this->getUserTable()->createNew();
            $data['password']= md5($data['password']);
            $user->exchangeArray($data);
            if(isset($data['avatar'])){
                $user_avatar = $uploader->uploadFromBase64($data['avatar']);
                $user->setAvatar($user_avatar);
            }
            $user->setType('user');
            $user->setStatus('active');
            $user->setCreatedAt(date('Y-m-d h:i:s'));
            $this->getUserTable()->save($user);
            $user = $this->getUserTable()->login($data['email'], $data['password']);

            if (!$user) {
                return new JsonModel(array("error" =>array("code" => 400, "message" => "Wrong username or password")));
            }
            if(!isset($data['udid'])){
                $data['udid']='';
            }

            $this->sendMail($user);
            $userToken = $this->loginUser($user,$data['udid']);
            $user->setTokenId($userToken->getTokenId());
            return new JsonModel(array("result" =>$user->getJsonArray()));
        }
        catch (\Exception $e){
            var_dump($e->getMessage());
        }
    }
    public function sendMail($user){

        $view = new PhpRenderer();
        $resolver = new TemplateMapResolver();
        $view->setResolver($resolver);

        $resolver->setMap(array(
            'mailLayout' => __DIR__ . '/../../../view/layout/layout.phtml',
            'mailTemplate' => __DIR__ . '/../../../view/registration.phtml'
        ));
        $args = array(
            'userFirstName' =>$user->getFirstName(),
        );
        $headers = "From: HikeArmenia\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $subject = 'Welcome to HIKEArmenia';
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
            'mailTemplate' => __DIR__ . '/../../../view/registration.phtml'
        ));
        $args = array(
            'userFirstName' =>'Konstantin',
            'token' =>'barev'
        );
        $headers = "From: HikeArmenia\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
        $subject = 'Welcome to HIKEArmenia';
        $viewModel = new ViewModel($args);
        $viewModel->setTemplate("mailTemplate");
        $content =  $view->render($viewModel);
        mail('konstantin.sargsyan@gmail.com',$subject,$content,$headers);

        exit();
    }*/
}