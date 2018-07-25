<?php
namespace Api\Controller;

use Zend\Mvc\Application;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Application\Custom\XmlParser;

class TrailController extends AbstractController
{
    public function getList()
    {
        if (isset(getallheaders()['X_HTTP_AUTH_TOKEN']) && $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN'])) {
            $trails = $this->getTrailTable()->findTrails($user->getId());

        } else {
            $trails = $this->getTrailTable()->findTrails();

        }
        return new JsonModel(array("result" => $trails));
    }

    public function get($id)
    {
        $data = $this->getRequest()->getQuery()->toArray();
        if (!isset($data['language'])) {
            $lang = '';
        } else {
            $lang = $data['language'];
        }
        if (isset(getallheaders()['X_HTTP_AUTH_TOKEN']) && $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN'])) {
            $trail = $this->getTrailTable()->findTrail($id, $user->getId(), $lang);
            $userTrail = $this->getUserTrailTable()->findUserTrail($user->getId(),$trail['trail_id']);
            if((array) $userTrail){
                $trail['user_route'] = $userTrail->getJsonArrayCopy();
            }
            else{
                $trail['user_route']  = $userTrail;
            }
        } else {
            $trail = $this->getTrailTable()->findTrail($id, -1, $lang);
            $trail['user_route']  = (object) null;
        }

        $trail['trail_route'] = array();
        $kmlFile = @simplexml_load_string(@file_get_contents($trail['trail_kml_file']));
        if($kmlFile){
            $coordinates = @(string)$kmlFile->Document->Folder->Folder->Placemark[1]->MultiGeometry->LineString->coordinates;
            if(!$coordinates){
                $coordinates = @(string) $kmlFile->Document->Folder->Placemark->LineString->coordinates;
                if(!$coordinates){
                    foreach ($kmlFile->getNamespaces(true) as $namespace){
                        if(!$coordinates){
                            $kmlFile->registerXPathNamespace('x',$namespace);
                            $lineStrings = $kmlFile->xpath('//x:LineString');
                            foreach($lineStrings as $lineString){
                                $coordinates.= (string)$lineString->coordinates;
                                $coordinates.=' ';
                            }
                        }
                    }
                }
            }
            $coordinates = explode(' ', $coordinates);
            foreach ($coordinates as $coordinate) {
                $coordinate = explode(',', $coordinate);
                $coord = array();
                if (isset($coordinate[1]) && isset($coordinate[0])) {
                    $coord['latitude'] = $coordinate[1];
                    $coord['longitude'] = $coordinate[0];
                    $trail['trail_route'][] = $coord;
                }

            }
        }

        return new JsonModel(array("result" => $trail));
    }
    public function update($id,$data){
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        $trail = $this->getUserTrailTable()->findUserTrail($user->getId(),$id);
        if((array) $trail){
            $trail->setLocation(json_encode($data['location']));
        }
        else{
            $trail = $this->getUserTrailTable()->createNew();
            $trail->setUserId($user->getId());
            $trail->setTrailId($id);
            $trail->setLocation(json_encode($data['location']));
        }
        $this->getUserTrailTable()->save($trail);
        return new JsonModel(array("result" => array("code" => 200, "message" => "Trail Added")));
    }
    public function delete($id)
    {
        # code...
    }

}