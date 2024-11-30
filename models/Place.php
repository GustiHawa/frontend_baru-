<?php
class Place {
    private $conn;
    private $table_name = "places";

    public $id;
    public $name;
    public $address;
    public $facilities;
    public $capacity;
    public $price;
    public $main_photo;
    public $owner_id;
    public $created_at;
    public $updated_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create() {
        $query = "INSERT INTO " . $this->table_name . " SET name=:name, address=:address, facilities=:facilities, capacity=:capacity, price=:price, main_photo=:main_photo, owner_id=:owner_id";

        $stmt = $this->conn->prepare($query);

        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->address = htmlspecialchars(strip_tags($this->address));
        $this->facilities = htmlspecialchars(strip_tags($this->facilities));
        $this->capacity = htmlspecialchars(strip_tags($this->capacity));
        $this->price = htmlspecialchars(strip_tags($this->price));
        $this->main_photo = htmlspecialchars(strip_tags($this->main_photo));
        $this->owner_id = htmlspecialchars(strip_tags($this->owner_id));

        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":address", $this->address);
        $stmt->bindParam(":facilities", $this->facilities);
        $stmt->bindParam(":capacity", $this->capacity);
        $stmt->bindParam(":price", $this->price);
        $stmt->bindParam(":main_photo", $this->main_photo);
        $stmt->bindParam(":owner_id", $this->owner_id);

        if ($stmt->execute()) {
            return true;
        }

        return false;
    }

    public function read() {
        $query = "SELECT * FROM " . $this->table_name;

        $stmt = $this->conn->prepare($query);
        $stmt->execute();

        return $stmt;
    }
}
?>