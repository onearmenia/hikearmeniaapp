<?php

namespace Application\Model;

use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class GuideTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\Guide';
    protected $postType = 'guide';
    protected $tablePrefix = 'guide';
    protected $_id = 'guide_id';

    public function findGuides($lang = '')
    {
        $query = "SELECT
                    guides.* ,
                  guides.guide_rating_count AS review_count,
                  guides.guide_rating as average_rating
                  FROM guides
                  LEFT JOIN rel_guide_language on rel_guide_language.rgl_guide_id = guides.guide_id
                  LEFT JOIN languages ON languages.lang_id = rel_guide_language.rgl_language_id
                  WHERE guides.guide_status='active'
                  ORDER BY FIELD(lang_code,'$lang') DESC, average_rating DESC , guide_id";

        $result = $this->adapter->query($query)->execute();
        $returnData = array();
        if ($result->count()) {
            while ($result->current()) {
                $returnData[] = $result->current();
                $languages = array();
                $query = "SELECT languages.lang_code,languages.lang_img FROM rel_guide_language LEFT JOIN languages ON rel_guide_language.rgl_language_id=languages.lang_id
                        WHERE rel_guide_language.rgl_guide_id={$result->current()['guide_id']}";
                $langResult = $this->adapter->query($query)->execute();
                while ($langResult->current()) {
                    $languages[] = $langResult->current();
                    $langResult->next();
                }
                $returnData[count($returnData) - 1]['languages'] = $languages;
                $result->next();
            }
        }
        $returnData = $this->unique_multidim_array($returnData, 'guide_id');
        return $returnData;
    }

    public function findGuide($guide_id)
    {
        $query = "SELECT
                  guides.* ,
                 guides.guide_rating_count AS review_count,
                  guides.guide_rating as average_rating
                  FROM guides
                  LEFT JOIN guide_review ON guides.guide_id = guide_review.gr_guide_id
                  WHERE guides.guide_status='active' AND guides.guide_id=$guide_id
                  GROUP BY guides.guide_id";
        $result = $this->adapter->query($query)->execute();

        if ($result->count()) {
            $returnData = $result->current();
            $languages = array();
            $query = "SELECT languages.lang_code,languages.lang_img FROM rel_guide_language LEFT JOIN languages ON rel_guide_language.rgl_language_id=languages.lang_id
                        WHERE rel_guide_language.rgl_guide_id={$result->current()['guide_id']}";
            $langResult = $this->adapter->query($query)->execute();
            while ($langResult->current()) {
                $languages[] = $langResult->current();
                $langResult->next();
            }
            $returnData['languages'] = $languages;
        }
        $guideReviews = array();
        $guideReviewQuery = "SELECT guide_review.* ,
                             users.user_first_name,
                             users.user_last_name,
                             users.user_avatar
                              FROM guide_review
                             LEFT JOIN users ON users.user_id=guide_review.gr_user_id
                             WHERE guide_review.gr_guide_id=$guide_id AND guide_review.gr_status='active' ORDER BY CASE WHEN (gr_user_id=200) THEN 0 ELSE 1 END , gr_id ";
        $guideReviewResult = $this->adapter->query($guideReviewQuery)->execute();
        if ($guideReviewResult->count()) {
            while ($guideReviewResult->current()) {
                $guideReviews[] = $guideReviewResult->current();
                $guideReviewResult->next();
            }
        }
        $returnData['reviews'] = $guideReviews;
        return $returnData;
    }

    public function getGuideRating($guide_id)
    {
        $query = "SELECT guide_review.gr_rating AS average_rating
        FROM guide_review WHERE guide_review.gr_guide_id=$guide_id GROUP BY guide_review.gr_guide_id;
        ";
        $result = $this->adapter->query($query)->execute();

        if ($result->count()) {
            return $result->current();
        }
        return array('average_rating' => 0);
    }

    public function getTrailGuideCount($trail_id)
    {
        $query = "SELECT * FROM  rel_trail_guide WHERE rtg_trail_id=$trail_id";
        $rows = $this->adapter->query($query)->execute();
        return $rows->count();
    }

    private function unique_multidim_array($array, $key)
    {
        $temp_array = array();
        $i = 0;
        $key_array = array();

        foreach ($array as $val) {
            if (!in_array($val[$key], $key_array)) {
                $key_array[$i] = $val[$key];
                $temp_array[] = $val;
            }
            $i++;
        }
        return $temp_array;
    }

    public function findGuideTrails($guide_id)
    {
        $query = "SELECT * FROM  rel_trail_guide WHERE rtg_guide_id=$guide_id";
        $rows = $this->adapter->query($query)->execute();
        $returnData = array();
        while ($rows->current()) {
            $returnData[] = $rows->current();
            $rows->next();
        }
        return $returnData;
    }

    public function removeGuideTrails($guide_id)
    {
        $query = "DELETE FROM rel_trail_guide WHERE rtg_guide_id=$guide_id";
        $this->adapter->query($query)->execute();
    }

    public function addGuideTrail($guide_id, $trail_id)
    {
        $query = "INSERT INTO `rel_trail_guide`
                 (`rtg_guide_id`, `rtg_trail_id`) VALUES ($guide_id, $trail_id)";
        $this->adapter->query($query)->execute();
    }

    public function getTrailGuides($trail_id, $lang)
    {
        $guideQuery = "SELECT
                    guides.* ,
                  guides.guide_rating_count AS review_count,
                  guides.guide_rating as average_rating
                  FROM guides
                  LEFT JOIN rel_guide_language on rel_guide_language.rgl_guide_id = guides.guide_id
                  LEFT JOIN languages ON languages.lang_id = rel_guide_language.rgl_language_id
                  LEFT JOIN rel_trail_guide ON guides.guide_id = rel_trail_guide.rtg_guide_id
                  WHERE rel_trail_guide.rtg_trail_id = $trail_id AND guides.guide_status='active'
                  ORDER BY FIELD(lang_code,'$lang') DESC, average_rating DESC
                  ";
        $guideResult = $this->adapter->query($guideQuery)->execute();
        $guides= array();
        if ($guideResult->count()) {
            while ($guideResult->current()) {
                $guides[] = $guideResult->current();
                $languages = array();
                $query = "SELECT languages.lang_code,languages.lang_img FROM rel_guide_language LEFT JOIN languages ON rel_guide_language.rgl_language_id=languages.lang_id
                        WHERE rel_guide_language.rgl_guide_id={$guideResult->current()['guide_id']}";
                $langResult = $this->adapter->query($query)->execute();
                while ($langResult->current()) {
                    $languages[] = $langResult->current();
                    $langResult->next();
                }
                $guides[count($guides) - 1]['languages'] = $languages;
                $guideResult->next();

            }

        }
        $guides = $this->unique_multidim_array($guides, 'guide_id');
        return $guides;
    }
}
