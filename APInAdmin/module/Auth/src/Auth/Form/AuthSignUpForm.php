<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 7:05 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth\Form;

use Zend\Form\Form;
use Zend\Form\Element;

class AuthSignUpForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('auth-sign-up');
        $this->setAttribute('method','post');

        $this->add(array(
            'name' => 'user_fname',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));
        $this->add(array(
            'name' => 'user_lname',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));
        $this->add(array(
            'name' => 'user_email',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));
        $this->add(array(
            'name' => 'user_password',
            'attributes' => array(
                'type'  => 'password',
            ),
        ));
        $this->add(array(
            'name' => 'confirm_password',
            'attributes' => array(
                'type'  => 'password',
            ),
        ));
    }
}