<?php

namespace Application\Controller;

use Symfony\Component\Config\Definition\Exception\Exception;
use Zend\View\Model\JsonModel;
use Zend\View\Model\ViewModel;

class ActionController extends AbstractController
{

    public function widgetAction()
    {

        $widget = $this->getWidgetTable()->find($this->params()->fromRoute("id"));
        $result = array();
        $result['widget'] = $widget;

        if ($widget->getId() == 1) {
            // interesting posts
            $result['posts'] = $this->getPostTable()->findAllPosts(array(
                "active" => true,
            ));

        } else if ($widget->getId() == 3) {
            //Related posts
            if ($this->params()->fromPost("postId")) {
                $post = $this->getPostTable()->find($this->params()->fromPost("postId"));
                $result['posts'] = $this->getPostTable()->findRelatedPosts($post);
            }

        } else if ($widget->getId() == 4) {
            //last news
            $result['posts'] = $this->getPostTable()->findAllPosts(array(
                "categoryId" => 1,
                "active" => true,
            ));
        } else if ($widget->getId() == 7) {
            //reviews (testimonial)
            $result['review'] = $this->getReviewTable()->findOneRandom();
        }

        $htmlViewPart = new ViewModel();
        $htmlViewPart->setTerminal(true)
            ->setTemplate("application/action/widget")
            ->setVariables($result);

        $htmlBody = $this->getServiceLocator()
            ->get('viewrenderer')
            ->render($htmlViewPart);

        return new JsonModel(array(
            "returnCode" => 101,
            "result" => array(
                "html" => $htmlBody,
            ),
        ));
        //return  $result;
    }

    public function bookingAction(){
        $request = $this->getRequest();
        if ($request->isPost()) {
            $data = $request->getPost()->toArray();
            $mailArgs = array(
                "name" => $data['name'],
                "surname" => $data['surname'],
                "email" => $data['email'],
                "phone" => $data['phone'],
                "arrive" => $data['arrive'],
                "depart" => $data['depart'],
                "adults" => $data['adults'],
                "children" => $data['children'],
                "roomType" => $this->getRoomTable()->getRoomTypeById($data['room']),
                "comments" => $data['comments'],
            );
            $this->sendMailWithTemplate(
                "bookingForm",
                $mailArgs,
                "New booking from Mirhav website",
                $data['email'],
                "aram@bigbek.com, narine@bigbek.com"
            );

            $order = $this->getOrderTable()->createNew();
            $order->setFirstName($data['name']);
            $order->setLastName($data['surname']);
            $order->setUserEmail($data['email']);
            $order->setUserPhone($data['phone']);
            $order->setStartTime($data['arrive']);
            $order->setFinishTime($data['depart']);
            $order->setAdults($data['adults']);
            $order->setChildren($data['children']);
            $order->setRoomTypeId($data['room']);
            //$roomType = $this->getRoomTable()->getRoomTypeById($data['room']);
            $order->setDetails($data['comments']);
            $this->getOrderTable()->save($order);

            /*$message = "You have a new reservation request.<br/>";
            $message .= "Name: " . $this->params()->fromPost('name') ."<br/>";
            $message .= "Email: " . $this->params()->fromPost('email') ."<br/>";
            $message .= "Arrive: " . $this->params()->fromPost('arrive') ."<br/>";
            $message .= "Depart: " . $this->params()->fromPost('depart') ."<br/>";
            $message .= "Adults: " . $this->params()->fromPost('adults') ."<br/>";
            $message .= "Children: " . $this->params()->fromPost('children') ."<br/>" ;
            $message .= "Room type: " . $roomType."<br/>" ;
            $message .= "Comments: " . $this->params()->fromPost('comments') ."<br/>" ;

            $this->sendMail($message, "", "New booking", $this->params()->fromPost('email'), "aram@bigbek.com");*/
            return new JsonModel(array(
                "returnCode" => 101,
                //"message" => $this->translate("booking_success_message")
            ));
        }

    }

    public function contactAction(){
        try{
            $request = $this->getRequest();
            if ($request->isPost()) {
                $data = $request->getPost()->toArray();
                $mailArgs = array(
                    "name" => $data['name'],
                    "email" => $data['email'],
                    "subject" => $data['subject'],
                    "message" => $data['message'],
                );
                $this->sendMailWithTemplate(
                    "contactForm",
                    $mailArgs,
                    "New mail from Mirhav website contact form",
                    $data['email'],
                    "aram@bigbek.com, narine@bigbek.com"
                );

                /*$message = "You have a new letter.<br/>";
                $message .= "Name: " . $this->params()->fromPost('name') ."<br/>";
                $message .= "Email: " . $this->params()->fromPost('email') ."<br/>";
                $message .= "Subject: " . $this->params()->fromPost('subject') ."<br/>";
                $message .= "Message: " . $this->params()->fromPost('message') ."<br/>" ;

                $this->sendMail($message, "", "New mail from Mirhav website contact form", $this->params()->fromPost('email'), "aram@bigbek.com");*/
            }

        }
        catch (Exception $e){
            echo $e->getMessage();
        }

        return new JsonModel(array(
            "returnCode" => 101,
        ));
    }

    public function reviewAction(){
        $request = $this->getRequest();
        if ($request->isPost()) {
            $review = $this->getReviewTable()->createNew();
            $data = $request->getPost()->toArray();
            $review->setName($data['author'], $this->getLang());
            $review->setEmail($data['email']);
            $review->setUrl($data['url']);
            $review->setDescription($data['comment'], $this->getLang());
            $review->setStatus('pending');
            $review = $this->getReviewTable()->save($review);
            return new JsonModel(array(
                "returnCode" => 101,
                //"message" => $this->translate("booking_success_message")
            ));
        }
    }
}