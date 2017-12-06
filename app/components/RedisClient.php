<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/11/17
 * Time: 12:13 PM
 */

namespace App\components;

use Illuminate\Support\Facades\Redis;

class RedisClient {

    public function get($key){
        return json_decode(Redis::get(config('app.cache_prefix').'.'.$key));

    }

    public function set($key, $value){
        Redis::set(config('app.cache_prefix').'.'.$key, json_encode($value));
    }
}