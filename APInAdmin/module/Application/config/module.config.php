<?php
return array(
    'controllers' => array(
        'invokables' => array(
            'Application\Controller\Index' => 'Application\Controller\IndexController',
            'Application\Controller\Upload' => 'Application\Controller\UploadController',
            'Application\Controller\Action' => 'Application\Controller\ActionController',
        ),
    ),
    'router' => array(
        'routes' => array(
            'action' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '[/:language]/action[/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                        'language' => '[a-z]{2}',
                    ),
                    'defaults' => array(
                        'controller' => 'Application\Controller\Action',
                        'action' => 'index',
                        'language' => 'am',
                    ),
                ),
            ),
            'upload' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/upload[/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                        'language' => '[a-z]{2}',
                    ),
                    'defaults' => array(
                        'controller' => 'Application\Controller\Upload',
                        'action' => 'index',
                        'language' => 'am',
                    ),
                ),
            ),
            'application' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/[:language][/:action][/:id]',
                    'constraints' => array(
                        'action' => '[a-zA-Z][a-zA-Z0-9_-]*',
                        'id' => '[0-9]+',
                        'language' => '[a-z]{2}',
                    ),
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action' => 'index',
                        'language' => 'am',
                    ),
                ),
            ),
            'forgot-password' => array(
                'type' => 'segment',
                'options' => array(
                    'route' => '/forgot-password[/:id]',
                    'constraints' => array(
                        'id' => '[a-zA-Z0-9_-]*',
                    ),
                    'defaults' => array(
                        'controller' => 'Application\Controller\Index',
                        'action' => 'forgotPassword',
                    ),
                ),
            ),


        ),
    ),

    'service_manager' => array(
        'aliases' => array(
            'translator' => 'MvcTranslator',
        ),
    ),
    'translator' => array(
        'locale' => 'am_AM',
        'translation_file_patterns' => array(
            array(
                'type' => 'gettext',
                'base_dir' => __DIR__ . '/../language',
                'pattern' => '%s.mo',
                'text_domain' => __NAMESPACE__,
            ),
        ),
    ),
    'view_manager' => array(
        'display_not_found_reason' => true,
        'display_exceptions' => true,
        'doctype' => 'HTML5',
        'not_found_template' => 'error/404',
        'exception_template' => 'error/index',
        'template_map' => array(
            'layout/layout' => __DIR__ . '/../view/layout/layout.phtml',
            'error/404' => __DIR__ . '/../view/error/404.phtml',
            'error/index' => __DIR__ . '/../view/error/index.phtml',
            'bookingForm' => __DIR__ . '/../view/email/bookingForm.phtml',
            'contactForm' => __DIR__ . '/../view/email/contactForm.phtml',
        ),
        'template_path_stack' => array(
            __DIR__ . '/../view',
        ),
        'strategies' => array(
            'ViewJsonStrategy',
        ),
    ),
);
