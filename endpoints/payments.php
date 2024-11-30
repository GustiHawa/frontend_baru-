<?php
include_once '../controllers/PaymentController.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$request_method = $_SERVER["REQUEST_METHOD"];
$controller = new PaymentController();

switch ($request_method) {
    case 'GET':
        echo $controller->getAllPayments();
        break;
    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        echo $controller->updatePaymentStatus($data);
        break;
    default:
        header("HTTP/1.0 405 Method Not Allowed");
        break;
}
?>