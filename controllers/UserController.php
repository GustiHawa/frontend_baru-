<?php
include_once '../config/database.php';
include_once '../models/User.php';

class UserController {
    private $db;
    private $user;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        $this->user = new User($this->db);
    }

    public function createUser($data) {
        // Validasi input
        if (empty($data['name']) || empty($data['password']) || empty($data['email']) || empty($data['role_id'])) {
            return json_encode(["message" => "Invalid input."]);
        }

        $this->user->name = $data['name'];
        $this->user->password = password_hash($data['password'], PASSWORD_BCRYPT);
        $this->user->email = $data['email'];
        $this->user->role_id = $data['role_id'];

        if ($this->user->create()) {
            return json_encode(["message" => "User was created."]);
        } else {
            return json_encode(["message" => "Unable to create user."]);
        }
    }

    public function loginUser($data) {
        // Validasi input
        if (empty($data['email']) || empty($data['password'])) {
            return json_encode(["message" => "Invalid input."]);
        }

        $this->user->email = $data['email'];
        $email_exists = $this->user->emailExists();

        if ($email_exists && password_verify($data['password'], $this->user->password)) {
            return json_encode([
                "message" => "Login successful.",
                "id" => $this->user->id,
                "name" => $this->user->name,
                "email" => $this->user->email,
                "role_id" => $this->user->role_id
            ]);
        } else {
            return json_encode(["message" => "Login failed. Invalid email or password."]);
        }
    }
}
?>