<?php

namespace Application\Model;

class Trail extends AbstractModel
{
    const TABLE_PREFIX ="trail_";
    protected $id;
    protected $name;
    protected $difficulty;
    protected $things_to_do;
    protected $information;
    protected $max_height;
    protected $min_height;
    protected $lat_start;
    protected $lat_end;
    protected $long_start;
    protected $long_end;
    protected $kml_file;
    protected $map_image;
    protected $region;
    protected $distance;
    protected $time;
    protected $status;
    protected $guides = array();
    public function getJsonArray(){
        $ratings=array();
        return array(
            'id'=>$this->getId(),
            'name'=>$this->getName(),
            'things_to_do'=>$this->getThingsToDo(),
            'information'=>$this->getInformation(),
            'location_start'=>$this->getLocationStart(),
            'location_end'=>$this->getLocationEnd(),
            'distance'=>$this->getDistance(),
            'time'=>$this->getTime(),
        );
    }
}