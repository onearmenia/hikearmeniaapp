<?php
/**
 * Created by JetBrains PhpStorm.
 * User: hrayr
 * Date: 2/26/13
 * Time: 6:07 PM
 * To change this template use File | Settings | File Templates.
 */

namespace Application\Custom;

use Zend\Mvc\Router;

class Translator
{

    protected $lang;

    public function __construct($lang = false)
    {
        $this->lang = $lang;
    }

    public $messages = array(
        "" => array("fr" => "", "en" => ""),
        "booking_success_message" => array(
            "en" => "Your booking has been sent. We will contact you shortly.",
            "ru" => "Ваше бронирование отправлено. Мы скоро с вами свяжемся."
        ),
    );

    protected function getLang()
    {
        if(!$this->lang) {
            $request = explode("/", $_SERVER['REQUEST_URI']);
            if(array_key_exists(1, $request) AND ($request[1] == "fr" || $request[1] == "en")) {
                $this->lang = $request[1];
            } else {
                $this->lang = "fr";
            }
        }

        return $this->lang;
    }

    public function getErrorMessage($key = false)
    {
        if(array_key_exists($key, $this->messages)) {
            return $this->messages[$key][$this->getLang()];
        }
        return $key;
    }

    public function getPlaceholderMessage($key = false)
    {
        if(array_key_exists($key, $this->placeholders)) {
            return $this->placeholders[$key][$this->getLang()];
        }
        return $key;
    }

}