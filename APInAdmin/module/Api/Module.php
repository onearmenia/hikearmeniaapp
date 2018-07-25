<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 5:35 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Api;

use Zend\Db\ResultSet\ResultSet;
use Zend\Authentication\Storage;
use Zend\ModuleManager\Feature\AutoloaderProviderInterface;
use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;
use Zend\Serializer\Adapter\Json;
use Zend\View\Model\JsonModel;
use Zend\ModuleManager\Feature\ConfigProviderInterface;
use Zend\Authentication\Adapter\DbTable\CredentialTreatmentAdapter;
use Zend\Authentication\AuthenticationService;
use Zend\Db\TableGateway\TableGateway;
use Application\Model\User;
use Application\Model\UserTable;
use Application\Model\UserDailyRating;
use Application\Model\UserDailyRatingTable;


use Application\Model\UserToken;
use Application\Model\UserTokenTable;

class Module implements AutoloaderProviderInterface, ConfigProviderInterface
{

    public function onBootstrap(MvcEvent $e)
    {
        $e->getApplication()->getServiceManager()->get('translator');
        $eventManager = $e->getApplication()->getEventManager();
        $em = $eventManager;
        $serviceManager = $e->getApplication()->getServiceManager();
        $em->attach(MvcEvent::EVENT_ROUTE, function ($e) {
            if (!function_exists('getallheaders')) {
                function getallheaders()
                {
                    $headers = '';
                    foreach ($_SERVER as $name => $value) {
                        if (substr($name, 0, 5) == 'HTTP_') {
                            $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
                        }
                    }
                    return $headers;
                }
            }
            $match = $e->getRouteMatch();
            if ($match->getMatchedRouteName() == 'admin' ||
                $match->getMatchedRouteName() == 'admin-action' ||
                $match->getMatchedRouteName() == 'ajax-action' ||
                $match->getMatchedRouteName() == 'forgot-password' ||
                $match->getMatchedRouteName() == 'application'
            ) {
                return;
            }

            if (isset($match->getParams()['controller']) && ($match->getParams()['controller'] != 'Api\Controller\Login' &&

                    $match->getParams()['controller'] != 'Api\Controller\Index' &&
                    $match->getParams()['controller'] != 'Api\Controller\Trail' &&
                    $match->getParams()['controller'] != 'Api\Controller\TrailGuides' &&
                    $match->getParams()['controller'] != 'Api\Controller\Guide' &&
                    $match->getParams()['controller'] != 'Api\Controller\TrailReview' &&
                    $match->getParams()['controller'] != 'Api\Controller\Register' &&
                    $match->getParams()['controller'] != 'Api\Controller\ForgotPassword') &&
                !isset(getallheaders()['X_HTTP_AUTH_TOKEN'])
            ) {
                $view = new JsonModel(array("error" => array("code" => 401, "message" => "Must be logged in to perform this action")));
                echo $view->serialize();
                //TODO uncomment this lines
                http_response_code(401);
                exit();
            }
        }, -100);

        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_DISPATCH_ERROR, array($this, 'handleError'));
        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_RENDER_ERROR, array($this, 'handleError'));
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);
        $eventManager->getSharedManager()->attach(array('Api\Controller\ApiNotFoundController'), 'dispatch', function ($e) {
            $controller = $e->getTarget();
        });
    }

    public function handleError(MvcEvent $e)
    {
        if (isset($e->getParams()['exception'])) {
            $code = 401;
            $view = new JsonModel(array("error" => array("code" => 401, "message" => $e->getParams()['exception']->getMessage())));
        } else {
            $code = 404;
            $view = new JsonModel(array("error" => array("code" => 404, "message" => 'not found')));
        }
        echo $view->serialize();
        http_response_code($code);
        exit();
        /*$model = new ViewModel(array("returnCode" => 404, "msg" => "Not Found"));
        $e->setResult($model);
        $e->setViewModel($model);*/
    }

    public function getAutoloaderConfig()
    {
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

    public function getServiceConfig()
    {
        return array(
            'factories' => array(
                'Application\Model\User' => function ($sm) {
                    $tableGateway = $sm->get('UserTableGateway');
                    $table = new UserTable($tableGateway);
                    return $table;
                },
                'UserTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new User()); // include the class in the top
                    return new TableGateway('users', $dbAdapter, null, $resultSetPrototype);
                },

                'Application\Model\UserToken' => function ($sm) {
                    $tableGateway = $sm->get('UserTokenTableGateway');
                    $table = new UserTable($tableGateway);
                    return $table;
                },
                'UserTokenTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new UserToken()); // include the class in the top
                    return new TableGateway('user_tokens', $dbAdapter, null, $resultSetPrototype);
                },
            ),
        );
    }
}