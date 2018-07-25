<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 3/1/13
 * Time: 11:16 AM
 * To change this template use File | Settings | File Templates.
 */

namespace Application\Form;

use Zend\Form\Form;

class ForgotPasswordForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('student-auth');
        $this->setAttribute('method','post');

        $this->add(array(
            'name' => 'New Password',
            'attributes' => array(
                'type'  => 'text',
            ),
        ));



        $this->add(array(
            'name' => 'submit',
            'attributes' => array(
                'type'  => 'submit',
                'value' => 'Change',
                'id' => 'submit',
                'class'=>'btn btn-success'
            ),
        ));

    }
}