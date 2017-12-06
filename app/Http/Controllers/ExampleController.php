<?php

namespace App\Http\Controllers;

use App\components\OAuthClient;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Redis;
use Log;

class ExampleController extends Controller
{
    protected $oAuthClient;

    /**
     * @param OAuthClient $oAuthClient
     */
    public function __construct(OAuthClient $oAuthClient)
    {
        $this->oAuthClient = $oAuthClient;
    }

    public function getToken(){

        Log::info('Logging here: ');
        //$response = $this->oAuthClient->getAccessToken();
        //var_dump($response);
        //die;
    }
}
