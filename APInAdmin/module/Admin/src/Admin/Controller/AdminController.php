<?php
namespace Admin\Controller;

use Application\Controller\AbstractController;
use Application\Custom\Upload;
use Zend\Mvc\MvcEvent;
use Zend\View\Model\ViewModel;

class AdminController extends AbstractController
{
    const IMG_UPLOAD_DIR = "/media/images/";
    private $viewModel;
    public function onDispatch(MvcEvent $e)
    {
        $guide_reviews = $this->getGuideReviewTable()->findAll('pending');
        $trail_reviews = $this->getTrailReviewTable()->findAll('pending');
        $args = array(
            'guide_reviews' =>count($guide_reviews),
            'trail_reviews' =>count($trail_reviews),
            'userLogin' => $this->getAdmin()->getFirstName(),
            'userRole' => $this->getAdmin()->getRole(),
        );
        $this->viewModel = new ViewModel($args);
        return parent::onDispatch($e);
    }

    public function indexAction()
    {

        return $this->redirect()->toUrl('/admin/trails');
      /*  if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        if($this->getAdmin()->getType()=='user'){
            return $this->redirect()->toUrl('/admin/user-stats/'.$this->getAdmin()->getId());
        }
        $data = array();
        $args = array(
            'data' => $data,
            'userRole' => $this->getAdmin()->getType(),
        );
        $viewModel = new ViewModel($args);
        $viewModel->setTemplate("admin/admin/index.phtml");
        return $viewModel;*/
    }
    public function loginAction()
    {
        $form = new \Admin\Form\AdminAuthLoginForm();
        $request = $this->getRequest();
        if ($request->isPost()) {
            $form->setData($request->getPost());
            if ($form->isValid()) {
                $adapter = $this->getAuthAdapter()
                    ->setEmail($request->getPost('email'))
                    ->setPassword($request->getPost('password'));

                $result = $this->getAdminAuthService()->authenticate($adapter);
                foreach ($result->getMessages() as $message) {
                    $this->flashmessenger()->addMessage($message);
                }

                if ($result->isValid()) {
                    $client = $result->getIdentity();

                    $this->getAdminSessionStorage()->setRememberMe(1);
                    $this->getAdminAuthService()->setStorage($this->getAdminSessionStorage());
                    $this->getAdminAuthService()->getStorage()->write($client);

                    return $this->redirect()->toUrl('/admin/trails');
                }
            }
        }
        return array(
            'activeTab' => "login",
        );
    }

    public function logoutAction()
    {
        if (!$this->getAdmin()->getId()) {
            return $this->redirect()->toRoute("admin", array("action" => "login"));
        }

        $this->getAdminSessionStorage()->forgetMe();
        $this->getAdminAuthService()->clearIdentity();

        return $this->redirect()->toRoute("admin", array("action" => "login"));
    }

    /* Users */

