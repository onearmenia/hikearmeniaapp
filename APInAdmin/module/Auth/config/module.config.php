<?php

return array(
    'controllers' => array(
        'invokables' => array(
            'Auth\Controller\Auth' => 'Auth\Controller\AuthController',
            'Auth\Controller\AuthAction' => 'Auth\Controller\AuthActionController',
        ),
    ),

    'router' => array(
        'routes' => array(
            'auth' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/user[/:action[/:id]]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Auth\Controller\Auth',
                        'action' => 'index',
                    ),
                ),
            ),
            'auth-action' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/auth-action[/:action[/:id]]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                    ),
                    'defaults' => array(
                        'controller' => 'Auth\Controller\AuthAction',
                        'action' => 'index',
                    ),
                ),
            ),
            'fbauth' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/user/fbauth/[:url]',
                    'defaults' => array(
                        'controller' => 'Auth\Controller\Auth',
                        'action' => 'fbauth',
                        'url' => '',
                    ),
                ),
            ),
            'auth-login' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/login',
                    'constraints' => array(
                        'id' => '[a-z]{2}',
                    ),
                    'defaults' => array(
                        'controller' => 'Auth\Controller\Auth',
                        'action' => 'login',
                    ),
                ),
            ),
            'auth-register' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/register',
                    'constraints' => array(
                        'id' => '[a-z]{2}',
                    ),
                    'defaults' => array(
                        'controller' => 'Auth\Controller\Auth',
                        'action' => 'register',
                    ),
                ),
            ),
        ),
    ),
    'view_manager' => array(
        'template_path_stack' => array(
            'auth' => __DIR__ . '/../view',
        ),
    ),
);