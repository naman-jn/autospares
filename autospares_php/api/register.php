<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    include_once '../services/error_handling.php';
    include_once '../services/relational_service.php';
    include_once '../config/database.php';
    include_once '../models/vendor.php';
    include_once '../models/user.php';

    date_default_timezone_set("Asia/Kolkata");
    ini_set('display_errors', 1);
    set_error_handler(function ($err_severity, $err_msg, $err_file, $err_line, array $err_context) {
        throw new ErrorException($err_msg, 0, $err_severity, $err_file, $err_line);
    }, E_WARNING);

    $database = new Database();
    $db = $database->getConnection();
    $data = json_decode(file_get_contents("php://input"));
    $type = $_GET["type"];
    $item;
    $mobileNumber;
    $relationalService = new RelationalService($db);
    
    try {
        if ($type=="user") {
            $mobileNumber = $data->mobile;
            $item = new User($db);
            $item->name = $data->name;
            $item->mobile = $data->mobile;
            $item->email = $data->email;
            $item->pincode = $data->pincode;
            $item->city = $data->city;
            $item->created = date('Y-m-d H:i:s');
        } elseif ($type=="vendor") {
            $mobileNumber = $data->contact_mobile;
            $image_url="../images/$mobileNumber.jpg";
            //Image upload
            $realImage = base64_decode($data->image);
            file_put_contents($image_url, $realImage);

            $item = new Vendor($db);
            $item->b_name = $data->b_name;
            $item->category = $data->category;
            $item->phone = $data->phone;
            $item->image_url = "https://domain/images/$mobileNumber.jpg";
            $item->location = $data->location;
            $item->latitude = $data->latitude;
            $item->longitude = $data->longitude;
            $item->location_id = $data->location_id;
            $item->contact_name = $data->contact_name;
            $item->contact_mobile = $data->contact_mobile;
            $item->created = date('Y-m-d H:i:s');
        }
        if ($relationalService->checkMobileExists($mobileNumber)!=null) {
            throw new ErrorException("mobile number already in use");
        }

        if ($type=="user"?$item->createUser():$item->createVendor()) {
            echo json_encode(array('result'=>true,'message'=>"$type registered & otp sent"));
        } else {
            http_response_code(500);
            echo json_encode(array('result'=>false,'message'=>"$type could not be created"));
        }
    } catch (\Throwable $e) {
        handleError($e);
    } catch (Exception $e) {
        handleError($e);
    }
