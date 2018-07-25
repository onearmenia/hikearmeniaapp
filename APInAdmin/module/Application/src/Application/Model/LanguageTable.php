<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class LanguageTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\Language';
    protected $postType = 'lang';
    protected $tablePrefix = 'lang';
    protected $_id = 'lang_id';

    public function findGuideLanguages($guide_id)
    {
        $languages = array();
        $query = "SELECT languages.lang_id, languages.lang_code,languages.lang_img FROM rel_guide_language LEFT JOIN languages ON rel_guide_language.rgl_language_id=languages.lang_id
                        WHERE rel_guide_language.rgl_guide_id={$guide_id}";
        $langResult = $this->adapter->query($query)->execute();
        while ($langResult->current()) {
            $languages[] = new Language($langResult->current());
            $langResult->next();
        }
        return $languages;
    }

    public function removeGuideLanguages($guide_id)
    {
        $query = "DELETE FROM rel_guide_language WHERE rgl_guide_id=$guide_id";
        $this->adapter->query($query)->execute();
    }
    public function addGuideLanguage($guide_id,$lang_id){
        $query= "INSERT INTO `rel_guide_language`
                 (`rgl_guide_id`, `rgl_language_id`) VALUES ($guide_id, $lang_id)";
        $this->adapter->query($query)->execute();
    }
}
