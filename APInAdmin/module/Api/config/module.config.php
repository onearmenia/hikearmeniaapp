<?php
return array(
    'controllers' => array(
        'invokables' => array(
            'Api\Controller\User' => 'Api\Controller\UserController',
            'Api\Controller\Login' => 'Api\Controller\LoginController',
            'Api\Controller\Register' => 'Api\Controller\RegisterController',
            'Api\Controller\ForgotPassword' => 'Api\Controller\ForgotPasswordController',
            'Api\Controller\ChangePassword' => 'Api\Controller\ChangePasswordController',
            'Api\Controller\Logout' => 'Api\Controller\LogoutController',
            'Api\Controller\Trail' => 'Api\Controller\TrailController',
            'Api\Controller\UserTrail' => 'Api\Controller\UserTrailController',
            'Api\Controller\SavedTrails' => 'Api\Controller\SavedTrailsController',
            'Api\Controller\Guide' => 'Api\Controller\GuideController',
            'Api\Controller\TrailReview' => 'Api\Controller\TrailReviewController',
            'Api\Controller\GuideReview' => 'Api\Controller\GuideReviewController',
            'Api\Controller\TrailGuides' => 'Api\Controller\TrailGuidesController',

        ),
    ),

    'router' => array(
        'routes' => array(
            'api' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api[/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                    ),

                ),
            ),
            'user' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/user[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\User',
                    ),
                ),
            ),
            'login' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/login',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\Login',
                    ),
                ),
            ),
            'register' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/register',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\Register',
                    ),
                ),
            ),
            'change-password' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/change-password',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\ChangePassword',
                    ),
                ),
            ),
            'logout' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/logout',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\Logout',
                    ),
                ),
            ),
            '/api/forgot-password' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/forgot-password',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\ForgotPassword',
                    ),
                ),
            ),
            'trails' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/trails[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\Trail',
                    ),
                ),
            ),
            'usertrails' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/user-trails[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\UserTrail',
                    ),
                ),
            ),
            'trail-guides' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/trail-guides[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\TrailGuides',
                    ),
                ),
            ),
            'saved-trails' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/saved-trails[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\SavedTrails',
                    ),
                ),
            ),
            'trail-review' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/trail-review[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\TrailReview',
                    ),
                ),
            ),
            'guide-review' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/guide-review[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\GuideReview',
                    ),
                ),
            ),
            'guide' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/api/guide[/:id]',
                    'constraints' => array(
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Api\Controller\Guide',
                    ),
                ),
            ),
        ),
    ),
    /*'view_manager' => array(
        'template_path_stack' => array(
            'api' => __DIR__ . '/../view',
        ),
        'template_map' => array(
            'layout/layout' => __DIR__ . '/../view/layout/layout.phtml',
        ),
    ),*/
);