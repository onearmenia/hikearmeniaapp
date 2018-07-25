<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:07 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Auth\Model;

use Zend\InputFilter\Factory as InputFactory;
use Zend\InputFilter\InputFilter;
use Zend\InputFilter\InputFilterAwareInterface;
use Zend\InputFilter\InputFilterInterface;
use Application\Model\AbstractModel;
use Application\Custom\Translator as CustomTranslator;
use Application\Custom\HashGenerator;
use Application\Custom\FrDate;

class Auth implements InputFilterAwareInterface
{
    protected $user_id;
    protected $user_fname;
    protected $user_lname;
    protected $user_email;
    protected $user_password;
    protected $user_created_date;
    protected $user_hash; // for activation link and other actions
    protected $user_role = 'user';
    protected $user_status = 'pending';
    protected $user_avatar = '/images/user_default_avatar.jpg';
    protected $user_fb_id;
    protected $inputFilter;

    public function __construct(array $data = array())
    {
        $this->exchangeArray($data);
    }

    public function exchangeArray(array $data)
    {
        foreach ($data as $k => $v) {
            if (property_exists($this, $k)) {
                $this->__set($k, $v);
            }
        }
    }

    public function __set($key, $val)
    {
        $this->$key = $val;
    }

    public function getArrayCopy()
    {
        $arr = array(
            'user_fname' => $this->getFirstname(),
            'user_lname' => $this->getLastname(),
            'user_email' => $this->getEmail(),
            'user_password' => $this->getPassword(),
            'user_avatar' => $this->getAvatar(),
            'user_fb_id' => $this->getFbId(),
            'user_hash' => $this->getHash(),
            'user_status' => $this->getStatus(),
        );
        if($this->getId()) {
            $arr['user_id'] = $this->getId();
        }
        return $arr;
    }

