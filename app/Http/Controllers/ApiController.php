<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/9/17
 * Time: 2:21 PM
 */

namespace App\Http\Controllers;

use GuzzleHttp\Client as GuzzleHttpClient;
use GuzzleHttp\Exception\RequestException;


class ApiController {

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

            $apiRequest = $this->guzzleClient->request('POST', $url, $data);
            $content = json_decode($apiRequest->getBody()->getContents());
            return $content;

        } catch (RequestException $re) {
            throw $re;
        }
    }

    public function put($url, $data)
    {
        try {

            $apiRequest = $this->guzzleClient->request('PUT', $url, $data);
            $content = json_decode($apiRequest->getBody()->getContents());
            return $content;

        } catch (RequestException $re) {
            throw $re;
        }
    }

}