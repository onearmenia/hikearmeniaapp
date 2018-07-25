<?php

namespace Application\Model;

use Aws\CloudFront\Exception\Exception;
use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Adapter\Adapter;

use Application\Custom\HashGenerator;

class TrailTable extends AbstractTable
{
    protected $tableGateway;
    protected $adapter;
    protected $model = 'Application\Model\Trail';
    protected $postType = 'trail';
    protected $tablePrefix = 'trail';
    protected $_id = 'trail_id';

    public function findSavedTrails($user_id)
    {
        $query = "SELECT * FROM rel_user_saved_trails WHERE rust_user_id=$user_id";
        $result = $this->adapter->query($query)->execute();
        $returnData = array();
        if ($result->count()) {
            while ($result->current()) {
                $returnData[] = $this->find($result->current());
                $result->next();
            }
        }
        return $returnData;
    }

    public function findTrails($user_id = -1)
    {


        $query = "SELECT trails.* ,
                CASE WHEN
                rel_user_saved_trails.rust_trail_id IS NOT NULL THEN 1 ELSE 0 END AS is_saved,
                AVG(case
                        when trail_review.tr_rating = 0 then null
                        else trail_review.tr_rating
                        end
                          ) AS average_rating,
                COUNT(trail_review.tr_rating) AS review_count
                FROM trails
                LEFT JOIN rel_user_saved_trails ON rel_user_saved_trails.rust_trail_id = trails.trail_id
                AND rel_user_saved_trails.rust_user_id=$user_id
                LEFT JOIN trail_review ON trails.trail_id = trail_review.tr_trail_id AND trail_review.tr_status='active'

                WHERE trails.trail_status='active'
                GROUP BY trails.trail_id";
        $result = $this->adapter->query($query)->execute();
        $returnData = array();
        if ($result->count()) {
            while ($result->current()) {
                $row = $result->current();
                $query = "SELECT trail_covers.* FROM trail_covers WHERE tc_trail_id=" . $row['trail_id'];
                $row['trail_covers'] = array();
                $trail_covers = $this->adapter->query($query)->execute();
                if ($trail_covers->current()) {
                    $row['trail_cover'] = $trail_covers->current()['tc_cover'];
                }
                while ($trail_covers->current()) {
                    $row['trail_cover'] = $trail_covers->current()['tc_cover'];
                    $trail_covers->next();
                }
                $returnData[] = $row;
                $result->next();
            }
        }
        return $returnData;
    }

