<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 3/1/13
 * Time: 11:16 AM
 * To change this template use File | Settings | File Templates.
 */

namespace Admin\Form;

use Zend\Form\Form;

class AdminAuthLoginForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('admin-auth');
        $this->setAttribute('method','post');

        $this->add(array(
            'name' => 'email',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));

        $this->add(array(
            'name' => 'password',
            'attributes' => array(
                'type'  => 'password',
            ),
        ));

        $this->add(array(
            'name' => 'submit',
            'attributes' => array(
                'type'  => 'submit',
                'value' => 'Login',
                'id' => 'submit',
                'class'=>'btn btn-success'
            ),
        ));

    }
}