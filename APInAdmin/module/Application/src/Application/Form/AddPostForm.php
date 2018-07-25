<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 7:05 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Application\Form;

use Zend\Form\Form;
use Zend\Form\Element;
use Application\Custom\Translator as CustomTranslator;

class AddPostForm extends Form
{
    public function __construct($name=null)
    {
        parent::__construct('add-post');
        $this->setAttribute('method','post');
        $translator = new CustomTranslator();

        foreach (array("am", "ru", "en") as $lang) {
            $this->add(array(
                'name'=>'post_title_' . $lang,
                'attributes'=>array(
                    'type'=>'text',
                ),
            ));
            $this->add(array(
                'name'=>'post_description_' . $lang,
                'attributes'=>array(
                    'type'=>'text',
                ),
            ));
            $this->add(array(
                'name'=>'post_body_' . $lang,
                'attributes'=>array(
                    'type'=>'text',
                ),
            ));
        }
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