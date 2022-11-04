<?php
    class RelationalService
    {
        // Connection
        private $conn;

        // Db connection
        public function __construct($db)
        {
            $this->conn = $db;
        }

        public function checkMobileExists($mobileNumber)
        {
            $checkExisting = "SELECT contact_mobile AS mobile_number, 'vendor' as type
                                FROM vendors 
                                WHERE contact_mobile = $mobileNumber
                              UNION
                              SELECT mobile AS mobile_number, 'user' as type
                                FROM users 
                                WHERE mobile = $mobileNumber
                              ";
            $stmt = $this->conn->prepare($checkExisting);
            $stmt->execute();
            $count = $stmt->rowCount();
            if ($count == 1) {
                $dataRow = $stmt->fetch(PDO::FETCH_ASSOC);
                $type = $dataRow['type'];
                return $type;
            } else {
                return null;
            }
        }
    }
