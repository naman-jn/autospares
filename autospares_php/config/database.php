<?php
    class Database
    {
        private $host = "127.0.0.1";
        private $database_name = "autostuff";
        private $username = "root";
        private $password = '';
        // private $host = "localhost";
        // private $database_name = "itkso3ms_autostuff";
        // private $username = "itkso3ms_autostuff";
        // private $password = 'y?_ea{HNGg2k';
        public $conn;
        public function getConnection()
        {
            $this->conn = null;
            try {
                $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->database_name, $this->username, $this->password);
                $this->conn->exec("set names utf8");
                // echo "Database connected successfully";
            } catch (PDOException $exception) {
                echo "Database could not be connected: " . $exception->getMessage();
            }
            return $this->conn;
        }
    }
