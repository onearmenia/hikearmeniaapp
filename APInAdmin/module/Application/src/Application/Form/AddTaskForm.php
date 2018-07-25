<?php
/**
 * Created by PhpStorm.
 * User: Aram
 * Date: 06.02.2015
 * Time: 11:54
 */

namespace Application\Form;

use Zend\Form\Form;
use Zend\Form\Element;
use Application\Custom\Translator as CustomTranslator;

class AddTaskForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('add-task');
        $this->setAttribute('method','post');
        $translator = new CustomTranslator();
        
        $this->add(array(
            'name'=>'cat_title',
            'attributes'=>array(
                'type'=>'text',
            ),
        ));
        $this->add(array(
            'name'=>'cat_description',
            'attributes'=>array(
                'type'=>'text',
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