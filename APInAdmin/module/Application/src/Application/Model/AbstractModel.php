<?php

namespace Application\Model;

abstract class AbstractModel
{
    protected function getTablePrefix()
    {
        $reflect = new \ReflectionClass($this);
        $className = $reflect->getName();
        return $className::TABLE_PREFIX;

    }

    public static function lowerFirstLetter($str)
    {
        preg_match_all('!([A-Z][A-Z0-9]*(?=$|[A-Z][a-z0-9])|[A-Za-z][a-z0-9]+)!', $str, $matches);
        $ret = $matches[0];
        foreach ($ret as &$match) {
            $match = $match == strtoupper($match) ? strtolower($match) : lcfirst($match);
        }
        return implode('_', $ret);
    }

    public function __construct(array $data = array())
    {
        $this->exchangeArray($data);
    }

    public function exchangeArray(array $data)
    {
        $prefix = $this->getTablePrefix();
        foreach ($data as $k => $v) {
            if($v==null){
                $v='';
            }
            if (property_exists($this, str_replace($prefix, '', $k))) {
                $this->__set(str_replace($prefix, '', $k), $v);
            }
        }
    }

    public function __set($key, $val)
    {
        $this->$key = $val;
    }

    public function __call($name, $arguments)
    {
        $type = substr($name, 0, 3);
        $fieldName = self::lowerFirstLetter(substr($name, 3));

        if ($type == 'set') {
            if (count($arguments) == 1) {
                $this->$fieldName = $arguments[0];
            } else {
                $this->$fieldName = $arguments;
            }
        } else if ($type == 'get') {
            if (isset($this->$fieldName)) {

                return $this->$fieldName;
            }
            //else if (isset())
            return null;
        }
    }

    public function getArrayCopy()
    {
        $tablePrefix = $this->getTablePrefix();
        $properties = get_object_vars($this);
        foreach ($properties AS $key => $value) {
            if (is_array($properties[$key])) {
                unset($properties[$key]);
            }
        }
        $arr = array();
        foreach ($properties AS $key => $value) {
            $getter = 'get' . ucfirst($key);
            $arr[$tablePrefix . $key] = $this->$getter();
        }
        if ($this->getId()) {
            $arr[$tablePrefix . 'id'] = $this->getId();
        }

        return $arr;
    }
    public function getJsonArray(){
        return $this->getArrayCopy();
    }
}