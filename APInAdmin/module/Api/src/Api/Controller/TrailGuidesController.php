<?php
namespace Api\Controller;

use Zend\Mvc\Application;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Application\Custom\XmlParser;
class TrailGuidesController extends AbstractController
{
    public function get($id)
    {

        $data = $this->getRequest()->getQuery()->toArray();
        if(!isset($data['language'])){
            $lang='';
        }
        else{
            $lang=$data['language'];
        }
       $guides=$this->getGuideTable()->getTrailGuides($id,$lang);

        return new JsonModel(array("result" => $guides));
    }


    public function delete($id)
    {
        # code...
    }

}