    public function getArrayCopyForInsert()
    {
        $arr = array(
            'user_fname' => $this->getFirstname(),
            'user_lname' => $this->getLastname(),
            'user_email' => $this->getEmail(),
            'user_password' => $this->getPassword(),
            'user_avatar' => $this->getAvatar(),
            'user_fb_id' => $this->getFbId(),
            'user_hash' => $this->getHash(),
            'user_status' => $this->getStatus(),
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
            $factory     = new InputFactory();
            $translator = new CustomTranslator();

            $inputFilter->add($factory->createInput(array(
                'name'     => 'user_fname',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("First name is required")
                            ),
                        ),
                    ),
                 ),
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'user_lname',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Last name is required")
                            ),
                        ),
                    ),
                ),
            )));

            $inputFilter->add($factory->createInput(array(
                'name' => 'user_password',
                'required' => true,
                'filters' => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Password is required")
                            ),
                        ),
                    ),
                    array(
                        'name' => 'StringLength',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min' => 4,
                            'max' => 20,
                            'messages' => array(
                                'stringLengthTooShort' => $translator->getErrorMessage("Please enter Password between 4 to 20 character"),
                                'stringLengthTooLong' => $translator->getErrorMessage("Please enter Password between 4 to 20 character")
                            ),
                        ),
                    ),
                ),
            )));

            $inputFilter->add($factory->createInput(array(
                'name' => 'confirm_password',
                'required' => true,
                'filters' => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Confirm password is required")
                            ),
                        ),
                    ),
                    array(
                        'name' => 'Identical',
                        'options' => array(
                            'token' => 'user_password',
                            'messages' => array(
                                \Zend\Validator\Identical::NOT_SAME => $translator->getErrorMessage("Confirm password does not match")
                            ),
                        ),
                    ),
                ),
            ) ));

            $inputFilter->add($factory->createInput(array(
                'name'     => 'user_email',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Email is required")
                            ),
                        ),
                    ),
                    array(
                        'name'    => 'EmailAddress',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min'      => 1,
                            'max'      => 100,
                            'messages' => array(
                                \Zend\Validator\EmailAddress::INVALID => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_FORMAT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_HOSTNAME => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_MX_RECORD => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_SEGMENT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::DOT_ATOM => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::QUOTED_STRING => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_LOCAL_PART => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::LENGTH_EXCEEDED => $translator->getErrorMessage("Invalid Email"),
                            ),
                        ),
                    ),
                ),
            )));

            $this->inputFilter = $inputFilter;
        }
        return $this->inputFilter;
    }

    public function getSignInFilter()
    {
        if (!$this->inputFilter) {
            $inputFilter = new InputFilter();
            $factory     = new InputFactory();
            $translator = new CustomTranslator();

            $inputFilter->add($factory->createInput(array(
                'name' => 'user_password',
                'required' => true,
                'filters' => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Password is required")
                            ),
                        ),
                    ),
                ),
            )));

            $inputFilter->add($factory->createInput(array(
                'name'     => 'user_email',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Email is required")
                            ),
                        ),
                    ),
                ),
            )));

            $this->inputFilter = $inputFilter;
        }
        return $this->inputFilter;
    }

    public function getInputFilterForEdit()
    {
        if (!$this->inputFilter) {
            $inputFilter = new InputFilter();
            $factory     = new InputFactory();
            $translator = new CustomTranslator();

            $inputFilter->add($factory->createInput(array(
                'name'     => 'id',
                'required' => true,
                'filters'  => array(
                    array('name' => 'Int'),
                ),
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'firstname',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("First name is required."),
                            ),
                        ),
                    ),
                    array(
                        'name'    => 'StringLength',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min'      => 1,
                            'max'      => 100,
                        ),
                    ),
                ),
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'lastname',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Last name is required"),
                            ),
                        ),
                    ),
                    array(
                        'name'    => 'StringLength',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min'      => 1,
                            'max'      => 100,
                        ),
                    ),
                ),
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'address1',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Address 1 is required"),
                            ),
                        ),
                    ),
                )
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'city',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("City is required"),
                            ),
                        ),
                    ),
                )
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'region_id',
                'required' => true,
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Region is required"),
                            ),
                        ),
                    ),
                )
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'region2_id',
                'required' => false,
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'country',
                'required' => true,
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Country is required"),
                            ),
                        ),
                    ),
                )
            )));
            $inputFilter->add($factory->createInput(array(
                'name'     => 'zip',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Zip code is required"),
                            ),
                        ),
                    ),
                )
            )));

            $inputFilter->add($factory->createInput(array(
                'name'     => 'email',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Email is required"),
                            ),
                        ),
                    ),
                    array(
                        'name'    => 'EmailAddress',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min'      => 1,
                            'max'      => 100,
                            'messages' => array(
                                \Zend\Validator\EmailAddress::INVALID => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_FORMAT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_HOSTNAME => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_MX_RECORD => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_SEGMENT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::DOT_ATOM => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::QUOTED_STRING => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_LOCAL_PART => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::LENGTH_EXCEEDED => $translator->getErrorMessage("Invalid Email"),
                            ),
                        ),
                    ),
                ),
            )));

            $inputFilter->add($factory->createInput(array(
                'name'     => 'email_confirm',
                'required' => true,
                'filters'  => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' => 'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Email confirm is required"),
                            ),
                        ),
                    ),
                    array(
                        'name'    => 'EmailAddress',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min'      => 1,
                            'max'      => 100,
                            'messages' => array(
                                \Zend\Validator\EmailAddress::INVALID => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_FORMAT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_HOSTNAME => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_MX_RECORD => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_SEGMENT => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::DOT_ATOM => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::QUOTED_STRING => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::INVALID_LOCAL_PART => $translator->getErrorMessage("Invalid Email"),
                                \Zend\Validator\EmailAddress::LENGTH_EXCEEDED => $translator->getErrorMessage("Invalid Email"),
                            ),
                        ),
                    ),
                    array(
                        'name' => 'Identical',
                        'options' => array(
                            'token' => 'email',
                            'messages' => array(
                                \Zend\Validator\Identical::NOT_SAME => $translator->getErrorMessage("Confirm email does not match")
                            ),
                        ),
                    ),
                ),
            )));
            $inputFilter->add($factory->createInput(array(
                'name' => 'password',
                'required' => true,
                'filters' => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Password is required")
                            ),
                        ),
                    ),
                    array(
                        'name' => 'StringLength',
                        'options' => array(
                            'encoding' => 'UTF-8',
                            'min' => 4,
                            'max' => 20,
                            'messages' => array(
                                'stringLengthTooShort' => $translator->getErrorMessage("Please enter Password between 4 to 20 character"),
                                'stringLengthTooLong' => $translator->getErrorMessage("Please enter Password between 4 to 20 character"),
                            ),
                        ),
                    ),
                ),
            ) ));

            $inputFilter->add($factory->createInput(array(
                'name' => 'password_confirm',
                'required' => true,
                'filters' => array(
                    array('name' => 'StripTags'),
                    array('name' => 'StringTrim'),
                ),
                'validators' => array(
                    array(
                        'name' =>'NotEmpty',
                        'options' => array(
                            'messages' => array(
                                \Zend\Validator\NotEmpty::IS_EMPTY => $translator->getErrorMessage("Confirm password is required")
                            ),
                        ),
                    ),
                    array(
                        'name' => 'Identical',
                        'options' => array(
                            'token' => 'password',
                            'messages' => array(
                                \Zend\Validator\Identical::NOT_SAME => $translator->getErrorMessage("Confirm password does not match")
                            ),
                        ),
                    ),
                ),
            ) ));

            $this->inputFilter = $inputFilter;
        }
        return $this->inputFilter;
    }

    public function getId()
    {
        return $this->user_id;
    }

    public function setId($v)
    {
        $this->user_id = $v;
        return $this;
    }

    public function getFirstName()
    {
        return $this->user_fname;
    }

    public function setFirstName($v)
    {
        $this->user_fname = $v;
        return $this;
    }

    public function getLastName()
    {
        return $this->user_lname;
    }

    public function setLastName($v)
    {
        $this->user_lname = $v;
        return $this;
    }

    public function getEmail()
    {
        return $this->user_email;
    }

    public function setEmail($v)
    {
        $this->user_email = $v;
        return $this;
    }

    public function getPassword()
    {
        return $this->user_password;
    }

    public function setPassword($v)
    {
        $this->user_password = $v;
        return $this;
    }

    public function getCreatedDate($format = false)
    {
        if($format) {
            return date($format, $this->user_created_date);
        }
        return $this->user_created_date;
    }

    public function setCreatedDate($v)
    {
        $this->user_created_date = $v;
        return $this;
    }

    public function getFbId()
    {
        return $this->user_fb_id;
    }

    public function setFbId($v)
    {
        $this->user_fb_id = $v;
        return $this;
    }

    public function setAvatar($v)
    {
        $this->user_avatar = $v;
        return $this;
    }

    public function getAvatar()
    {
        return $this->user_avatar;
    }

    public function setHash($v)
    {
        $this->user_hash = $v;
        return $this;
    }

    public function getHash()
    {
        return $this->user_hash;
    }

    public function setStatus($v)
    {
        $this->user_status = $v;
        return $this;
    }

    public function getStatus()
    {
        return $this->user_status;
    }

    public function getFullName()
    {
        return $this->user_fname." ".$this->user_lname;
    }

    public function getRole()
    {
        return $this->user_role;
    }

    public function setRole($v)
    {
        $this->user_role = $v;
        return $this;
    }

}