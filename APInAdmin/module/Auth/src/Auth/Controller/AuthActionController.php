<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 5:55 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth\Controller;

use Application\Controller\AbstractController;
use Zend\View\Model\ViewModel;
use Zend\View\Model\JsonModel;
use Auth\Model\Auth;
use Auth\Form\AuthSignUpForm;
use Auth\Form\EditForm;
use Auth\Form\AuthSignInForm;
use Zend\Mail\Transport\Sendmail as SendmailTransport;
use Zend\Mail\Message;
use Zend\Http\Request;
use Zend\Http\Client;
use Zend\Session\Container;
use Application\Custom\SimpleImage;
use Application\Custom\HashGenerator;


class AuthActionController extends AbstractController
{

    public function signUpAction()
    {
        if (!$this->getUser()->getId()) {
            $form = new AuthSignUpForm();
            $request = $this->getRequest();
            if ($request->isPost()) {
                $user = new Auth();
                $form->setInputFilter($user->getInputFilter());
                $form->setData($request->getPost());
                if ($form->isValid()) {
                    $user->exchangeArray($request->getPost()->toArray());
                    $user->setHash(HashGenerator::generate("15"));
                    $user->setPassword(md5($user->getPassword()));
                    $check_user = $this->getAuthTable()->getBy(array("user_email" => $user->getEmail()));
                    if (!$check_user) {
                        $this->getAuthTable()->save($user);
                        //$this->createAndSendMail();
                        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Thank you for registering with iPointsCanada")));
                    } else {
                        return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("This email is already used")));
                    }
                }
            }
            return new JsonModel(array("returnCode" => 201, "msg" => $form->getMessages()));
        } else {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("Your are logged in")));
        }
    }

    public function signInAction()
    {
        if ($this->getUser()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("Your are logged in")));
        }
        $request = $this->getRequest();
        if ($request->isPost()) {
            $form = new AuthSignInForm();
            $user = new Auth();
//            if ($request->getPost('user_email') == '' && $request->getPost('user_password') == '') {
//                return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("Please enter username and password")));
//            }
            $form->setInputFilter($user->getSignInFilter());
            $form->setData($request->getPost());
            if ($form->isValid()) {
                $res = $this->getAuthService()->getAdapter()
                    ->setIdentity($request->getPost('user_email'))
                    ->setCredential(md5($request->getPost('user_password')));

                $result = $this->getAuthService()->authenticate();

                if ($result->isValid()) {
                    $user->exchangeArray(get_object_vars($res->getResultRowObject()));
                    if($user->getStatus() == "pending") {
                        return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You have not activated your account")));
                    }
                    $this->getAuthSessionStorage()
                        ->setRememberMe(1);

                    $this->getAuthService()->setStorage($this->getAuthSessionStorage());
                    $this->getAuthService()->getStorage()->write($user);

                    if (!$this->getLastUrl()) {
                        $lastUrl = "/".$this->getLang();
                    } else {
                        $lastUrl = $this->getLastUrl();
                    }
                    return new JsonModel(array("returnCode" => 101, "msg" => "Success", "url" => $lastUrl));
                } else {
                    return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("Wrong username or password")));
                }
            } else {
                return new JsonModel(array("returnCode" => 201, "msg" => $form->getMessages()));
            }
        }
    }

    public function forgotPasswordAction()
    {
        $form = new \Auth\Form\AuthForgotForm();

        $request = $this->getRequest();
        if ($request->isPost()) {
            $user = $this->getAuthTable()->fetchByEmail($request->getPost('email'));
            if ($user) {
                $message = new Message();
                $message->addTo($request->getPost('email'))
                    ->addFrom('info@ipointscanada.ca')
                    ->setSubject('Forgot Password')
                    ->setBody("Your password is " . $user->getPassword());

                $transport = new SendmailTransport();
                $transport->send($message);
                return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Check your email")));
            }
            return new JsonModel(array("returnCode" => 202, "msg" => $this->translate("Email doesn't exist")));
        }
        return array('form' => $form);
    }

    public function logoutAction()
    {
        $this->getAuthSessionStorage()->forgetMe();
        $this->getAuthService()->clearIdentity();

        $this->flashmessenger()->addMessage($this->translate("You've been logged out"));
        return $this->redirect()->toUrl('/' . $this->getLang());
    }

}