<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace Application\Controller;

use Application\Controller\AbstractController;
use Zend\View\Model\JsonModel;
use Application\Custom\HashGenerator;
use Application\Custom\SimpleImage;

class UploadController extends AbstractController
{
    const IMG_UPLOAD_DIR = "/media/images/";

    public function indexAction()
    {
    }

    public function imageAction()
    {
        try {
            $type = $this->params()->fromPost('type', false);
            $postId = $this->params()->fromPost('post_id', false);
            $categoryId = $this->params()->fromPost('category_id', false);
            $galleryId = $this->params()->fromPost('gallery_id', false);

            $path_start = PUBLIC_PATH . self::IMG_UPLOAD_DIR;
            $url_start = self::IMG_UPLOAD_DIR;

            $request = $this->getRequest();
            if ($request->isPost()) {
                $adapter = new \Zend\File\Transfer\Adapter\Http();
                $adapter->setDestination($path_start);
                foreach ($adapter->getFileInfo() as $file => $info) {
                    $name = $adapter->getFileName($file);
                    $ext = "." . pathinfo($name, PATHINFO_EXTENSION);

                    $name_without_ext = time() . '_' . strtolower(HashGenerator::generate(6));

                    $imageDefault = array(
                        "PATH" => $path_start . $name_without_ext . $ext,
                        "URL" => $url_start . $name_without_ext . $ext,
                    );
                    $width = 150;
                    $height = 150;
                    $imageMedium = array(
                        "PATH" => $path_start . $name_without_ext . "_" . $width . "x" . $height . $ext,
                        "URL" => $url_start . $name_without_ext . "_" . $width . "x" . $height . $ext,
                    );

                    $adapter->addFilter(
                        new \Zend\Filter\File\Rename(array('target' => $imageDefault['PATH'],
                            'overwrite' => true)),
                        null, $file
                    );
                    if ($adapter->receive($file)) {
                        $simpleImage = new SimpleImage();

                        $simpleImage->load($imageDefault['PATH']);
                        $simpleImage->thumbnail($width, $height);
                        $simpleImage->save($imageMedium['PATH']);
                    }
                    if ($postId || $categoryId || $galleryId) {
                        $image = $this->getImageTable()->createNew();

                        if ($postId){
                            $image->setPostId($postId);
                        }
                        if ($categoryId){
                            $image->setCategoryId($categoryId);
                        }
                        if ($galleryId){
                            $image->setGalleryId($galleryId);
                        }
                        $image->setPath($imageDefault['URL']);
                        $image->setThumbPath($imageMedium['URL']);

                        $image = $this->getImageTable()->save($image);
                    }
                }
            }

            return new JsonModel(array(
                'returnCode' => 101,
                'result' => array(
                    'imageUrl' => $imageDefault['URL'],
                    'imageId' => $image->getId(),
                ),
                'msg' => 'Image has been uploaded',
            ));
        } catch (\Exception $e) {
            return new JsonModel(array(
                'returnCode' => 201,
                'msg' => $e->getMessage(),
            ));
        }

    }

