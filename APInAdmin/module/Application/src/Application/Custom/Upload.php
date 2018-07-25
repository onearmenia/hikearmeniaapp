<?php
namespace Application\Custom;

use Application\Custom\HashGenerator;
use Application\Custom\SimpleImage;
use Aws\S3\S3Client;

class Upload
{
    private $config;

    public function __construct($config)
    {
        $this->config = $config;
    }
    const PROTOCOL = "http://";
    const UPLOAD_DIR = "/media/images/";

    public function uploadFile($file, $name)
    {
        $adapter = new \Zend\File\Transfer\Adapter\Http();
        $path_start = PUBLIC_PATH . self::UPLOAD_DIR;
        $url_start = self::UPLOAD_DIR;
        $ext = "." . pathinfo($name, PATHINFO_EXTENSION);
        $name_without_ext = time() . '_' . strtolower(HashGenerator::generate(6));
        $filename = $name_without_ext . $ext;
        $filePath = $path_start . $filename;
        $adapter->addFilter(
            new \Zend\Filter\File\Rename(array('target' => $filePath,
                'overwrite' => true)),
            null, $file
        );
        $adapter->receive($file);
        if (isset($this->config->image_upload) && $this->config->image_upload == "s3") {
            try {
                $newpath =  $this->UploadS3($filename, $filePath);
                @unlink($_SERVER['DOCUMENT_ROOT'] . $filePath);
                return $newpath;

            } catch (\Exception $e) {
                @unlink($_SERVER['DOCUMENT_ROOT'] . $filePath);
                echo $e->getMessage();
                exit;
            }

        }

        return  self::PROTOCOL.$_SERVER['SERVER_NAME'].$url_start . $filename;
    }

    public function UploadS3($filename, $filePath)
    {
        $client = S3Client::factory(array(
            'credentials' => array(
                'key' => $this->config->s3['aws_access_key_id'],
                'secret' => $this->config->s3['aws_secret_access_key'],
            )
        ));
        $result1 = $client->putObject(array(
            'Bucket' => $this->config->s3['bucket'],
            'Key' => self::UPLOAD_DIR.$filename,
            'SourceFile' => $filePath,
            'ACL' => 'public-read'
        ));
        return $result1['ObjectURL'];
    }

    public function uploadFromUrl($url)
    {
        $filename =  time() . '_' . strtolower(HashGenerator::generate(6)) . '.jpg';
        $path_start = PUBLIC_PATH . self::UPLOAD_DIR;
        $filePath = $path_start . $filename;
        $fd = fopen($_SERVER['DOCUMENT_ROOT'] .self::UPLOAD_DIR . $filename, 'w+');
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_BINARYTRANSFER,true);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_FILE, $fd);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER,false);
        curl_exec($ch);
        fclose($fd);
        curl_close($ch);
        if (isset($this->config->image_upload) && $this->config->image_upload == "s3") {
            try {
                return $this->UploadS3($filename, $filePath);
            } catch (\Exception $e) {
                echo $e->getMessage();
                exit;
            }

        }

        return self::PROTOCOL.$_SERVER['SERVER_NAME'].$filename;
    }

    public function uploadFromBase64($base64)
    {
        $url_start = self::UPLOAD_DIR;
        $filename =  time() . '_' . strtolower(HashGenerator::generate(6)) . '.jpg';
        $path_start = PUBLIC_PATH . self::UPLOAD_DIR;
        $filePath = $path_start . $filename;
        $ifp = fopen($_SERVER['DOCUMENT_ROOT'] . self::UPLOAD_DIR.$filename, "wb");
        fwrite($ifp, base64_decode($base64));
        fclose($ifp);
        if (isset($this->config->image_upload) && $this->config->image_upload == "s3") {
            try {
                return $this->UploadS3($filename, $filePath);
            } catch (\Exception $e) {
                echo $e->getMessage();
                exit;
            }
        }

        return self::PROTOCOL.$_SERVER['SERVER_NAME']. $filename;
    }
    public function removeFile($imgPath){
        if (isset($this->config->image_upload) && $this->config->image_upload == "s3") {
            try {
                $client = S3Client::factory(array(
                    'credentials' => array(
                        'key' => $this->config->s3['aws_access_key_id'],
                        'secret' => $this->config->s3['aws_secret_access_key'],
                    )
                ));
               return  $client->deleteObject(array(
                    'Bucket' => $this->config->s3['bucket'],
                    'Key'    => $imgPath
                ));

            } catch (\Exception $e) {
                echo $e->getMessage();
                exit;
            }
        }

        return @unlink($_SERVER['DOCUMENT_ROOT'].$imgPath);

    }
}
