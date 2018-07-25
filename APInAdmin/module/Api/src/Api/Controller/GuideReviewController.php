<?php
namespace Api\Controller;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class GuideReviewController extends AbstractController
{
    public function update($id, $data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if (!$user) {
            return new JsonModel(array("error" => array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        if (!$this->checkArguments($data, array('review', 'rating'))) {
            return new JsonModel(array("error" => array("code" => 422, "message" => "Missing arguments")));
        }
        $review = $this->getGuideReviewTable()->findUserGuideRating($user->getId(), $id);
        if (!$review) {
            $review = $this->getGuideReviewTable()->createNew();
        }
        if($review->getStatus()=='active'){
            $review->setReview($data['review']);
            $review->setRating($data['rating']);
            $review->setStatus('pending');
            $this->getGuideReviewTable()->save($review);
            $guide = $this->getGuideTable()->find($review->getGuideId());
            $reviewCount = count($this->getGuideReviewTable()->findGuideReviews($review->getGuideId()));
            $guide->setRatingCount($reviewCount);
            if($review->getRating()){
                $guide->setRating((($guide->getRating()*($reviewCount+1)) - $review->getRating())/$reviewCount);
            }
            $this->getGuideTable()->save($guide);
        }
        else{
            $review->setUserId($user->getId());
            $review->setGuideId($id);
            $review->setReview($data['review']);
            $review->setRating($data['rating']);
            $review->setStatus('pending');
            $this->getGuideReviewTable()->save($review);
        }

        return new JsonModel(array("result" => array("code" => 200)));
    }
}