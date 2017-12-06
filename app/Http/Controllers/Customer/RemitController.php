<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/9/17
 * Time: 1:41 PM
 */

namespace App\Http\Controllers\Customer;


use App\Http\Controllers\Controller;;
use App\components\ApiClient;
use App\helpers\RemitHelper;
use Illuminate\Http\Request;

use Log;

class RemitController extends Controller{

    protected $apiClient;

    /**
     * @param ApiClient $apiClient
     */
    public function __construct(ApiClient $apiClient)
    {
        $this->apiClient = $apiClient;
    }



    public function getTransaction($reference)
    {
        $data = [];
        try{
            $response = $this->apiClient->get($reference);
            $remitHelper = new RemitHelper();
            $data = $remitHelper->objectToArray($response);
        }catch (\Exception $e){
            Log::info('Error : ' . $e->getMessage());
        }

        return view('customer.index', ['data' =>$data]);
    }

    public function updateTransaction(Request $request){
        $postRequest = $request->request->all();
        $transaction_id = isset($postRequest['data']['transaction_id']) ? $postRequest['data']['transaction_id'] : " ";
        $update = isset($postRequest['data']) ? $postRequest['data'] : '';
        $response = $this->apiClient->put($transaction_id,$update);

        return response()->json($response);
    }

    public function postTransaction(Request $request){
        $postRequest = $request->request->all();
        $transaction_id = isset($postRequest['data']['transaction_id']) ? $postRequest['data']['transaction_id'] : " ";
        $update = isset($postRequest['data']) ? $postRequest['data'] : '';
        $response = $this->apiClient->post($transaction_id,$update);

        return response()->json($response);
    }


}