<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/9/17
 * Time: 1:46 PM
 */

namespace App\Http\Middleware;

use Closure;

class Logging {

    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        //To handle all application loggings
        return $next($request);
    }

    public function terminate($request, $response)
    {
        // Store the session data...
    }

}