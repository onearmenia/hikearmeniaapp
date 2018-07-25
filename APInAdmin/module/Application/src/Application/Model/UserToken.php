<?php

namespace Application\Model;

class UserToken extends AbstractModel
{
    const TABLE_PREFIX ="ut_";
    protected $id;
    protected $user_id;
    protected $token_id;
    protected $udid;
}