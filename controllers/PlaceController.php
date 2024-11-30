<?php
include_once '../config/database.php';
include_once '../models/Place.php';

class PlaceController {
    private $db;
    private $place;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        $this->place = new Place($this->db);
    }

    public function createPlace($data) {
        $this->place->name = $data['name'];
        $this->place->address = $data['address'];
        $this->place->facilities = $data['facilities'];
        $this->place->capacity = $data['capacity'];
        $this->place->price = $data['price'];
        $this->place->main_photo = $data['main_photo'];
        $this->place->owner_id = $data['owner_id'];

        if ($this->place->create()) {
            return json_encode(["message" => "Place was created."]);
        } else {
            return json_encode(["message" => "Unable to create place."]);
        }
    }

    public function getPlaces() {
        $stmt = $this->place->read();
        $places = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return json_encode($places);
    }
}
?>