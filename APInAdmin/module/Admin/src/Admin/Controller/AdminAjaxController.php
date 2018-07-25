<?php
namespace Admin\Controller;

use Application\Controller\AbstractController;
use Zend\View\Model\JsonModel;
use Zend\View\Model\ViewModel;


class AdminAjaxController extends AbstractController
{
    public function indexAction()
    {
        return new JsonModel(array("returnCode" => 201));
    }

    public function getUsersAction()
    {
        $returnData = array();
        $posts = $this->getUserTable()->findAll('active');
        foreach ($posts as $key => $post) {
            $rD = array();
            $rD['user_id'] = $post->getId();
            $rD['name'] = $post->getFirstName() . ' ' . $post->getLastName();
            $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
            $rD['type'] = $post->getType();
            $rD['action'] = "<a href=/admin/edit-user/" . $post->getId() . " class='btn btn-info btn-xs'>
                                            Edit
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();removeUser(this)'>
                                            Remove
                                        </a>";
            $returnData[] = $rD;
        }
        return new JsonModel(array("users" => $returnData));
    }

    public function getAccommodationsAction()
    {
        $returnData = array();
        $posts = $this->getAccommodationTable()->findAll('active');
        foreach ($posts as $key => $post) {
            $rD = array();
            $rD['id'] = $post->getId();
            $rD['name'] = $post->getName();
            $rD['email'] = $post->getEmail();
            $rD['url'] = $post->getUrl();
            $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
            $rD['action'] = "<a href=/admin/edit-accommodation/" . $post->getId() . " class='btn btn-info btn-xs'>
                                            Edit
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();removeAccommodation(this)'>
                                            Remove
                                        </a>";
            $returnData[] = $rD;
        }
        return new JsonModel(array("accommodations" => $returnData));
    }

    public function getGuidesAction()
    {
        $returnData = array();
        $posts = $this->getGuideTable()->findAll();
        foreach ($posts as $key => $post) {
            $rD = array();
            $rating = $this->getGuideTable()->getGuideRating($post->getId())['average_rating'];
            $rD['id'] = $post->getId();
            $rD['name'] = $post->getFirstName() . ' ' . $post->getLastName();
            $rD['email'] = $post->getEmail();
            $rD['phone'] = $post->getPhone();
            $r = '';
            for ($i = 1; $i <= 5; $i++) {
                if ($rating >= $i) {
                    $r .= '<i class="fa fa-star yellow-star"></i>';
                } else {
                    $r .= '<i  class="fa fa-star-o yellow-star"></i>';
                }
            }

            $rD['rating'] = $r;
            $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
            $rD['action'] = "<a href=/admin/edit-guide/" . $post->getId() . " class='btn btn-info btn-xs'>
                                            Edit
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();removeGuide(this)'>
                                            Remove
                                        </a>";
            $returnData[] = $rD;
        }
        return new JsonModel(array("guides" => $returnData));
    }

    public function getTrailsAction()
    {
        $returnData = array();
        $posts = $this->getTrailTable()->findAll();
        foreach ($posts as $key => $post) {

            $rD = array();
            $rD['id'] = $post->getId();
            $rD['name'] = $post->getName();
            $rD['region'] = $post->getRegion();
            $rD['number_of_guides'] = $this->getGuideTable()->getTrailGuideCount($post->getId());
            $rD['number_of_accommodations'] = $this->getAccommodationTable()->getTrailAccommodationCount($post->getId());
            $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
            $rD['action'] = "<a href=/admin/edit-trail/" . $post->getId() . " class='btn btn-info btn-xs'>
                                            Edit
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();removeTrail(this)'>
                                            Remove
                                        </a>";
            $returnData[] = $rD;
        }
        return new JsonModel(array("trails" => $returnData));
    }

    public function getTrailReviewsAction()
    {
        $posts = $this->getTrailReviewTable()->findAll();
        $returnData = array();
        foreach ($posts as $key => $post) {
            $user = $this->getUserTable()->find($post->getUserId());
            $trail = $this->getTrailTable()->find($post->getTrailId());
            if (!$trail || !$user) {
                $this->getTrailReviewTable()->delete($post->getId());
            } else {
                $rD = array();
                $rD['id'] = $post->getId();
                $rD['trail_name'] = $trail->getName();
                $rD['user_name'] = $user->getFirstName() . ' ' . $user->getLastName();
                $r = '';
                for ($i = 1; $i <= 5; $i++) {
                    if ($post->getRating() >= $i) {
                        $r .= '<i class="fa fa-star yellow-star"></i>';
                    } else {
                        $r .= '<i  class="fa fa-star-o yellow-star"></i>';
                    }
                }

                $rD['rating'] = $r.' <span class="truncate">'.$post->getReview().'</span>';
                $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
                $rD['action'] = "<a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-info btn-xs' onclick='event.stopPropagation();approveTrailReview(this)'>
                                            Approve
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();rejectTrailReview(this)'>
                                            Reject
                                        </a>
                                      ";
                $returnData[] = $rD;
            }

        }
        return new JsonModel(array("trail_reviews" => $returnData));
    }

    public function getGuideReviewsAction()
    {
        $posts = $this->getGuideReviewTable()->findAll();
        $returnData = array();
        foreach ($posts as $key => $post) {

            $user = $this->getUserTable()->find($post->getUserId());
            $guide = $this->getGuideTable()->find($post->getGuideId());

            if (!$guide || !$user) {
                $this->getGuideReviewTable()->delete($post->getId());
            } else {
                $rD = array();
                $rD['id'] = $post->getId();
                $rD['guide_name'] = $guide->getFirstName() . ' ' . $guide->getLastName();
                $rD['user_name'] = $user->getFirstName() . ' ' . $user->getLastName();
                $r = '';
                for ($i = 1; $i <= 5; $i++) {
                    if ($post->getRating() >= $i) {
                        $r .= '<i class="fa fa-star yellow-star"></i>';
                    } else {
                        $r .= '<i  class="fa fa-star-o yellow-star"></i>';
                    }
                }
                $rD['rating'] = $r.' '.' <span class="truncate">'.$post->getReview().'</span>';
                $rD['status'] = '<span class="label label-success"> ' . $post->getStatus() . '</span>';
                $rD['action'] = "<a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-info btn-xs' onclick='event.stopPropagation();approveGuideReview(this)'>
                                            Approve
                                        </a>
                                        <a href='javascript:void(0)' data-id=" . $post->getId() . " class='btn btn-danger btn-xs' onclick='event.stopPropagation();rejectGuideReview(this)'>
                                            Reject
                                        </a>
                                        ";
                $returnData[] = $rD;
            }
        }
        return new JsonModel(array("guide_reviews" => $returnData));
    }
}