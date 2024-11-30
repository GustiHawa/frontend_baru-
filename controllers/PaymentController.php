<?php
include_once '../config/database.php';
include_once '../models/Payment.php';

class PaymentController {
    private $db;
    private $payment;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
        $this->payment = new Payment($this->db);
    }

    public function getAllPayments() {
        $stmt = $this->payment->readAll();
        $payments = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return json_encode($payments);
    }

    public function updatePaymentStatus($data) {
        if (empty($data['id']) || empty($data['status'])) {
            return json_encode(["message" => "Invalid input."]);
        }

        $id = $data['id'];
        $status = $data['status'];

        if ($this->payment->updateStatus($id, $status)) {
            return json_encode(["message" => "Payment status updated."]);
        } else {
            return json_encode(["message" => "Unable to update payment status."]);
        }
    }
}
?>