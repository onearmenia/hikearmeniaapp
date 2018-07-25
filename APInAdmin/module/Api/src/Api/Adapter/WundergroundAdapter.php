<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:07 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Api\Adapter;
class WundergroundAdapter
{
    static $url = 'http://api.wunderground.com/api/';
    static $apiKey='2e48df0b7b48659f';
    private static $_instance = null;
    private $model = '';
    private function __construct($model)
    {
        $this->model = $model;
    }
    public static function getInstance($model)
    {
        if (self::$_instance === null) {
           return self::$_instance = new self($model);
        }
        self::$_instance->model=$model;
        return self::$_instance;
    }

    public function getGeoLookupData($lat,$long){
        $data = $this->makeRequest('/geolookup/q/'.$lat.','.$long.'.json');
        if($data['location']){
            return $data['location']['city'];
        }
        return false;
    }
    public function getHourlyForecast($lat,$long){
        $location = $this->getGeoLookupData($lat,$long);
        return $this->makeRequest('/hourly/q/'.$location.'.json');
    }
    private function makeRequest($request){
        $ch = curl_init(self::$url.self::$apiKey.$request);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch,CURLOPT_SSL_VERIFYPEER,false);
        curl_setopt($ch,CURLOPT_HEADER, false);
        curl_setopt($ch,CURLOPT_PORT,80);
        $result = curl_exec($ch);
        $array = json_decode($result,true);

        return $array;
    }
    private function returnModel($results){
        if(isset($results[0])&&is_array($results[0])){
            foreach ($results AS $key=>$result){
                $results[$key] = new $this->model($result);
            }
            return $results;
        }
        return new $this->model($results);
    }

}