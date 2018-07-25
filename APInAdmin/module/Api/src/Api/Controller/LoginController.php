<?php
namespace Api\Controller;

use Api\Controller\AbstractController;
use Application\Custom\Upload;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Facebook\Facebook;
use Facebook\Exceptions\FacebookResponseException;
use Facebook\Exceptions\FacebookSDKException;

class LoginController extends AbstractController
{

    public function create($data)
    {
        if ((!isset($data['email']) || !isset($data['password'])) && !isset($data['fb_token'])) {
            return new JsonModel(array("error" => array("code" => 422, "message" => "Missing Arguments")));
        }
        if (!isset($data['fb_token'])) {
            $user = $this->getUserTable()->login($data['email'], md5($data['password']));
            if (!$user) {
                return new JsonModel(array("error" => array("code" => 400, "message" => "Wrong username or password")));
            }
            if (!isset($data['udid'])) {
                $data['udid'] = '';
            }
            $userToken = $this->loginUser($user, $data['udid']);
            $user->setTokenId($userToken->getTokenId());
        } else {
            $fb = new Facebook([
                'app_id' => '1754297258160393',
                'app_secret' => '05516b1ac01f5567f8fbf11b4f45c0fe',
                'default_graph_version' => 'v2.5',
            ]);
            try {
                $fb_data = $fb->get('/me?fields=id,first_name,last_name,email,picture.width(500){url}', $data['fb_token']);
            } catch(FacebookResponseException $e) {
                return new JsonModel(array("error" => array("code" => 400, "message" => "Wrong Token")));
            } catch(FacebookSDKException $e) {
                echo 'Facebook SDK returned an error: ' . $e->getMessage();
                exit;
            }

            $fb_userData = $fb_data->getDecodedBody();
            $user = $this->getUserTable()->loginWithFacebook( $fb_data->getDecodedBody()['id']);
            if (!$user) {
                if (!isset($fb_userData['first_name']) || !isset($fb_userData['last_name'])|| !isset($fb_userData['email'])) {
                    return new JsonModel(array("error" =>array("code" => 422, "message" => "Missing arguments")));
                }
                $user = $this->getUserTable()->getUserByEmail($fb_userData['email']);
                if (!$user) {
                    $user = $this->getUserTable()->createNew();
                    $user->exchangeArray($fb_userData);
                    $user->setId(null);
                    $user->setFbId($fb_userData['id']);
                    if (isset($fb_userData['picture']['data']['url'])) {
                        $uploader = new Upload($this->getConfig());
                        $imgUrl = $uploader->uploadFromUrl($fb_userData['picture']['data']['url'],$fb_userData['picture']['data']['url']);
                        $user->setAvatar( $imgUrl);
                    }


                    $user->setType('user');
                    $user->setStatus('active');
                    $user->setCreatedAt(date('Y-m-d h:i:s'));
                    $this->getUserTable()->save($user);
                    $user = $this->getUserTable()->getUserByEmail($fb_userData['email']);
                } else {
                    $user->setFbId($fb_userData['id']);
                    $this->getUserTable()->save($user);
                }
            }
        }
        if (!isset($data['udid'])) {
            $data['udid'] = '';
        }
        $userToken = $this->loginUser($user, $data['udid']);
        $user->setTokenId($userToken->getTokenId());
        return new JsonModel(array("result" => $user->getJsonArray()));
    }
}