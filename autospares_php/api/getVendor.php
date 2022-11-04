<?php
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods:*");
header("Access-Control-Allow-Headers:*");

    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Max-Age: 3600");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    include_once '../models/vendor.php';
    include_once '../config/database.php';
    $database = new Database();
    $db = $database->getConnection();

    $item = new Vendor($db);
    $key=array_key_first($_GET);
    $item->$key = isset($_GET[$key]) ? $_GET[$key] : die();
    $emp_arr = $item->getVendor();
    // $row = $stmt->fetch(PDO::FETCH_ASSOC);
    //         extract($row);

    if ($emp_arr!= null) {
        //     // create array
        //      = array(
        //        "b_id" => $item->b_id,
        //         "b_name" => $item->b_name,
        //         "category" => $item->category,
        //         "phone" => $item->phone,
        //         "image_url" => $item->image_url,
        //         "location" => $item->location,
        //         "contact_name" => $item->contact_name,
        //         "contact_mobile" => $item->contact_mobile,
        //         "created" => $item->created,
        //     );
      
        http_response_code(200);
        echo json_encode($emp_arr);
    } else {
        http_response_code(404);
        echo json_encode("Vendor not found.");
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
