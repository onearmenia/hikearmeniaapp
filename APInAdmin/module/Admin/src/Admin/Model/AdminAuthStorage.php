<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 3/20/13
 * Time: 11:59 AM
 * To change this template use File | Settings | File Templates.
 */

namespace Admin\Model;

use Zend\Authentication\Storage;

class AdminAuthStorage extends Storage\Session
{
    public function setRememberMe($rememberMe=0,$time=1209600)
    {
        if($rememberMe==1){
            $this->session->getManager()->rememberMe($time);
        }
    }

    public function forgetMe()
    {
        $this->session->getManager()->forgetMe();
    }
}