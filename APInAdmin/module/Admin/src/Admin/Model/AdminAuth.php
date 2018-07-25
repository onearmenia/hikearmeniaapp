<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:07 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Admin\Model;

use Zend\InputFilter\Factory as InputFactory;
use Zend\InputFilter\InputFilter;
use Zend\InputFilter\InputFilterAwareInterface;
use Zend\InputFilter\InputFilterInterface;

class AdminAuth implements InputFilterAwareInterface
{
    protected $admin_id;
    protected $username;
    protected $email;
    protected $password;
    protected $inputFilter;

    public function exchangeArray($data)
    {
        foreach($data as $k => $v) {
            if(property_exists($this,$k)) {
                switch ($k) {
                    case 'user_id':
                        $this->setId($v);
                        break;
                    case 'name':
                        $this->setUsername($v);
                        break;
                    case 'email':
                        $this->setEmail($v);
                        break;
                    case 'password':
                        $this->setPassword($v);
                        break;
                }
            }
        }
    }

    public function getArrayCopy()
    {
        $arr = array(
            'name' => $this->getUsername(),
            'password' => $this->getPassword(),
        );
        if($this->getId()) {
            $arr['user_id'] = $this->getId();
        }
        return $arr;
    }

    public function getArrayCopyForInsert()
    {
        $arr = array(
            'email' => $this->getEmail(),
            'password' => $this->getPassword(),
        );
        return $arr;
    }

    public function setInputFilter(InputFilterInterface $inputFilter)
    {
        throw new \Exception("Not used");
    }

    public function getInputFilter()
    {
        if (!$this->inputFilter) {
            $inputFilter = new InputFilter();
            $factory = new InputFactory();

        }
        return $this->inputFilter;
    }

    public function getId()
    {
        return $this->admin_id;
    }

    public function setId($id)
    {
        $this->admin_id = $id;
        return $this;
    }

    public function getUsername()
    {
        return $this->username;
    }

    public function setUsername($name)
    {
        $this->username = $name;
        return $this;
    }

    public function getPassword()
    {
        return $this->password;
    }

    public function setPassword($password)
    {
        $this->password = $password;
        return $this;
    }

    public function getEmail()
    {
        return $this->email;
    }

    public function setEmail($v)
    {
        $this->email = $v;
        return $this;
    }

}