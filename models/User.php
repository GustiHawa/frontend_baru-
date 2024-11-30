<?php
class User {
    private $conn;
    private $table_name = "users";

    public $id;
    public $name;
    public $password;
    public $email;
    public $role_id;
    public $created_at;
    public $updated_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . " SET name=:name, password=:password, email=:email, role_id=:role_id";

        $stmt = $this->conn->prepare($query);

        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->password = htmlspecialchars(strip_tags($this->password));
        $this->email = htmlspecialchars(strip_tags($this->email));
        $this->role_id = htmlspecialchars(strip_tags($this->role_id));

        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":password", $this->password);
        $stmt->bindParam(":email", $this->email);
        $stmt->bindParam(":role_id", $this->role_id);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }

    public function emailExists() {
        $query = "SELECT id, name, password, role_id FROM " . $this->table_name . " WHERE email = ? LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->email);
        $stmt->execute();

        $num = $stmt->rowCount();

        if ($num > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);

            $this->id = $row['id'];
            $this->name = $row['name'];
            $this->password = $row['password'];
            $this->role_id = $row['role_id'];

            return true;
        }

        return false;
    }
}
?>