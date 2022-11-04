<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    include_once '../services/error_handling.php';
    include_once '../models/vendor.php';
    include_once '../config/database.php';
    
    date_default_timezone_set("Asia/Kolkata");
    ini_set('display_errors', 1);
    set_error_handler(function ($err_severity, $err_msg, $err_file, $err_line, array $err_context) {
        throw new ErrorException($err_msg, 0, $err_severity, $err_file, $err_line);
    }, E_WARNING);

    $database = new Database();
    $db = $database->getConnection();
    

    try {
        $userLat=isset($_GET['userLat']) ? $_GET['userLat'] : null;
        $userLong=isset($_GET['userLong']) ? $_GET['userLong'] : null;
        $category=isset($_GET['category']) ? $_GET['category'] : null;

        $items = new Vendor($db);
        $stmt = $items->getAllVendors($userLat, $userLong, $category);
        $itemCount = $stmt->rowCount();

        if ($itemCount > 0) {
            $vendorArr = array();
   
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                extract($row);
                //ROUND OFF DISTANCE
                if ($distance<50) {
                    $distance=round($distance, -1);
                } else {
                    $distance=round($distance / 50) * 50;
                }

                $e = array(
                "b_id" => $b_id,
                "b_name" => $b_name,
                "category" => $category,
                "phone" => $phone,
                "image_url" => $image_url,
                "location" => $location,
                "latitude" => $latitude,
                "longitude" => $longitude,
                "location_id" => $location_id,
                "contact_name" => $contact_name,
                "contact_mobile" => $contact_mobile,
                "created" => $created,
                "distance" => $distance,
                );
                array_push($vendorArr, $e);
            }
            echo json_encode(array('result'=>true,'message'=>"Success",'data'=>$vendorArr));
        } else {
            http_response_code(404);
            echo json_encode(array('result'=>false,'message'=>"No record found"));
        }
    } catch (\Throwable $e) {
        handleError($e);
    } catch (Exception $e) {
        handleError($e);
    }

//     void main() {
    //   String x ="b_id, b_name, category, phone, image_url, location, contact_name, contact_mobile, created";
    
    //   var y=x.split(",");
    
    //   for(String i in y){
//     i=i.trim();
//     print('"$i" => \$$i, \n');
    //   }
    //   print(y);
    // }