    public function findTrail($trail_id, $user_id = -1, $lang = '')
    {
        $trailQuery = "SELECT trails.* ,
                CASE WHEN
                rel_user_saved_trails.rust_trail_id IS NOT NULL THEN 1 ELSE 0 END AS is_saved,
                AVG(case
                        when trail_review.tr_rating = 0 then null
                        else trail_review.tr_rating
                        end) AS average_rating,
                COUNT(trail_review.tr_rating) AS review_count
                FROM trails
                LEFT JOIN rel_user_saved_trails ON rel_user_saved_trails.rust_trail_id = trails.trail_id
                AND rel_user_saved_trails.rust_user_id=$user_id
                LEFT JOIN trail_review ON trails.trail_id = trail_review.tr_trail_id AND trail_review.tr_status='active'

                WHERE trails.trail_status='active' AND trails.trail_id=$trail_id
                GROUP BY trails.trail_id";
        $trailResult = $this->adapter->query($trailQuery)->execute();

        $guides = array();
        $accommodations = array();
        $trailReviews = array();
        if ($trailResult->count()) {
            $trailData = $trailResult->current();
        }
        else {
            return ;
        }
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
        $guidesCount = count($guides);
        $guides = array_slice($guides, 0, $guidesCount);
        $accommodationsQuery = "SELECT accommodations.* FROM rel_accommodation_trail LEFT JOIN accommodations ON accommodations.acc_id = rel_accommodation_trail.rat_accommodation_id WHERE rel_accommodation_trail.rat_trail_id = $trail_id ";
        $accommodationsResult = $this->adapter->query($accommodationsQuery)->execute();
        if ($accommodationsResult->count()) {
            while ($accommodationsResult->current()) {
                $accommodations[] = $accommodationsResult->current();
                $accommodationsResult->next();
            }
        }
        $trailReviewQuery = "SELECT trail_review.* ,
                             users.user_first_name,
                             users.user_last_name,
                             users.user_avatar
                              FROM trail_review
                             LEFT JOIN users ON users.user_id=trail_review.tr_user_id
                             WHERE trail_review.tr_trail_id=$trail_id AND trail_review.tr_status='active'  ORDER BY CASE WHEN (tr_user_id=200) THEN 0 ELSE 1 END , tr_id LIMIT 2 ";
        $trailReviewResult = $this->adapter->query($trailReviewQuery)->execute();
        if ($trailReviewResult->count()) {
            while ($trailReviewResult->current()) {
                $trailReviews[] = $trailReviewResult->current();
                $trailReviewResult->next();
            }
        }


        $trailCoverQuery = "SELECT trail_covers.* FROM trail_covers WHERE tc_trail_id=$trail_id ORDER BY tc_order";
        $trailCovers = array();
        $trailCoversResult = $this->adapter->query($trailCoverQuery)->execute();
        while ($trailCoversResult->current()) {
            $trailCovers[] = $trailCoversResult->current()['tc_cover'];
            $trail_cover = $trailCoversResult->current()['tc_cover'];
            $trailCoversResult->next();
        }
        date_default_timezone_set('Asia/Yerevan');
        $trailWeather = [];
        $weatherDate = date('Y-m-d H:i:s', strtotime(date('Y-m-d H:00:00')) + 3600);

        $trailWeatherQuery = "SELECT * from weather WHERE weather_trail_id = $trail_id and weather_datetime='$weatherDate'";
        $trailWeatherResult = $this->adapter->query($trailWeatherQuery)->execute();
        if (!$trailWeatherResult->current()) {
            $hourlyForecast = $this->apiAdapter->getHourlyForecast($trailData['trail_lat_start'], $trailData['trail_long_start']);
            if ($hourlyForecast && isset($hourlyForecast['hourly_forecast'])) {
                foreach ($hourlyForecast['hourly_forecast'] as $forecast) {
                    $timeArray = $forecast['FCTTIME'];

                    $date = $timeArray['year'] . '-' . $timeArray['mon_padded'] . '-' . $timeArray['mday_padded'] . ' ' . $timeArray['hour_padded'] . ':' . $timeArray['min'] . ':00';

                    $icon = 'http://'.$_SERVER['SERVER_NAME'].'/img/weather-icons/'.$forecast['icon'].'.png';
                    $weatherTemperature = $forecast['temp']['metric'];
                    $query = "INSERT INTO `weather`(`weather_trail_id`, `weather_datetime`, `weather_icon`,`weather_temperature`) VALUES ($trail_id,'$date','$icon','$weatherTemperature')";
                    try {
                        $this->adapter->query($query)->execute();
                    } catch (\Exception $e) {
                    }
                }
            }
            $trailWeatherQuery = "SELECT * from weather WHERE weather_trail_id = $trail_id and weather_datetime= '$weatherDate'";
            $trailWeatherResult = $this->adapter->query($trailWeatherQuery)->execute();
            if ($trailWeatherResult->current()) {
                $trailWeather = $trailWeatherResult->current();
            }
        } else {
            $trailWeather = $trailWeatherResult->current();
        }

        $trailData['trail_covers'] = $trailCovers;
        $trailData['trail_cover']  =$trail_cover;
        $trailData['guides'] = $guides;
        $trailData['guide_count'] = $guidesCount;
        $trailData['accommodations'] = $accommodations;
        $trailData['reviews'] = $trailReviews;
        if ($trailWeather) {
            $trailData['weather'] = $trailWeather;
        }

        return $trailData;
    }

    public function saveTrail($trail_id, $user_id)
    {
        $query = "SELECT * FROM  rel_user_saved_trails
                WHERE rust_user_id=$user_id AND rust_trail_id= $trail_id";

        if ($this->adapter->query($query)->execute()->count()) {
            return true;
        }
        $query = "INSERT  INTO `rel_user_saved_trails`
                ( `rust_user_id`, `rust_trail_id`) VALUES ($user_id,$trail_id)";
        $this->adapter->query($query)->execute();
        return true;
    }

    public function deleteSavedTrail($trail_id, $user_id)
    {
        $query = "DELETE FROM `rel_user_saved_trails` WHERE rust_user_id=$user_id AND rust_trail_id= $trail_id";
        $this->adapter->query($query)->execute();
        return true;
    }

