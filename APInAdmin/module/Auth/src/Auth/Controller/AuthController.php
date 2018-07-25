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
use Auth\Form\AuthLoginForm;
use Zend\Mail\Transport\Sendmail as SendmailTransport;
use Zend\Mail\Message;
use Zend\Http\Request;
use Zend\Http\Client;
use Zend\Session\Container;
use Application\Custom\SimpleImage;
use Application\Custom\HashGenerator;

class AuthController extends AbstractController
{
    public function indexAction()
    {
        if ($this->getUser()->getId()) {
        } else {
            return $this->redirect()->toRoute("auth", array("action" => "login"));
        }
    }

    public function registerAction()
    {
        if (!$this->getServiceLocator()->get('AuthService')->hasIdentity()) {
            $form = new AuthSignUpForm();
            $referral = $this->params()->fromRoute('referral');
            return array('form' => $form,'referral'=>$referral);
        } else {
            return $this->redirect()->toRoute('home');
        }
    }

    public function loginAction()
    {
        if ($this->getUser()->getId()) {
            return $this->redirect()->toUrl("/");
        }
        $request = $this->getRequest();
        if ($request->isPost()) {
        }
        $view = array();
        return $view;
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

    /**
     * Facebook OAuth2 callback
     * /fbauth/___/ flow
     * (1) Forward browser to Facebook App Dialog
     * (2) Browser redirected with ?state param
     * (3) cURL for access_token
     * (4) Get Facebook user info through graph.fb.com/me
     * (5) login()/connect()/signup()
     * (6) Display correct page
     */
    public function fbauthAction()
    {
        $request = $this->getRequest()->getQuery()->toArray();

        $auth = array(
            "signup" => $this->params()->fromRoute('url', false) == "signup",
            "login" => $this->params()->fromRoute('url', false) == "login",
            "connect" => $this->params()->fromRoute('url', false) == "connect",
            "state_key" => "fb_ipoints_auth"
        );

        $auth['url'] = $this->getConfig()->site['domain'] ."/". $this->getLang() . "/user/fbauth/";
        if ($auth['login'])
            $auth['url'] .= "login";
        else if ($auth['connect'])
            $auth['url'] .= "connect";
        else if ($auth['signup'])
            $auth['url'] .= "signup";
        else {
            return $this->redirect()->toRoute("home", array("language" => $this->getLang()));
        }
        $fbconfig = array(
            'appId' => $this->getConfig()->FB['api_key'],
            'secret' => $this->getConfig()->FB['app_secret'],
        );

        if(array_key_exists('state', $request) && $request['state']) {
            $state = json_decode(stripslashes(urldecode($request["state"])));
            if (array_key_exists('code', $request) && $request['code']) {
                // User accepted app authorization, retrieve access_token
                $url = "https://graph.facebook.com/oauth/access_token?client_id=" . $fbconfig['appId'] .
                    "&redirect_uri=" . $auth['url'] . "&client_secret=" . $fbconfig['secret'] .
                    "&code=" . $request["code"];

                $config = array(
                    'adapter'      => 'Zend\Http\Client\Adapter\Socket',
                    'ssltransport' => 'tls',
                    'sslverifypeer' => false
                );

                $client = new Client($url, $config);
                $response = $client->send();

                if (!$response->isSuccess()) {
                    die($response->getBody());
                } else {
                    try {
                        parse_str($response->getContent(), $facebook_response);
                        $access_token = $facebook_response['access_token'];

                        $config = array(
                            'adapter'      => 'Zend\Http\Client\Adapter\Socket',
                            'ssltransport' => 'tls',
                            'sslverifypeer' => false
                        );

                        $client1 = new Client("https://graph.facebook.com/me?access_token=" . $access_token, $config);
                        $response1 = $client1->send();

                        $facebook_user = json_decode($response1->getBody(), true);
                        if ($auth['login']) {
                            $redirect = $this->facebookLogin($state, $facebook_user['id'], $access_token, $facebook_user);
                        } else if ($auth['signup']) {
                            $redirect = $this->facebookSignup($state, $facebook_user['id'], $access_token, $facebook_user);
                        } else if ($auth['connect']) {
                            // @TODO implement
                            $redirect = $this->facebookConnect($state, $facebook_user['id'], $access_token, $facebook_user);
                        }
                    } catch (Exception $e) {
                        //$redirect = $this->getRedirect($state->redirect, $e->getMessage());
                        die("bbbbbbbbbbbbbbbbbbb");
                    }
                }
            } else {
                // User declined the applications Auth Dialog
                return $this->redirect()->toUrl($state->redirect);
            }
        } else {
            // the user is calling /fbauth/___/ without any parameters, redirect them to the Facebook login page
            $state = array("state_key" => $auth['state_key']);
            $state["redirect"] = array_key_exists("redirect", $request) ? $request["redirect"] : $this->getConfig()->site['domain']."/".$this->getLang()."/user/fbauth/";
            $redirect = "https://www.facebook.com/dialog/oauth?client_id=" . $fbconfig['appId'] .
                "&redirect_uri=" . urlencode($auth['url']) .
                "&scope=email,user_birthday,user_location,publish_actions&state=" . urlencode(json_encode($state));
        }
//        if (substr($redirect, 0, 1) == '/')
//            $redirect = substr($redirect, 1);
        if($redirect == "/?action=registration") {
            header("Location: " . $redirect);
            exit;
        }

        if (strpos($redirect, "http") === 0) {
            header("Location: " . $redirect);
        } else {
            if (!array_key_exists("iframe", $request)){
                return $this->redirect()->toUrl($this->getRequest()->getServer('HTTP_REFERER'));
            } else if($redirect) {
                return $this->redirect()->toUrl($redirect);
            } else {
                return $this->redirect()->toUrl($this->getRequest()->getServer('HTTP_REFERER'));
            }
        }
        exit;
    }

    // Login Process:
    //	(1) Check for !an existing session
    //	(2) Check for a ShowMe ID attached to this Facebook ID
    //	(3) Connect the ShowMe ID & the Facebook ID (access_token)
    //	(4) Log the user in
    public function facebookLogin($state, $facebook_id, $access_token, $facebook_user)
    {

        if ($this->getMember()->getId()) {
            return $state->redirect;
        } else {
            $user = $this->getAuthTable()->fetchByFbId($facebook_id);

            // user is null try to check is there user wich FB email
            if (!$user) {
                try {
                    $user = $this->getAuthTable()->getBy(array("email" => $facebook_user['email']));
                    if ($user) {
                        $this->getAuthTable()->connectSocialAccount(
                            $user->getId(),
                            $facebook_id,
                            "facebook",
                            $access_token
                        );
                    }
                } catch (\Exception $e) {
                    $user = false;
                }
            }
            //if user exists then check is inactive otherwise login
            if ($user) {
                // Connect the account so we can retrieve a session
                $this->getAuthTable()->connectSocialAccount(
                    $user->getId(),
                    $facebook_id,
                    "facebook",
                    $access_token
                );
                if($user->getShowGetPointsPopup() == 0) {
                    $user->setShowGetPointsPopup(1);
                    $user = $this->getAuthTable()->save($user);
                    $result = "/?action=registration";
                } else {
                    $result = "/";
                }

                $this->loginMember($user);

                return $result;
            } else {
                //if no user and no email then signUp him as new user to iPoints
                return $this->facebookSignup($state, $facebook_id, $access_token, $facebook_user);
            }
        }
    }

    // Signup Process:
    //	(1) Check for !an existing session
    //	(2) Check for !a ShowMe ID attached to this Facebook ID
    //	(3) Create new user
    //	(4) Connect the ShowMe ID & the Facebook ID (access_token, new row, etc.)
    // 	(5) Log the user in
    public function facebookSignup($state, $facebook_id, $access_token, $facebook_user)
    {
        if ($this->getMember()->getId()) {
            return $state->redirect;
        } else {
            $matchingEmail = false;
            $userWithFbId = false;
            try {
                $userWithFbId = $this->getAuthTable()->fetchByFbId($facebook_id);
            } catch (Exception $e) {
                //ignore any kind of , checking it after
            }
            try {
                $matchingEmail = $this->getAuthTable()->getBy(array("email" => $facebook_user['email']));
            } catch(Exception $e) {}
            if (!$matchingEmail && !$userWithFbId) {
                $avatar = $this->facebookAvatar($access_token);

                $arg['password'] = $facebook_user['id'];
                $arg['lastname'] = $facebook_user['last_name'];
                $arg['firstname'] = $facebook_user['first_name'];
                $arg['email'] = $facebook_user['email'];
                $arg['avatar'] = $avatar;
                $arg['fb_id'] = $facebook_user['id'];

                $user = new Auth($arg);
                $user->setCountry("Canada");

                $user = $this->getAuthTable()->save($user);
                $this->loginMember($user);

                $this->getAuthTable()->connectSocialAccount($user->getId(), $facebook_id, "facebook", $access_token);

                return "/?action=registration";
            } else {
                if (!empty($userWithFbId))
                    $param = "&facebook_id=" . $facebook_id;
                else if (!empty($matchingEmail))
                    $param = "&email=" . urlencode($facebook_user['email']);
                else
                    return;
                return $state->redirect . "?action=registration" . $param;
            }
        }
    }

    public function facebookAvatar($access_token)
    {
        $rand = md5(time());
        $avatarPath = PUBLIC_PATH . "/images/member/fbavatar_" . $rand . ".jpg";
        $avatarPathLocal = "/images/member/fbavatar_" . $rand . ".jpg";
        $avatar = file_get_contents("https://graph.facebook.com/me/picture?type=large&access_token=" . $access_token);
        $fp = fopen($avatarPath, 'w');
        fwrite($fp, $avatar);
        fclose($fp);

        $img = new SimpleImage();
        $img->load($avatarPath);
        $img->thumbnail(100, 100);
        $img->save($avatarPath);
        return "/images/member/fbavatar_" . $rand . ".jpg";
    }

    public function activationAction()
    {
        if($this->getMember()->getId()) {
            return $this->redirect()->toRoute('home', array("language" => $this->getLang()));
        }

        $user = $this->getAuthTable()->getBy(array("hash" => $this->params()->fromRoute('hash')));

        if($user) {
            $user->setStatus("active");
            $this->getAuthTable()->save($user);

            try {
                $template = "member_reg";
                $htmlViewPart = new ViewModel();
                $htmlViewPart->setTerminal(true)
                    ->setTemplate($template)
                    ->setVariables(array(
                        'language' => $this->getLang(),
                        'firstname' => $user->getFirstname(),
                        'domain' => $this->getConfig()->site['domain'],
                        'hash' => $user->getHash(),
                    ));

                $htmlBody = $this->getServiceLocator()
                    ->get('viewrenderer')
                    ->render($htmlViewPart);

                $this->sendMail($htmlBody, '', $this->translate('Welcome'), 'info@ipointscanada.ca', $user->getEmail());
            } catch (\Exception $e) {
            }
            return $this->redirect()->toUrl("/".$this->getLang()."/user/login?msg=activation");
        }

        return $this->redirect()->toRoute('404', array("language" => $this->getLang()));
    }
}