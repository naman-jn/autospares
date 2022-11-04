<?php
    class User
    {
        // Connection
        private $conn;
        // Table
        private $db_table = "users";
        // Columns
        public $id;
        public $name;
        public $mobile;
        public $email;
        public $pincode;
        public $city;
        public $created;
        public $otp;

        // Db connection
        public function __construct($db)
        {
            $this->conn = $db;
        }

        private function _checkUserExists()
        {
            $checkExisting = "SELECT * FROM users WHERE mobile = '$this->mobile'";
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
        public function createUserOtp()
        {
            $otp = 1234;
            // $otp = rand(1111, 9999);

            $sqlQuery = "UPDATE
                        ". $this->db_table ."
                    SET
                        otp = $otp
                    WHERE 
                        mobile = $this->mobile";
                
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

        public function verifyUserOtp()
        {
            $checkExisting = "SELECT * FROM users WHERE mobile = $this->mobile and otp = $this->otp";
            $stmt = $this->conn->prepare($checkExisting);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count == 1) {
                //SET OTP NULL ONCE VERIFIED
                $this->createUserOtp("NULL");
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                extract($row);
                $user_arr = array(
                "name" => $name,
                "mobile" => $mobile,
                "email" => $email,
                "pincode" => $pincode,
                "city" => $city,
                "created" => $created
                );
                return $user_arr;
            } else {
                return null;
            }
        }

        // GET ALL USERS
        public function getAllUsers()
        {
            $sqlQuery = "SELECT id, name, mobile, email, pincode, city, created  FROM " . $this->db_table . "";
            $stmt = $this->conn->prepare($sqlQuery);
            $stmt->execute();
            return $stmt;
        }

        // CREATE USER
        public function createUser()
        {
            $sqlQuery = "INSERT INTO
                        ". $this->db_table ."
                    SET
                        name = :name, 
                        mobile = :mobile, 
                        email = :email, 
                        pincode = :pincode, 
                        city = :city,
                        created = :created";
            
            $stmt = $this->conn->prepare($sqlQuery);
            // sanitize
            $this->name=htmlspecialchars(strip_tags($this->name));
            $this->mobile=htmlspecialchars(strip_tags($this->mobile));
            $this->email=htmlspecialchars(strip_tags($this->email));
            $this->pincode=htmlspecialchars(strip_tags($this->pincode));
            $this->city=htmlspecialchars(strip_tags($this->city));
            $this->created=htmlspecialchars(strip_tags($this->created));
            // bind data
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":mobile", $this->mobile);
            $stmt->bindParam(":email", $this->email);
            $stmt->bindParam(":pincode", $this->pincode);
            $stmt->bindParam(":city", $this->city);
            $stmt->bindParam(":created", $this->created);

            if ($stmt->execute()) {
                //SEND OTP
                if ($this->createUserOtp()) {
                    return true;
                }
            }
            return false;
        }

        // READ single
        public function getUser()
        {
            if ($this->_checkUserExists()) {
                $sqlQuery = "SELECT
                       id, name, mobile, email, pincode, city, created  
                      FROM
                        ". $this->db_table ."
                    WHERE 
                       mobile = ?
                    LIMIT 0,1";

                $stmt = $this->conn->prepare($sqlQuery);
                $stmt->bindParam(1, $this->mobile);
                if ($stmt->execute()) {
                    $dataRow = $stmt->fetch(PDO::FETCH_ASSOC);
                    extract($dataRow);
                    $user_arr = array(
                    "name" => $name,
                    "mobile" => $mobile,
                    "email" => $email,
                    "pincode" => $pincode,
                    "city" => $city,
                    "created" => $created
                    );
                    return $user_arr;
                }
            }
            return null;
        }
    }
