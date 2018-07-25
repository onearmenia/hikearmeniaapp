<?php

namespace Application\Model;

class Accommodation extends AbstractModel
{
    const TABLE_PREFIX ="acc_";
    protected $id;
    protected $name;
    protected $phone;
    protected $price;
    protected $email;
    protected $description;
    protected $facilities;
    protected $url;
    protected $cover;
    protected $status;
    protected $map_image='';
    protected $lat;
    protected $long;
}