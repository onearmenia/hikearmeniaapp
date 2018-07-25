<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 5:35 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth;

use Auth\Model\Auth;
use Auth\Model\AuthStorage;
use Auth\Model\AuthTable;
use Zend\Db\TableGateway\TableGateway;
use Zend\Db\ResultSet\ResultSet;
use Zend\Authentication\Storage;
use Zend\Authentication\AuthenticationService;
use Zend\Authentication\Adapter\DbTable as DbTableAuthAdapter;
use Zend\ModuleManager\Feature\AutoloaderProviderInterface;
use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

class Module implements AutoloaderProviderInterface
{
    public function onBootstrap(MvcEvent $e)
    {
        if (!($user = $e->getApplication()->getServiceManager()->get("AuthService")->getStorage()->read())
            || !is_a($user, "Auth\Model\Auth")
        ) {
            $user = new Auth();
        }
        $application = $e->getParam('application');
        $viewModel = $application->getMvcEvent()->getViewModel();

        $this->user = $user;
        $e->setParam("headerUser", $user);

        $viewModel->headerUser = $user;
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
                'Auth\Model\AuthTable' => function ($sm) {
                    $tableGateway = $sm->get('AuthTableGateway');
                    $table = new AuthTable($tableGateway);
                    return $table;
                },
                'AuthTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new Auth());
                    return new TableGateway('users', $dbAdapter, null, $resultSetPrototype);
                },
                'Auth\Model\AuthStorage' => function ($sm) {
                    return new AuthStorage();
                },
                'AuthService' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $dbTableAuthAdapter = new DbTableAuthAdapter($dbAdapter, 'users', 'user_email', 'user_password', null, "MD5(?)");
                    $authService = new AuthenticationService();
                    $authService->setAdapter($dbTableAuthAdapter);
                    $authService->setStorage($sm->get('Auth\Model\AuthStorage'));
                    return $authService;
                },
            ),
        );
    }

}