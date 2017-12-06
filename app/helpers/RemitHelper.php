<?php
/**
 * Created by PhpStorm.
 * User: charles
 * Date: 11/10/17
 * Time: 10:03 AM
 */

namespace App\helpers;

use Log;
class RemitHelper {



    public function objectToArray($d) {
        if (is_object($d)) {
            $d = get_object_vars($d);
        }

        if (is_array($d)) {
            return array_map(array($this, 'objectToArray'), $d);

        }
        else {
            return $d;
        }
    }



}