<?php

namespace Application\Model;

class UserTrail extends AbstractModel
{
    const TABLE_PREFIX = "ut_";
    protected $id;
    protected $user_id;
    protected $trail_id;
    protected $location;

    public function getJsonArrayCopy()
    {
        return array(
            'id' => $this->id,
            'user_id' => $this->user_id,
            'trail_id' => $this->trail_id,
            'location' => json_decode($this->location, true),
        );
    }
}