    public function findTrailForAdmin($trail_id, $user_id = -1)
    {
        $trailQuery = "SELECT trails.* ,
                CASE WHEN
                rel_user_saved_trails.rust_trail_id IS NOT NULL THEN 1 ELSE 0 END AS is_saved,
                AVG(trail_review.tr_rating) AS average_rating,
                COUNT(trail_review.tr_rating) AS review_count
                FROM trails
                LEFT JOIN rel_user_saved_trails ON rel_user_saved_trails.rust_trail_id = trails.trail_id
                AND rel_user_saved_trails.rust_user_id=$user_id
                LEFT JOIN trail_review ON trails.trail_id = trail_review.tr_trail_id

                WHERE trails.trail_id=$trail_id
                GROUP BY trails.trail_id";
        $trailResult = $this->adapter->query($trailQuery)->execute();

        $guides = array();
        $accommodations = array();
        $trailReviews = array();
        if ($trailResult->count()) {
            $trailData = $trailResult->current();
        }
        $guideQuery = "SELECT guides.* FROM rel_trail_guide LEFT JOIN guides ON guides.guide_id = rel_trail_guide.rtg_guide_id WHERE rel_trail_guide.rtg_trail_id = $trail_id ";
        $guideResult = $this->adapter->query($guideQuery)->execute();
        if ($guideResult->count()) {
            while ($guideResult->current()) {
                $guides[] = $guideResult->current();
                $guideResult->next();
            }
        }
        $accommodationsQuery = "SELECT accommodations.* FROM rel_accommodation_trail LEFT JOIN accommodations ON accommodations.acc_id = rel_accommodation_trail.rat_accommodation_id WHERE rel_accommodation_trail.rat_trail_id = $trail_id ";
        $accommodationsResult = $this->adapter->query($accommodationsQuery)->execute();
        if ($accommodationsResult->count()) {
            while ($accommodationsResult->current()) {
                $accommodations[] = $accommodationsResult->current();
                $accommodationsResult->next();
            }
        }
        $trailReviewQuery = "SELECT trail_review.* ,
                             users.user_first_name,
                             users.user_last_name,
                             users.user_avatar
                              FROM trail_review
                             LEFT JOIN users ON users.user_id=trail_review.tr_user_id
                             WHERE trail_review.tr_trail_id=$trail_id AND trail_review.tr_status='active'";
        $trailReviewResult = $this->adapter->query($trailReviewQuery)->execute();
        if ($trailReviewResult->count()) {
            while ($trailReviewResult->current()) {
                $trailReviews[] = $trailReviewResult->current();
                $trailReviewResult->next();
            }
        }


        $trailCoverQuery = "SELECT trail_covers.* FROM trail_covers WHERE tc_trail_id=$trail_id ORDER BY tc_order";
        $trailCovers = array();
        $trailCoversResult = $this->adapter->query($trailCoverQuery)->execute();
        while ($trailCoversResult->current()) {
            $trailCovers[] = $trailCoversResult->current();
            $trailCoversResult->next();
        }
        $trailData['trail_covers'] = $trailCovers;
        $trailData['guides'] = $guides;
        $trailData['accommodations'] = $accommodations;
        $trailData['reviews'] = $trailReviews;
        return $trailData;
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

    public function removeTrailGuides($trail_id)
    {
        $query = "DELETE FROM rel_trail_guide WHERE rtg_trail_id=$trail_id";
        $this->adapter->query($query)->execute();

    }

    public function removeTrailAccommodations($trail_id)
    {
        $query = "DELETE FROM rel_accommodation_trail WHERE rat_trail_id=$trail_id";
        $this->adapter->query($query)->execute();
    }

    public function addTrailGuide($trail_id, $guide_id)
    {
        $query = "INSERT INTO `rel_trail_guide`
                 (`rtg_guide_id`, `rtg_trail_id`) VALUES ($guide_id, $trail_id)";
        $this->adapter->query($query)->execute();
    }

    public function addTrailAccommodation($trail_id, $acc_id)
    {
        $query = "INSERT INTO `rel_accommodation_trail`
                 (`rat_accommodation_id`, `rat_trail_id`) VALUES ($acc_id, $trail_id)";
        $this->adapter->query($query)->execute();
    }
}
