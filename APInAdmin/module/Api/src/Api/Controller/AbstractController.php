<?php
namespace Api\Controller;

use Zend\Mvc\Controller\AbstractRestfulController;
use Application\Model\UserTable;
use Application\Model\TrailTable;
use Application\Model\UserTrailTable;
use Application\Model\GuideTable;
use Application\Model\GuideReviewTable;
use Application\Model\TrailReview;
use Application\Model\GuideReview;
use Application\Model\UserTokenTable;
use Application\Custom\HashGenerator;
use Application\Model\ForgotPasswordTable;
class AbstractController extends AbstractRestfulController
{
    protected $userTable;
    protected $userTokenTable;
    protected $trailTable;
    protected $guideTable;
    protected $guideReviewTable;
    protected $trailReviewTable;
    protected $forgotPasswordTable;
    protected $userTrailTable;
    protected $config;
    /**
     * @return UserTable
     */
    public function getUserTable()
    {
        if (!$this->userTable) {
            $this->userTable = $this->getServiceLocator()->get('Application\Model\UserTable');
        }
        return $this->userTable;
    }
    public function getConfig(){
        if(!$this->config) {
            $config = $this->getServiceLocator()->get('Config');
            $this->config = (object) $config;
        }
        return $this->config;
    }
    /**
     * @return TrailTable
     */
    public function getTrailTable()
    {
        if (!$this->trailTable) {
            $this->trailTable = $this->getServiceLocator()->get('Application\Model\TrailTable');
        }
        return $this->trailTable;
    }
    /**
     * @return UserTrailTable
     */
    public function getUserTrailTable()
    {
        if (!$this->userTrailTable) {
            $this->userTrailTable = $this->getServiceLocator()->get('Application\Model\UserTrailTable');
        }
        return $this->userTrailTable;
    }
    /**
     * @return UserTokenTable
     */
    public function getUserTokenTable()
    {
        if(!$this->userTokenTable) {
            $this->userTokenTable = $this->getServiceLocator()->get('Application\Model\UserTokenTable');
        }
        return $this->userTokenTable;
    }
    /**
     * @return ForgotPasswordTable
     */
    public function getForgotPasswordTable()
    {
        if(!$this->forgotPasswordTable) {
            $this->forgotPasswordTable = $this->getServiceLocator()->get('Application\Model\ForgotPasswordTable');
        }
        return $this->forgotPasswordTable;
    }
    /**
     * @return GuideTable
     */
    public function getGuideTable()
    {
        if(!$this->guideTable) {
            $this->guideTable = $this->getServiceLocator()->get('Application\Model\GuideTable');
        }
        return $this->guideTable;
    }
    /**
     * @return GuideReviewTable
     */
    public function getGuideReviewTable()
    {
        if(!$this->guideReviewTable) {
            $this->guideReviewTable = $this->getServiceLocator()->get('Application\Model\GuideReviewTable');
        }
        return $this->guideReviewTable;
    }

    /**
     * @return TrailReviewTable
     */
    public function getTrailReviewTable(){
        if(!$this->trailReviewTable) {
            $this->trailReviewTable = $this->getServiceLocator()->get('Application\Model\TrailReviewTable');
        }
        return $this->trailReviewTable;
    }

    public function loginUser($user,$udid){
        if($udid){
            $this->getUserTokenTable()->deleteUdId($udid);
        }
        $userToken = $this->getUserTokenTable()->createNew();
        $userToken->setUserId($user->getId());
        $userToken->setTokenId(HashGenerator::generate(64));
        $userToken->setUdid($udid);
        return $this->getUserTokenTable()->save($userToken);
    }
    public function getUserData($user){
        $savedTrails = $this->getTrailTable()->findSavedTrails($user->getId());
        $user->setSavedTrails($savedTrails);
        return $user;
    }
    public function checkArguments($data, $arguments=array()){
            if(!$arguments){
                return true;
            }
            foreach ($arguments as $argument){
                if(!array_key_exists($argument,$data)){
                    return false;
                }
            }
            return true;
    }
}
