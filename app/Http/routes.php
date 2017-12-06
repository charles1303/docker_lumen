<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

/*
$app->get('/key', function () use ($app) {
    return str_random(32);
});
*/

$app->get('/', function () use ($app) {
    return redirect()->route('home',['reference' => 'invalid']);
});

$app->get('/test', [
    'as' => 'test', 'uses' => 'ExampleController@getToken'
]);


$app->group(['namespace' => 'Customer'], function() use ($app) {
    // Using The "App\Http\Controllers\Customer" Namespace...

    $app->get('/{reference}', [
        'as' => 'home', 'uses' => 'RemitController@getTransaction'
    ]);
    $app->post('/transaction', [
        'as' => 'update', 'uses' => 'RemitController@updateTransaction'
    ]);

    $app->post('/details', [
        'as' => 'details', 'uses' => 'RemitController@postTransaction'
    ]);


});

