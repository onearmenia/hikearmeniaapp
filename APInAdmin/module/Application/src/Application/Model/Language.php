<?php

namespace Application\Model;

class Language extends AbstractModel
{
    const TABLE_PREFIX ="lang_";
    protected $id;
    protected $code;
    protected $img;
    protected $name;
}