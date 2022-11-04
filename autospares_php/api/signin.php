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
    $tag = $_GET["tag"];

    try {
        $mobileNumber = $data->mobileNumber;
        $relationalService = new RelationalService($db);
        $type= $relationalService->checkMobileExists($mobileNumber);
        if ($type==null) {
            throw new ErrorException("mobile number doesn't exist");
        } elseif ($type=="user") {
            $item = new User($db);
            $item->mobile = $mobileNumber;
        } elseif ($type=="vendor") {
            $item = new Vendor($db);
            
            $item->contact_mobile = $mobileNumber;
        }

        if ($tag =="login") {
            //LOGIN
            if ($type=="user"?$item->createUserOtp():$item->createVendorOtp()) {
                echo json_encode(array('result'=>true,'message'=>"OTP sent"));
            } else {
                http_response_code(404);
                echo json_encode(array("result"=>false,"message"=>"Some error occured"));
            }
        } elseif ($tag=="verifyOtp") {
            //VERIFY OTP
            $item->otp = $data->otp;
            if ($type=="user") {
                $result=$item->verifyUserOtp();
            } elseif ($type=="vendor") {
                $result=$item->verifyVendorOtp();
            }
        
            if ($result!=null) {
                http_response_code(200);
                $subData=array('type'=>$type);
                echo json_encode(array('result'=>true,'message'=>"OTP verified",'data'=>$result,'subData'=>$subData));
            } else {
                http_response_code(404);
                echo json_encode(array("result"=>false,"message"=>"Incorrect otp"));
            }
        }
    } catch (\Throwable $e) {
        handleError($e);
    } catch (Exception $e) {
        handleError($e);
    }
