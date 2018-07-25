<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application\Controller;

use Zend\View\Model\ViewModel;
use Zend\View\Model\JsonModel;

class IndexController extends AbstractController
{

    public function indexAction()
    {
        if ($_SERVER['REQUEST_URI'] == "/") {
            header('Location: ' . $this->getConfig()->site['domain'] . '/admin', true, 301);
            exit;
        }
        return array(
            "isHomepage" => true,
            "language" => $this->getLang(),
        );
    }
    public function forgotPasswordAction()
    {
        $message='';
        $form = new \Application\Form\ForgotPasswordForm();
        $request = $this->getRequest();
        $token = $this->params()->fromRoute("id");
        if ($request->isPost()) {
            $form->setData($request->getPost());
            $fpRequest = $this->getForgotPasswordTable()->findByToken($token);
            if ($fpRequest&&$request->getPost('password')) {
                $user = $this->getUserTable()->find($fpRequest->getUserId());
                $user->setPassword(md5($request->getPost('password')));
                $this->getUserTable()->save($user);
                $this->getForgotPasswordTable()->delete($fpRequest->getId());
                $message= 'now you can login with new password';
            }
            else {
                $message= 'wrong token or password';
            }

        }
        return array(
            'message' => $message,
            'activeTab' => "login",
            'token' => $token,
        );
    }
}

