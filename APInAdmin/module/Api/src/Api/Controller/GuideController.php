<?php
namespace Api\Controller;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class GuideController extends AbstractController
{
    public function getList()
    {
        $data = $this->getRequest()->getQuery()->toArray();
        if(!isset($data['language'])){
            $lang='';
        }
        else{
            $lang=$data['language'];
        }
        $guides = $this->getGuideTable()->findGuides($lang);
        return new JsonModel(array("result" => $guides));
    }

    public function get($id)
    {

        $guide = $this->getGuideTable()->findGuide($id);

        return new JsonModel(array("result" => $guide));
    }

    public function update($id, $data)
    {
        $user = $this->getUserTable()->getUserByToken(getallheaders()['X_HTTP_AUTH_TOKEN']);
        if (!$user) {
            return new JsonModel(array("error" => array("code" => 401, "message" => "Must be logged in to perform this action")));
        }
        if(!$this->checkArguments($data,array('review','rating'))){
            return new JsonModel(array("error" =>array("code" => 422, "message" => "Missing arguments")));
        }
        $review = $this->getGuideReviewTable()->findUserGuideRating($user->getId(),$id);
        if(!$review){
            $review = $this->getGuideReviewTable()->createNew();
        }

        $review->setUserId($user->getId());
        $review->setGuideId($id);
        $review->setReview($data['review']);
        $review->setRating($data['rating']);
        $review->setStatus('pending');
        $this->getGuideReviewTable()->save($review);
        return new JsonModel(array("result" => array("code" => 200)));
    }

    public function delete($id)
    {
        # code...
    }

}