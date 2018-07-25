<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 3/1/13
 * Time: 11:16 AM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth\Form;

use Zend\Form\Form;

class AuthForgotForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('auth');
        $this->setAttribute('method','post');

        $this->add(array(
            'name' => 'user_email',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));

    }
}