<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application;

use Application\Model\Accommodation;
use Application\Model\AccommodationTable;
use Application\Model\Guide;
use Application\Model\GuideReview;
use Application\Model\GuideReviewTable;
use Application\Model\GuideTable;
use Application\Model\Language;
use Application\Model\LanguageTable;
use Application\Model\Trail;
use Application\Model\TrailCover;
use Application\Model\TrailCoverTable;
use Application\Model\TrailReview;
use Application\Model\TrailReviewTable;
use Application\Model\TrailTable;
use Application\Model\UserTrail;
use Application\Model\UserTrailTable;
use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;
use Auth\Model\Auth;
use Application\Model\User;
use Application\Model\UserTable;
use Application\Model\UserToken;
use Application\Model\UserTokenTable;
use Application\Model\ForgotPasswordTable;
use Application\Model\ForgotPassword;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\ResultSet\ResultSet;
use Zend\Session\Container;

class Module
{
    public function onBootstrap(MvcEvent $e)
    {
        $eventManager = $e->getApplication()->getEventManager();
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);

        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_ROUTE, array($this, 'onLanguageRoute'));
        //handle the dispatch error (exception)
        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_DISPATCH_ERROR, array($this, 'handleError'));
        //handle the view render error (exception)
        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_RENDER_ERROR, array($this, 'handleError'));
    }

    public function handleError(MvcEvent $e)
    {

        $viewModel = $e->getViewModel();
        $viewModel->setTemplate('error/500');
    }

    public function onLanguageRoute(MvcEvent $e)
    {

    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
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

    public function getServiceConfig()
    {
        return array(
            'factories' => array(
                'UserTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new User());
                    return new TableGateway('users', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\UserTable' => function ($sm) {
                    $tableGateway = $sm->get('UserTableGateway');
                    $table = new UserTable($tableGateway);
                    return $table;
                },

                'TrailTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new Trail());
                    return new TableGateway('trails', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\TrailTable' => function ($sm) {
                    $tableGateway = $sm->get('TrailTableGateway');
                    $table = new TrailTable($tableGateway);
                    return $table;
                },


                'UserTrailTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new UserTrail());
                    return new TableGateway('user_trails', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\UserTrailTable' => function ($sm) {
                    $tableGateway = $sm->get('UserTrailTableGateway');
                    $table = new UserTrailTable($tableGateway);
                    return $table;
                },

                'TrailCoverTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new TrailCover());
                    return new TableGateway('trail_covers', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\TrailCoverTable' => function ($sm) {
                    $tableGateway = $sm->get('TrailCoverTableGateway');
                    $table = new TrailCoverTable($tableGateway);
                    return $table;
                },
                'GuideTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new Guide());
                    return new TableGateway('guides', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\GuideTable' => function ($sm) {
                    $tableGateway = $sm->get('GuideTableGateway');
                    $table = new GuideTable($tableGateway);
                    return $table;
                },
                'LanguageTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new Language());
                    return new TableGateway('languages', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\LanguageTable' => function ($sm) {
                    $tableGateway = $sm->get('LanguageTableGateway');
                    $table = new LanguageTable($tableGateway);
                    return $table;
                },
                'AccommodationTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new Accommodation());
                    return new TableGateway('accommodations', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\AccommodationTable' => function ($sm) {
                    $tableGateway = $sm->get('AccommodationTableGateway');
                    $table = new AccommodationTable($tableGateway);
                    return $table;
                },
                'ForgotPasswordTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new ForgotPassword());
                    return new TableGateway('forgot_password', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\ForgotPasswordTable' => function ($sm) {
                    $tableGateway = $sm->get('ForgotPasswordTableGateway');
                    $table = new ForgotPasswordTable($tableGateway);
                    return $table;
                },
                'GuideReviewTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new GuideReview());
                    return new TableGateway('guide_review', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\GuideReviewTable' => function ($sm) {
                    $tableGateway = $sm->get('GuideReviewTableGateway');
                    $table = new GuideReviewTable($tableGateway);
                    return $table;
                },
                'TrailReviewTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new TrailReview());
                    return new TableGateway('trail_review', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\TrailReviewTable' => function ($sm) {
                    $tableGateway = $sm->get('TrailReviewTableGateway');
                    $table = new TrailReviewTable($tableGateway);
                    return $table;
                },
                'UserTokenTableGateway' => function ($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $resultSetPrototype = new ResultSet();
                    $resultSetPrototype->setArrayObjectPrototype(new UserToken());
                    return new TableGateway('user_tokens', $dbAdapter, null, $resultSetPrototype);
                },
                'Application\Model\UserTokenTable' => function ($sm) {
                    $tableGateway = $sm->get('UserTokenTableGateway');
                    $table = new UserTokenTable($tableGateway);
                    return $table;
                },
            ),
        );
    }
}
