<?php
    class Vendor
    {
        // Connection
        private $conn;
        // Table
        private $db_table = "vendors";
        // Columns
        public $b_id;
        public $b_name;
        public $category;
        public $phone;
        public $image_url;
        public $location;
        public $latitude;
        public $longitude;
        public $location_id;
        public $contact_name;
        public $contact_mobile;
        public $created;

        // Db connection
        public function __construct($db)
        {
            $this->conn = $db;
        }

        private function _checkVendorExists()
        {
            $checkExisting = "SELECT * FROM vendors WHERE contact_mobile = $this->contact_mobile";
            $stmt = $this->conn->prepare($checkExisting);
            $stmt->execute();
            $count = $stmt->rowCount();

            if ($count == 1) {
                return true;
            } else {
                return false;
            }
        }

        // CREATE USER OTP
        public function createVendorOtp()
        {
            $otp = 1234;
            // $otp = rand(1111, 9999);
            $sqlQuery = "UPDATE
                        ". $this->db_table ."
                    SET
                        otp = $otp
                    WHERE 
                        contact_mobile = $this->contact_mobile";
                
            $stmt = $this->conn->prepare($sqlQuery);
            if ($stmt->execute()) {
                // $message = $twilio->messages
                // ->create("whatsapp:+91".$mobileNumber, // to
                //          array(
                //              "from" => "whatsapp:+14155238886",
                //              "body" => "Your Payanam OTP is ".$otp
                //          )
                // );
                return true;
            }
            return false;
        }

        public function verifyVendorOtp()
        {
            $checkExisting = "SELECT * FROM vendors WHERE contact_mobile = $this->contact_mobile and otp = $this->otp";

            $stmt = $this->conn->prepare($checkExisting);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count == 1) {
                //SET OTP NULL ONCE VERIFIED
                $this->createVendorOtp("NULL");
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                $user_arr = array(
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
                "created" => $created
                );
                return $user_arr;
            } else {
                return null;
            }
        }

        // GET ALL VENDORS
        public function getAllVendors($userLat, $userLong, $category)
        {
            $sqlQuery="";
            if ($category==null || $category=='all') {
                $sqlQuery = "SELECT b_id, b_name, category, phone, image_url, location, latitude, longitude, location_id, contact_name, contact_mobile, created,
                111111 *
                DEGREES(ACOS(LEAST(1.0, COS(RADIANS($userLat))
                    * COS(RADIANS(latitude))
                    * COS(RADIANS($userLong - longitude))
                    + SIN(RADIANS($userLat))
                    * SIN(RADIANS(latitude))))) AS distance
                FROM " . $this->db_table . "
                HAVING distance < 5100
                ORDER BY distance
                ";
            } else {
                $sqlQuery = "SELECT b_id, b_name, category, phone, image_url, location, latitude, longitude, location_id, contact_name, contact_mobile, created, 
                111111 *
                DEGREES(ACOS(LEAST(1.0, COS(RADIANS($userLat))
                    * COS(RADIANS(latitude))
                    * COS(RADIANS($userLong - longitude))
                    + SIN(RADIANS($userLat))
                    * SIN(RADIANS(latitude))))) AS distance
                FROM " . $this->db_table . " 
                WHERE 
                       category = '$category'
                HAVING distance < 5100
                ORDER BY distance
                ";
            }

            $stmt = $this->conn->prepare($sqlQuery);
            $stmt->execute();
            return $stmt;
        }

        // CREATE
        public function createVendor()
        {
            $sqlQuery = "INSERT INTO
                        ". $this->db_table ."
                    SET
                        b_name = :b_name, 
                        category = :category, 
                        phone = :phone, 
                        image_url = :image_url, 
                        location = :location, 
                        latitude = :latitude, 
                        longitude = :longitude, 
                        location_id = :location_id, 
                        contact_name = :contact_name, 
                        contact_mobile = :contact_mobile, 
                        created = :created";
            
            
            $stmt = $this->conn->prepare($sqlQuery);
            // sanitize
            $this->b_name=htmlspecialchars(strip_tags($this->b_name));
            $this->category=htmlspecialchars(strip_tags($this->category));
            $this->phone=htmlspecialchars(strip_tags($this->phone));
            $this->image_url=htmlspecialchars(strip_tags($this->image_url));
            $this->location=htmlspecialchars(strip_tags($this->location));
            $this->latitude=htmlspecialchars(strip_tags($this->latitude));
            $this->longitude=htmlspecialchars(strip_tags($this->longitude));
            $this->location_id=htmlspecialchars(strip_tags($this->location_id));
            $this->contact_name=htmlspecialchars(strip_tags($this->contact_name));
            $this->contact_mobile=htmlspecialchars(strip_tags($this->contact_mobile));
            $this->created=htmlspecialchars(strip_tags($this->created));
            // bind data
            $stmt->bindParam(":b_name", $this->b_name);
            $stmt->bindParam(":category", $this->category);
            $stmt->bindParam(":phone", $this->phone);
            $stmt->bindParam(":image_url", $this->image_url);
            $stmt->bindParam(":location", $this->location);
            $stmt->bindParam(":latitude", $this->latitude);
            $stmt->bindParam(":longitude", $this->longitude);
            $stmt->bindParam(":location_id", $this->location_id);
            $stmt->bindParam(":contact_name", $this->contact_name);
            $stmt->bindParam(":contact_mobile", $this->contact_mobile);
            $stmt->bindParam(":created", $this->created);

            //SEND OTP
            if ($this->createVendorOtp()) {
                return true;
            }
            return false;
        }
        
        // READ single
        public function getVendor()
        {
            $sqlQuery = "SELECT
                       b_id, b_name, category, phone, image_url, location, latitude, longitude, location_id, contact_name, contact_mobile, created 
                      FROM
                        ". $this->db_table ."
                    WHERE 
                       contact_mobile = ?
                    LIMIT 0,1";
            $stmt = $this->conn->prepare($sqlQuery);
            $stmt->bindParam(1, $this->contact_mobile);
            if ($stmt->execute()) {
                $dataRow = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($dataRow);
                $user_arr = array(
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
                    "created" => $created
                    );
                return $user_arr;
            }
            return null;
        }
    }
