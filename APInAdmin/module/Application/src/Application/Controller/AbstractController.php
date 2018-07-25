<?php
namespace Application\Controller;

use Admin\Adapter\AuthAdapter;
use Admin\Model\AdminAuth;
use Admin\Model\AdminAuthTable;
use Admin\Model\AdminAuthStorage;
use Application\Model\GuideReview;
use Application\Model\User;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Zend\View\Model\ViewModel;
use Auth\Model\Auth;
use Application\Custom\Translator as CustomTranslator;
use Zend\Mail\Transport\Sendmail as SendmailTransport;
use Zend\Mail\Message;
use Zend\Mail;
use Application\Model\GuideTable;
use Application\Model\GuideReviewTable;
use Application\Model\TrailReviewTable;
use Application\Model\AccommodationTable;
use Application\Model\TrailTable;
use Application\Model\TrailCoverTable;
use Zend\Session\Container;
use Application\Model\LanguageTable;
use Auth\Model\AuthTable;
use Application\Model\ForgotPasswordTable;
class AbstractController extends AbstractRestfulController
{

    protected $logTable;
    protected $errorLogTable;
    protected $authTable;
    protected $userTable;

    protected $userTokenTable;
    protected $authService;
    protected $authStorage;
    protected $user;
    protected $userFromDb;
    protected $language;
    protected $translator;
    protected $config;
    protected $lastUrl;
    protected $admin;
    protected $adminAuthTable;
    protected $adminAuthService;
    protected $adminAuthStorage;
    protected $forgotPasswordTable;
    protected $accommodationTable;
    protected $guideTable;
    protected $guideReviewTable;
    protected $trailReviewTable;
    protected $trailTable;
    protected $trailCoverTable;
    protected $languageTable;

    protected function translate($word) {
        if(!$this->translator) {
            $this->translator = new CustomTranslator($this->getLang());
        }

        return $this->translator->getErrorMessage($word);
    }

    public function getAuthSessionStorage()
    {
        if (!$this->authStorage) {
            $this->authStorage = $this->getServiceLocator()->get('Auth\Model\AuthStorage');
        }
        return $this->authStorage;
    }

    public function getAuthService()
    {
        if (!$this->authService) {
            $this->authService = $this->getServiceLocator()
                ->get('AuthService');
        }

        return $this->authService;
    }


    protected function getLang()
    {
        if(!$this->language) {
            $this->language = $this->params()->fromRoute('language', 'am');
        }

        return $this->language;
    }
    /**
     * @return UserTable
     */
    public function getUserTable()
    {
        if(!$this->userTable) {
            $this->userTable = $this->getServiceLocator()->get('Application\Model\UserTable');
        }
        return $this->userTable;
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
     * @return AccommodationTable
     */
    public function getAccommodationTable()
    {
        if(!$this->accommodationTable) {
            $this->accommodationTable = $this->getServiceLocator()->get('Application\Model\AccommodationTable');
        }
        return $this->accommodationTable;
    }

    /**
     * @return LanguageTabl
     */
    public function getLanguageTable()
    {
        if(!$this->languageTable) {
            $this->languageTable = $this->getServiceLocator()->get('Application\Model\LanguageTable');
        }
        return $this->languageTable;
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
     * @return TrailTable
     */
    public function getTrailTable()
    {
        if(!$this->trailTable) {
            $this->trailTable = $this->getServiceLocator()->get('Application\Model\TrailTable');
        }
        return $this->trailTable;
    }
    /**
     * @return TrailCoverTable
     */
    public function getTrailCoverTable()
    {
        if(!$this->trailCoverTable) {
            $this->trailCoverTable = $this->getServiceLocator()->get('Application\Model\TrailCoverTable');
        }
        return $this->trailCoverTable;
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
    public function getTrailReviewTable()
    {
        if(!$this->trailReviewTable) {
            $this->trailReviewTable = $this->getServiceLocator()->get('Application\Model\TrailReviewTable');
        }
        return $this->trailReviewTable;
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

    public function getUser($from_db = false)
    {
        if($from_db === true) {
            return $this->getUserFromDb();
        }
        if(!$this->user) {
            if (($this->user = $this->getServiceLocator()->get('AuthService')->getStorage()->read()) &&
                is_a($this->user, "Application\Model\User")) {
            } else {
                $this->user = new Auth();
            }
        }

        return $this->user;
    }

    public function getUserFromDb()
    {
        if(!$this->userFromDb) {
            if($this->getUser()->getId()) {
                $this->userFromDb = $this->getAuthTable()->getById($this->getUser()->getId());
            } else {
                $this->userFromDb = $this->getUser();
            }
        }

        return $this->userFromDb;
    }

    /**
     * @return AdminAuthTable
     */
    public function getAdminAuthTable()
    {
        if (!$this->adminAuthTable) {
            $sm = $this->getServiceLocator();
            $this->adminAuthTable = $sm->get('Admin\Model\AdminAuthTable');
        }
        return $this->adminAuthTable;
    }

    private $authAdapter;

    /**
     * @return AuthAdapter
     */
    public function getAuthAdapter()
    {
        if (!$this->authAdapter) {
            $adapter = new AuthAdapter();
            $this->authAdapter = $adapter->setAuthTable($this->getAdminAuthTable());
        }
        return $this->authAdapter;
    }
    public function getAdminAuthService()
    {
        if (!$this->adminAuthService) {
            $this->adminAuthService = $this->getServiceLocator()
                ->get('AdminAuthService');
        }

        return $this->adminAuthService;
    }

    /**
     * @return AdminAuthStorage
     */
    public function getAdminSessionStorage()
    {
        if (!$this->adminAuthStorage) {
            $this->adminAuthStorage = $this->getServiceLocator()->get('Admin\Model\AdminAuthStorage');
        }
        return $this->adminAuthStorage;
    }

    public function getAdmin()
    {
        if (!$this->admin) {
            if (($this->admin = $this->getServiceLocator()->get('AdminAuthService')->getStorage()->read()) &&
                is_a($this->admin, "Application\Model\User")
            ) {
            } else {
                $this->admin = new User();
            }
        }

        return $this->admin;
    }


    public function logout()
    {
        $this->getAuthSessionStorage()->forgetMe();
        $this->getAuthService()->clearIdentity();
    }

    public function login($user)
    {
        $this->getAuthSessionStorage()
            ->setRememberMe(1);

        $this->getAuthService()->setStorage($this->getAuthSessionStorage());
        $this->getAuthService()->getStorage()->write($user);
        $this->member = null;
    }

    public function reLogin() {
        $user = $this->getUser(true);
        $this->user = false;
        $this->logout();
        $this->login($user);
        $this->getUser();
    }

    public function getConfig() {
        if(!$this->config) {
            $config = $this->getServiceLocator()->get('Config');
            $this->config = (object) $config;
        }
        return $this->config;
    }

    public function getLastUrl() {
        if(!$this->lastUrl) {
            $session = new Container('url');
            $this->lastUrl = $session->lastUrl;
            $session->lastUrl = false;
        }
        return $this->lastUrl;
    }

    public function setLastUrl() {
        $session = new Container('url');
        $session->lastUrl = $this->getRequest()->getRequestUri();
    }
    public function checkArguments($data, $arguments=array()){
        if(!$arguments){
            return true;
        }
        foreach ($arguments as $argument){
            if(!array_key_exists($argument,$data)||$data[$argument]==''){
                return false;
            }
        }
        return true;
    }
}
