<?php
namespace Api\Controller;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class TrailReviewController extends AbstractController
{
    public function get($id){
        $reviews = $this->getTrailReviewTable()->getTrailReviews($id);
        return new JsonModel(array("result" => $reviews));
    }
    public function update($id,$data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if(!$user){
            return new JsonModel(array("error" =>array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        if(!$this->checkArguments($data,array('review','rating'))){
            return new JsonModel(array("error" =>array("code" => 422, "message" => "Missing arguments")));
        }
        $review = $this->getTrailReviewTable()->findUserTrailRating($user->getId(),$id);
        if(!$review){
            $review = $this->getTrailReviewTable()->createNew();
        }

        $review->setUserId($user->getId());
        $review->setTrailId($id);
        $review->setReview($data['review']);
        $review->setRating($data['rating']);
        $review->setStatus('pending');
        $this->getTrailReviewTable()->save($review);
        return new JsonModel(array("result" => array("code" => 200)));
    }
}