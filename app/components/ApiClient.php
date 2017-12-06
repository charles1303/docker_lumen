<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/10/17
 * Time: 8:06 AM
 */

namespace App\components;

use GuzzleHttp\Client as GuzzleHttpClient;
use GuzzleHttp\Exception\RequestException;


class ApiClient {

    protected $guzzleClient;

    public function __construct(GuzzleHttpClient $guzzleClient)
    {
        $this->guzzleClient = $guzzleClient;
    }

    public function get($url)
    {
        try {

            $apiRequest = $this->guzzleClient->request('GET', $url);
            $content = json_decode($apiRequest->getBody()->getContents());
            return $content;

        } catch (RequestException $re) {
            throw $re;
        }
    }

    public function post($url, $data)
    {
        try {
            $apiRequest = $this->guzzleClient->request('POST', $url, ['json' =>$data]);
            $content = json_decode($apiRequest->getBody()->getContents());
            return $content;

        } catch (RequestException $re) {
            throw $re;
        }
    }

    public function put($url, $data)
    {
        try {

            $apiRequest = $this->guzzleClient->request('PUT', $url, ['json' =>$data]);
            $content = json_decode($apiRequest->getBody()->getContents());
            return $content;

        } catch (RequestException $re) {
            throw $re;
        }
    }

}