    public function multipleImageAction()
    {
        try {
            $type = $this->params()->fromPost('type', false);
            $postId = $this->params()->fromPost('post_id', false);
            $categoryId = $this->params()->fromPost('category_id', false);
            $galleryId = $this->params()->fromPost('gallery_id', false);

            $path_start = PUBLIC_PATH . self::IMG_UPLOAD_DIR;
            $url_start = self::IMG_UPLOAD_DIR;

            $request = $this->getRequest();
            $imagePaths = array();
            $imageObjects = array();
            if ($request->isPost()) {
                $adapter = new \Zend\File\Transfer\Adapter\Http();
                $adapter->setDestination($path_start);
                //echo "<pre>"; print_r($adapter->getFileInfo()); exit;
                foreach ($adapter->getFileInfo() as $file => $info) {
                    $name = $adapter->getFileName($file);
                    $ext = "." . pathinfo($name, PATHINFO_EXTENSION);

                    $name_without_ext = time() . '_' . strtolower(HashGenerator::generate(6));

                    $imageDefault = array(
                        "PATH" => $path_start . $name_without_ext . $ext,
                        "URL" => $url_start . $name_without_ext . $ext,
                    );
                    $imagePaths []= $imageDefault;
                    $width = 300;
                    $height = 300;
                    $imageMedium = array(
                        "PATH" => $path_start . $name_without_ext . "_" . $width . "x" . $height . $ext,
                        "URL" => $url_start . $name_without_ext . "_" . $width . "x" . $height . $ext,
                    );

                    $adapter->addFilter(
                        new \Zend\Filter\File\Rename(array('target' => $imageDefault['PATH'],
                            'overwrite' => true)),
                        null, $file
                    );
                    //echo ($name) . "<br>";
                    //echo "<pre>"; print_r($imageDefault);  echo "</pre>";
                    if ($adapter->receive($file)) {
                        $simpleImage = new SimpleImage();

                        $simpleImage->load($imageDefault['PATH']);
                        $simpleImage->thumbnail($width, $height);
                        $simpleImage->save($imageMedium['PATH']);
                    }
                    if ($postId || $categoryId || $galleryId) {
                        $image = $this->getImageTable()->createNew();

                        if ($postId){
                            $image->setPostId($postId);
                        }
                        if ($categoryId){
                            $image->setCategoryId($categoryId);
                        }
                        if ($galleryId){
                            $image->setGalleryId($galleryId);
                        }
                        $image->setPath($imageDefault['URL']);
                        $image->setThumbPath($imageMedium['URL']);

                        $image = $this->getImageTable()->save($image);

                        $imageObjects [] = $image->getArrayCopy();
                    }
                }
            }
            //exit;
            return new JsonModel(array(
                'returnCode' => 101,
                'result' => array(
                    'imagePaths' => $imagePaths,
                    'imageObjects' => $imageObjects,
                ),
                'msg' => 'Images have been uploaded',
            ));
        } catch (\Exception $e) {
            return new JsonModel(array(
                'returnCode' => 201,
                'msg' => $e->getMessage(),
            ));
        }

    }

    public function templateImageAction()
    {
        try {
            $templateId = $this->params()->fromPost('template_id', false);

            $path_start = PUBLIC_PATH . self::IMG_UPLOAD_DIR;
            $url_start = self::IMG_UPLOAD_DIR;

            $request = $this->getRequest();
            if ($request->isPost()) {
                $adapter = new \Zend\File\Transfer\Adapter\Http();
                $adapter->setDestination($path_start);

                $data = $request->getPost()->toArray();
                //echo "<pre>"; print_r($data); exit;

                foreach ($adapter->getFileInfo() as $file => $info) {
                    $name = $adapter->getFileName($file);
                    $ext = "." . pathinfo($name, PATHINFO_EXTENSION);

                    $name_without_ext = time() . '_' . strtolower(HashGenerator::generate(6));

                    $imageDefault = array(
                        "PATH" => $path_start . $name_without_ext . $ext,
                        "URL" => $url_start . $name_without_ext . $ext,
                    );


                    $adapter->addFilter(
                        new \Zend\Filter\File\Rename(array('target' => $imageDefault['PATH'],
                            'overwrite' => true)),
                        null, $file
                    );
                    if ($adapter->receive($file)) {
                        $simpleImage = new SimpleImage();

                        $simpleImage->load($imageDefault['PATH']);
                    }
                    //$this->getTemplateTable()->cancelAll();
                    if ($templateId) {
                        $template = $this->getTemplateTable()->find($templateId);
                        //$template->setActive(1);
                        @unlink(PUBLIC_PATH . $template->getPath());
                        $template->setPath($imageDefault['URL']);
                        $template = $this->getTemplateTable()->save($template);
                    }
                    else {
                        $template = $this->getTemplateTable()->createNew();
                        $template->setPath($imageDefault['URL']);

                        if (isset($data['template_lang'])){
                            $template->setLang($data['template_lang']);
                        }
                        if (isset($data['template_title'])){
                            $template->setTitle($data['template_title']);
                        }

                        $activeTemplate = $this->getTemplateTable()->findActive();
                        if (!$activeTemplate){
                            $template->setActive(1);
                        }

                        $template = $this->getTemplateTable()->save($template);
                    }
                }
            }

            return new JsonModel(array(
                'returnCode' => 101,
                'result' => array(
                    'imageUrl' => $imageDefault['URL'],
                    'templateId' => $template->getId(),
                ),
                'msg' => 'Image has been uploaded',
            ));
        } catch (\Exception $e) {
            return new JsonModel(array(
                'returnCode' => 201,
                'msg' => $e->getMessage(),
            ));
        }

    }
}