    public function usersAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }

        $posts = $this->getUserTable()->findAll('active');
        $this->viewModel->setVariables(
            array(
            'activeTab' => "users",
            'userRole' => $this->getAdmin()->getType(),
            'posts' => $posts,
        )
        );
        return $this->viewModel;
    }

    public function addUserAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $post=$this->getUserTable()->getNotUsed();
        $this->viewModel->setVariables(
            array(
                'activeTab' => "users",
                'post' => $post,
                'userRole' => $this->getAdmin()->getType(),

            )
        );
        return $this->viewModel;
    }
    public function editUserAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }

        $post_id = $this->params()->fromRoute('id');


        $post = $this->getUserTable()->find($post_id);
        $this->viewModel->setVariables(
            array(
                'activeTab' => "users",
                'post' => $post,
                'userRole' => $this->getAdmin()->getType(),
            )
        );
        return $this->viewModel;
    }
    public function accommodationsAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $posts = $this->getAccommodationTable()->findAll('active');
        $this->viewModel->setVariables(
            array(
                'activeTab' => "accommodations",
                'userRole' => $this->getAdmin()->getType(),
                'posts' => $posts,
            )
        );
        return $this->viewModel;

    }

    public function editAccommodationAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }

        $post_id = $this->params()->fromRoute('id');

        $post = $this->getAccommodationTable()->find($post_id);
        $reviews = $this->getGuideReviewTable()->findGuideReviews($post_id);
        $this->viewModel->setVariables(
            array(
                'activeTab' => "accommodations",
                'post' => $post,
                'userRole' => $this->getAdmin()->getType(),
            )
        );
        return $this->viewModel;
    }
    public function addAccommodationAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $post = $this->getAccommodationTable()->getNotUsed();
        $this->viewModel->setVariables(
           array(
               'activeTab' => "accommodations",
               'post' => $post,
               'userRole' => $this->getAdmin()->getType(),
           )
        );
        return $this->viewModel;

    }
    public function guidesAction(){
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $posts = $this->getGuideTable()->findAll('active');
        foreach($posts as $key=>$post){
            $rating = $this->getGuideTable()->getGuideRating($post->getId())['average_rating'];
            $posts[$key]->setRating($rating);
        }
        $this->viewModel->setVariables(
            array(
                'activeTab' => "guides",
                'userRole' => $this->getAdmin()->getType(),
                'posts' => $posts,
            )
        );
        return $this->viewModel;

    }
    public function editGuideAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }

        $post_id = $this->params()->fromRoute('id');

        $post = $this->getGuideTable()->find($post_id);
        $guideLanguages = $this->getLanguageTable()->findGuideLanguages($post_id);
        $reviews = $this->getGuideReviewTable()->findGuideReviews($post_id);
        $post->setLanguages($guideLanguages);
        $trails = $this->getTrailTable()->findAll('active');
        $languages = $this->getLanguageTable()->findAll();
        $guideTrails = $this->getGuideTable()->findGuideTrails($post_id);
        $post->setTrails($guideTrails);
        if($reviews){
            foreach ($reviews as $key=>$review){
                $user= $this->getUserTable()->find($review->getUserId());
                $reviews[$key]->setUser($user);
            }
        }

        $this->viewModel->setVariables(
            array(
                'activeTab' => "guides",
                'post' => $post,
                'trails'=> $trails,
                'userRole' => $this->getAdmin()->getType(),
                'reviews' => $reviews,
                'languages' =>$languages
            )
        );
        return $this->viewModel;

    }
    public function addGuideAction()
    {
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $trails = $this->getTrailTable()->findAll('active');
        $post = $this->getGuideTable()->getNotUsed();
        $guideTrails = $this->getGuideTable()->findGuideTrails($post->getId());
        $post->setTrails($guideTrails);
        $languages = $this->getLanguageTable()->findAll();
        $this->viewModel->setVariables(
            array(
                'activeTab' => "guides",
                'post' => $post,
                'trails' =>$trails,
                'userRole' => $this->getAdmin()->getType(),
                'languages' =>$languages
            )
        );
        return $this->viewModel;

    }
    public function guideReviewsAction(){
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $posts = $this->getGuideReviewTable()->findAll('pending');
        if($posts){
            foreach ($posts as $key=>$post){
                $user = $this->getUserTable()->find($post->getUserId());
                $guide = $this->getUserTable()->find($post->getGuideId());
                $posts[$key]->setUser($user);
                $posts[$key]->setGuide($guide);
            }
        }
        $this->viewModel->setVariables(
            array(
                'activeTab' => "guide-reviews",
                'userRole' => $this->getAdmin()->getType(),
                'posts' => $posts,
            )
        );
        return $this->viewModel;

    }
    public function trailReviewsAction(){
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $posts = $this->getTrailReviewTable()->findAll('pending');
        if($posts){
            foreach ($posts as $key=>$post){
                $user = $this->getUserTable()->find($post->getUserId());
                $trail = $this->getTrailTable()->find($post->getTrailId());
                $posts[$key]->setUser($user);
                $posts[$key]->setTrail($trail);
            }
        }
        $this->viewModel->setVariables(
            array(
                'activeTab' => "trail-reviews",
                'userRole' => $this->getAdmin()->getType(),
                'posts' => $posts,
            )
        );
        return $this->viewModel;
    }
    public function trailsAction(){
        if (!$this->getAdmin()->getId()) {
            $this->setLastUrl();
            return $this->redirect()->toRoute("admin", array("action" => "login", "language" => $this->getLang()));
        }
        $posts = $this->getTrailTable()->findAll('active');
        foreach($posts as $key=>$post){
            $accCount = $this->getAccommodationTable()->getTrailAccommodationCount($post->getId());
            $posts[$key]->setAccommodationCount($accCount);
            $guideCount = $this->getGuideTable()->getTrailGuideCount($post->getId());
            $posts[$key]->setGuideCount($guideCount);
        }
        $this->viewModel->setVariables(
            array(
                'activeTab' => "trails",
                'userRole' => $this->getAdmin()->getType(),
                'posts' => $posts,
            )
        );
        return $this->viewModel;

    }
    public function editTrailAction(){
        $trail_id = $this->params()->fromRoute('id');
        $trail =  $this->getTrailTable()->findTrailForAdmin($trail_id);
        $guides = $this->getGuideTable()->findAll('active');
        $accommodations = $this->getAccommodationTable()->findAll('active');
        $this->viewModel->setVariables(
            array(
                'activeTab' => "trails",
                'post' => $trail,
                'userRole' => $this->getAdmin()->getType(),
                'guides' => $guides,
                'accommodations' =>$accommodations,
            )
        );
        return $this->viewModel;

    }
    public function addTrailAction(){
        $trail = $this->getTrailTable()->getNotUsed();
        $trail =  $this->getTrailTable()->findTrailForAdmin($trail->getId());
        $guides = $this->getGuideTable()->findAll('active');
        $accommodations = $this->getAccommodationTable()->findAll('active');
        $this->viewModel->setVariables(
            array(
                'activeTab' => "trails",
                'post' => $trail,
                'userRole' => $this->getAdmin()->getType(),
                'guides' => $guides,
                'accommodations' =>$accommodations,
            )
        );
        return $this->viewModel;
    }
    public function editTrailReviewAction(){
        $review_id = $this->params()->fromRoute('id');
        $trail_review =  $this->getTrailReviewTable()->find($review_id);
        $user = $this->getUserTable()->find($trail_review->getUserId());
        $trail = $this->getTrailTable()->find($trail_review->getTrailId());
        $this->viewModel->setVariables(
            array(
                'activeTab' => "trail-reviews",
                'post' => $trail_review,
                'user' => $user,
                'trail'=> $trail,
                'userRole' => $this->getAdmin()->getType(),
            )
        );
        return $this->viewModel;
    }
    public function editGuideReviewAction(){
        $review_id = $this->params()->fromRoute('id');
        $review =  $this->getGuideReviewTable()->find($review_id);
        $user = $this->getUserTable()->find($review->getUserId());
        $guide = $this->getGuideTable()->find($review->getGuideId());

        $this->viewModel->setVariables(
            array(
                'activeTab' => "guide-reviews",
                'post' => $review,
                'user' => $user,
                'guide' =>$guide,
                'userRole' => $this->getAdmin()->getType(),
            )
        );
        return $this->viewModel;
    }
}
