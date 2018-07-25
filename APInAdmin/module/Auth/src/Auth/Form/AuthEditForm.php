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
use Application\Custom\Translator as CustomTranslator;

class AuthEditForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('edit');
        $this->setAttribute('method','post');
        $translator = new CustomTranslator();


        $this->add(array(
            'name'=>'user_id',
            'attributes'=>array(
                'type'=>'hidden',
            ),
        ));

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
                'id' => 'password',
            ),
        ));
        $this->add(array(
            'name' => 'password_confirm',
            'attributes' => array(
                'type'  => 'password',
                'id' => 'password_confirm',
            ),
        ));
        $this->add(array(
            'name' => 'submit',
            'attributes' => array(
                'type'  => 'submit',
                'value' => $translator->getErrorMessage("Save"),
                'id'    => 'ajaxFormSubmit',
                'class' => 'btn btn-info ajaxFormSubmit'
            ),
        ));
    }

    public function populateValues($data)
    {
        foreach($data as $key=>$row)
        {
            if (is_array(@json_decode($row))){
                $data[$key] =   new \ArrayObject(\Zend\Json\Json::decode($row), \ArrayObject::ARRAY_AS_PROPS);
            }
        }

        parent::populateValues($data);
    }
}