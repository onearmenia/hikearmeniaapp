<?php
namespace Admin\Controller;

use Application\Controller\AbstractController;
use Application\Custom\Upload;
use Application\Form\AddPostForm;

use Application\Custom\HashGenerator;
use Application\Custom\SimpleImage;
//use Application\Model\Post;
use Zend\View\Model\JsonModel;


class AdminActionController extends AbstractController
{
    public function editUserAction()
    {
        try {
            if ($this->getAdmin()->getId()) {
                if (isset($data['user_password'])) {
                    $data['user_password'] = md5($data['user_password']);
                }
                $post = $this->getUserTable()->find($this->params()->fromRoute("id"));
                $request = $this->getRequest();
                $data = $request->getPost()->toArray();
                if (!filter_var($data['user_email'], FILTER_VALIDATE_EMAIL)) {
                    return new JsonModel(array("returnCode" => 201, "msg" => "Invalid email"));
                }
                if ($user = $this->getUserTable()->getUserByEmail($data['user_email'])) {
                    if ($user->getId() != $post->getId()) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "User with that email already exists"));
                    }

                }

                $post->exchangeArray($data);
                $this->getUserTable()->save($post);
                return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Post has been saved."), "result" => array("redirectTo" => '/admin/users')));
            } else {
                return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in"),));
            }
        } catch (\Exception $e) {
            return new JsonModel(array("returnCode" => 201, "msg" => $e->getMessage(),));
            exit;
        }
    }

    public function removeUserAction()
    {
        $user_id = $this->params()->fromRoute("id");
        $user = $this->getUserTable()->find($user_id);
        $uploader = new Upload($this->getConfig());
        $this->getGuideReviewTable()->removeUserGuideReviews($user_id);
        $this->getTrailReviewTable()->removeUserTrailReviews($user_id);
        if ($user->getAvatar()) {
            $uploader->removeFile($user->getAvatar());
        }
        $this->getUserTable()->delete($user_id);

        return new JsonModel(array("returnCode" => 101, "msg" => 'User Removed'));
    }

    public function editAccommodationAction()
    {
        if (!$this->getAdmin()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        $id = $this->params()->fromRoute("id");
        $adapter = new \Zend\File\Transfer\Adapter\Http();

        if (!$this->checkArguments($data, array('acc_name', 'acc_description'))) {
            return new JsonModel(array("returnCode" => 201, "msg" => "Missing arguments"));
        }
        $uploader = new Upload($this->getConfig());
        if ($_FILES) {
            foreach ($adapter->getFileInfo() as $file => $info) {
                if($file=='acc_cover'){
                    $size = getimagesize($_FILES['acc_cover']['tmp_name']);
                    if ($size['0'] > 1000 || $size['1'] > 1000) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image too big"));
                    }
                    if ($size['0'] / $size[1] != 1.5) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image ratio is wrong"));
                    }
                    $fileName = $adapter->getFileName($file);
                    $coverPath = $uploader->uploadFile($file, $fileName);
                }
                elseif($file=='acc_map_image'){
                    $size = getimagesize($_FILES['acc_map_image']['tmp_name']);
                    if ($size['0'] > 1000 || $size['1'] > 1000) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image too big"));
                    }
                    if ($size['0'] / $size[1] != 2.5) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image ratio is wrong"));
                    }
                    $fileName = $adapter->getFileName($file);
                    $mapImagePath = $uploader->uploadFile($file, $fileName);
                }
            }
        }
        $post = $this->getAccommodationTable()->find($id);
        unset($data['acc_cover']);
        unset($data['acc_map_image']);
        $post->exchangeArray($data);
        if (isset($coverPath)) {
            if ($post->getCover()) {
                $uploader->removeFile($post->getCover());
            }
            $post->setCover($coverPath);
        }
        if (isset($mapImagePath)) {
            if ($post->getMapImage()) {
                $uploader->removeFile($post->getMapImage());
            }
            $post->setMapImage($mapImagePath);
        }
        $this->getAccommodationTable()->save($post);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Post has been saved."), "result" => array("redirectTo" => '/admin/accommodations')));
    }

    public function removeAccommodationAction()
    {
        if (!$this->getAdmin()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
        $id = $this->params()->fromRoute("id");
        $this->getAccommodationTable()->delete($id);
        return new JsonModel(array("returnCode" => 101, "msg" => 'Accommodation Removed'));
    }

    public function editGuideAction()
    {
        if (!$this->getAdmin()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        if (!$this->checkArguments($data, array('guide_first_name', 'guide_last_name'))) {
            return new JsonModel(array("returnCode" => 201, "msg" => "Missing arguments"));
        }
        $id = $this->params()->fromRoute("id");
        $adapter = new \Zend\File\Transfer\Adapter\Http();
        $uploader = new Upload($this->getConfig());
        if ($_FILES) {
            foreach ($adapter->getFileInfo() as $file => $info) {
                $fileName = $adapter->getFileName($file);
                $size = getimagesize($_FILES['guide_cover']['tmp_name']);
                if ($size['0'] > 1000 || $size['1'] > 1000) {
                    return new JsonModel(array("returnCode" => 201, "msg" => "image too big"));
                }
                if ($size['0'] / $size[1] != 1) {
                    return new JsonModel(array("returnCode" => 201, "msg" => "image ratio is wrong"));
                }
                $imagePath = $uploader->uploadFile($file, $fileName);
            }
        }
        $this->getLanguageTable()->removeGuideLanguages($id);
        $this->getGuideTable()->removeGuideTrails($id);
        if (isset($data['languages'])) {
            foreach ($data['languages'] as $language) {
                $this->getLanguageTable()->addGuideLanguage($id, $language);
            }
        }
        if (isset($data['trails'])) {
            foreach ($data['trails'] as $trail) {
                $this->getGuideTable()->addGuideTrail($id, $trail);
            }
        }
        $post = $this->getGuideTable()->find($id);
        $post->exchangeArray($data);
        if (isset($imagePath)) {
            if ($post->getImage()) {
                $uploader->removeFile($post->getImage());
            }
            $post->setImage($imagePath);
        }

        $this->getGuideTable()->save($post);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Post has been saved."), "result" => array("redirectTo" => '/admin/guides')));
    }

    public function removeGuideAction()
    {
        if (!$this->getAdmin()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
        $id = $this->params()->fromRoute("id");
        $this->getGuideTable()->delete($id);
        return new JsonModel(array("returnCode" => 101, "msg" => 'Guide Removed'));
    }

    public function approveGuideReviewAction()
    {
        $id = $this->params()->fromRoute("id");

        $review = $this->getguideReviewTable()->find($id);
        if ($review->getStatus() == 'active') {
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Approved.")));
        }
        $review->setStatus('active');
        $this->getGuideReviewTable()->save($review);
        $guide = $this->getGuideTable()->find($review->getGuideId());
        $reviewCount = count($this->getGuideReviewTable()->findGuideReviews($review->getGuideId()));
        if ($review->getRating()) {
            $guide->setRating(($guide->getRating() * $guide->getRatingCount() + $review->getRating()) / ($reviewCount));
        }

        $guide->setRatingCount($reviewCount);
        $this->getGuideTable()->save($guide);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Approved.")));
    }

    public function rejectGuideReviewAction()
    {
        $id = $this->params()->fromRoute("id");

        $review = $this->getGuideReviewTable()->find($id);
        if ($review->getStatus() == 'inactive') {
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Rejected.")));
        }
        if ($review->getStatus() == 'pending') {
            $review->setStatus('inactive');
            $this->getGuideReviewTable()->save($review);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Rejected.")));
        } else {
            $review->setStatus('inactive');
            $this->getGuideReviewTable()->save($review);
            $guide = $this->getGuideTable()->find($review->getGuideId());
            $reviewCount = count($this->getGuideReviewTable()->findGuideReviews($review->getGuideId()));
            $guide->setRatingCount($reviewCount);
            if ($review->getRating()) {
                $guide->setRating((($guide->getRating() * ($reviewCount + 1)) - $review->getRating()) / $reviewCount);
            }

            $this->getGuideTable()->save($guide);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Rejected.")));
        }


    }

    public function approveTrailReviewAction()
    {
        $id = $this->params()->fromRoute("id");
        $review = $this->getTrailReviewTable()->find($id);
        $review->setStatus('active');
        $this->getTrailReviewTable()->save($review);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Approved.")));
    }

    public function rejectTrailReviewAction()
    {
        $id = $this->params()->fromRoute("id");
        $review = $this->getTrailReviewTable()->find($id);
        $review->setStatus('inactive');
        $this->getTrailReviewTable()->save($review);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Rejected.")));
    }

    public function editTrailAction()
    {
        $id = $this->params()->fromRoute("id");
        $trail = $this->getTrailTable()->find($id);
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        if (!isset($data['trail_name']) || $data['trail_name'] == '') {
            return new JsonModel(array("returnCode" => 201, "msg" => "Missing Arguments"));
        }
        $adapter = new \Zend\File\Transfer\Adapter\Http();
        $uploader = new Upload($this->getConfig());


        if ($_FILES) {
            foreach ($adapter->getFileInfo() as $file => $info) {
                $fileName = $adapter->getFileName($file);

                if ($file == 'trail_kml_file') {
                    $kmlFile = @simplexml_load_string(@file_get_contents($info['tmp_name']));
                    $coordinates = @(string)$kmlFile->Document->Folder->Folder->Placemark[1]->MultiGeometry->LineString->coordinates;
                    if (!$coordinates) {
                        $coordinates = @(string)$kmlFile->Document->Folder->Placemark->LineString->coordinates;
                    }
                    if (!$coordinates) {
                        foreach ($kmlFile->getNamespaces(true) as $namespace) {
                            if (!$coordinates) {
                                $kmlFile->registerXPathNamespace('x', $namespace);
                                $lineStrings = $kmlFile->xpath('//x:LineString');
                                foreach ($lineStrings as $lineString) {
                                    $coordinates .= (string)$lineString->coordinates;
                                    $coordinates .= ' ';
                                }
                            }
                        }

                    }
                    if (!$coordinates) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "Provided kml file is wrong"));
                    }
                    $filePath = $uploader->uploadFile($file, $fileName);

                    if ($trail->getKmlFile()) {
                        $uploader->removeFile($trail->getKmlFile());
                    }
                    $trail->setKmlFile($filePath);
                } else if ($file == 'trail_map_image') {
                    $size = getimagesize($_FILES['trail_map_image']['tmp_name']);
                    if ($size['0'] > 1000 || $size['1'] > 1000) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image too big"));
                    }
                    if ($size['0'] / $size[1] != 2.5) {
                        return new JsonModel(array("returnCode" => 201, "msg" => "image ratio is wrong"));
                    }
                    $filePath = $uploader->uploadFile($file, $fileName);
                    if ($trail->getMapImage()) {
                        $uploader->removeFile($trail->getMapImage());
                    }
                    $trail->setMapImage($filePath);
                }
            }
        }
        unset($data['trail_kml_file']);
        unset($data['trail_map_image']);
        $trail->exchangeArray($data);
        $this->getTrailTable()->removeTrailGuides($id);
        $this->getTrailTable()->removeTrailAccommodations($id);
        if (isset($data['guides'])) {
            foreach ($data['guides'] as $guide) {
                $this->getTrailTable()->addTrailGuide($id, $guide);
            }
        }
        if (isset($data['accommodations'])) {
            foreach ($data['accommodations'] as $acc) {
                $this->getTrailTable()->addTrailAccommodation($id, $acc);
            }
        }

        $this->getTrailTable()->save($trail);
        return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Trail has been saved."), "result" => array("redirectTo" => '/admin/trails')));
    }

    public function saveImageOrderAction()
    {
        if ($this->getAdmin()->getId()) {
            $request = $this->getRequest();
            $data = $request->getPost()->toArray();
            //echo "<pre>"; print_r($data); exit;
            if ($data['data']) {
                $data = json_decode($data['data']);
            }
            //echo "<pre>"; print_r($data); exit;
            return new JsonModel(array("returnCode" => 101, "msg" => "Image order has been saved"));

        } else {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
    }

    public function multipleImageAction()
    {

        $adapter = new \Zend\File\Transfer\Adapter\Http();
        $uploader = new Upload($this->getConfig());
        $id = $this->params()->fromRoute("id");
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        $covers = [];
        if ($_FILES) {
            foreach ($adapter->getFileInfo() as $file => $info) {
                $size = getimagesize($info['tmp_name']);
                if ($size['0'] > 1000 || $size['1'] > 1000) {
                    return new JsonModel(array("returnCode" => 201, "msg" => "image too big"));
                }
                if ($size['0'] / $size[1] != 1.5) {
                    return new JsonModel(array("returnCode" => 201, "msg" => "image ratio is wrong"));
                }
                $fileName = $adapter->getFileName($file);
                $filePath = $uploader->uploadFile($file, $fileName);
                $cover = $this->getTrailCoverTable()->createNew();
                $cover->setTrailId($data['trail_id']);
                $cover->setCover($filePath);
                $cover->setOrder(0);
                $covers[] = $this->getTrailCoverTable()->save($cover)->getArrayCopy();
            }
        }
        return new JsonModel(array("returnCode" => 101, "msg" => "Image order has been saved", "result" => array('imagePaths' => $covers)));
    }

    public function editImageAction()
    {
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        if (isset($data['is_featured']) && $data['is_featured'] == 'on') {
            $data['is_featured'] = true;
        } else {
            $data['is_featured'] = 0;
        }
        $this->getTrailCoverTable()->updateFeatured($data['post_id'], $data['image_id'], $data['is_featured']);
        return new JsonModel(array("returnCode" => 101, "msg" => "Image order has been saved"));
    }

    public function editTrailReviewAction()
    {
        $review_id = $this->params()->fromRoute('id');
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();

        $trailReview = $this->getTrailReviewTable()->find($review_id);
        $trailReview->exchangeArray($data);
        $this->getTrailReviewTable()->save($trailReview);

        return new JsonModel(array("returnCode" => 101, "msg" => "Review has been saved"));
    }

    public function removeTrailReviewAction()
    {
        $review_id = $this->params()->fromRoute('id');
        $this->getTrailReviewTable()->delete($review_id);

        return new JsonModel(array("returnCode" => 101, "msg" => "Review has been removed", "result" => array("redirectTo" => '/admin/trail-reviews')));
    }

    public function editGuideReviewAction()
    {
        $review_id = $this->params()->fromRoute('id');
        $request = $this->getRequest();
        $data = $request->getPost()->toArray();
        $review = $this->getGuideReviewTable()->find($review_id);

        if ($review->getStatus() == 'active' && $data['gr_status'] == 'active') {
            $review->exchangeArray($data);
            $this->getGuideReviewTable()->save($review);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Approved.")));
        }
        if (($review->getStatus() == 'inactive' || $review->getStatus() == 'pending') && $data['gr_status'] == 'inactive') {
            $review->exchangeArray($data);
            $this->getGuideReviewTable()->save($review);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Rejected.")));
        }
        if (($review->getStatus() == 'pending' || $review->getStatus() == 'inactive') && $data['gr_status'] == 'active') {
            $review->exchangeArray($data);
            $this->getGuideReviewTable()->save($review);
            $guide = $this->getGuideTable()->find($review->getGuideId());
            $reviewCount = count($this->getGuideReviewTable()->findGuideReviews($review->getGuideId()));
            if ($review->getRating()) {
                $guide->setRating(($guide->getRating() * $guide->getRatingCount() + $review->getRating()) / ($reviewCount));
            }

            $guide->setRatingCount($reviewCount);
            $this->getGuideTable()->save($guide);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Approved.")));
        }
        if ($review->getStatus() == 'active' && $data['gr_status'] == 'inactive') {
            $review->exchangeArray($data);
            $this->getGuideReviewTable()->save($review);
            $guide = $this->getGuideTable()->find($review->getGuideId());
            $reviewCount = count($this->getGuideReviewTable()->findGuideReviews($review->getGuideId()));
            $guide->setRatingCount($reviewCount);
            if ($review->getRating()) {
                $guide->setRating((($guide->getRating() * ($reviewCount + 1)) - $review->getRating()) / $reviewCount);
            }

            $this->getGuideTable()->save($guide);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Removed.")));
        }
    }

    public function removeGuideReviewAction()
    {
        $review_id = $this->params()->fromRoute('id');
        $review = $this->getGuideReviewTable()->find($review_id);

        if ($review->getStatus() == 'active') {
            $guide = $this->getGuideTable()->find($review->getGuideId());
            $this->getGuideReviewTable()->delete($review_id);
            $reviews = $this->getGuideReviewTable()->findGuideReviews($review->getGuideId());
            $reviewCount = count($reviews);
            $guide->setRatingCount($reviewCount);
            $rating = 0;
            if (!count($reviews)) {
                $guide->setRating(0);
            } else {
                if ($review->getRating()) {
                    $guide->setRating(($guide->getRating() * ($guide->getRatingCount()+1) - $review->getRating()) / ($reviewCount));
                }
            }
            $this->getGuideTable()->save($guide);


            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Removed."), "result" => array("redirectTo" => '/admin/guide-reviews')));
        } else {
            $this->getGuideReviewTable()->delete($review_id);
            return new JsonModel(array("returnCode" => 101, "msg" => $this->translate("Review Removed."), "result" => array("redirectTo" => '/admin/guide-reviews')));
        }
    }

    public function removeImageAction()
    {
        $img_id = $this->params()->fromRoute('id');
        $img = $this->getTrailCoverTable()->find($img_id);
        $this->getTrailCoverTable()->delete($img_id);
        $uploader = new Upload($this->getConfig());
        $uploader->removeFile($img->getCover());
        return new JsonModel(array("returnCode" => 101, "msg" => "Image has been removed"));
    }

    public function removeTrailAction()
    {
        if (!$this->getAdmin()->getId()) {
            return new JsonModel(array("returnCode" => 201, "msg" => $this->getErrorMsgZendFormat("You are not logged in")));
        }
        $id = $this->params()->fromRoute("id");
        $this->getTrailTable()->delete($id);
        return new JsonModel(array("returnCode" => 101, "msg" => 'Trail Removed'));
    }
}
