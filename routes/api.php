<?php
include_once '../controllers/UserController.php';
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
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$segments = explode('/', trim($path, '/'));

switch ($segments[1]) {
    case 'register':
        if ($request_method == 'POST') {
            $data = json_decode(file_get_contents("php://input"), true);
            $controller = new UserController();
            echo $controller->createUser($data);
        } else {
            header("HTTP/1.0 405 Method Not Allowed");
        }
        break;
    case 'login':
        if ($request_method == 'POST') {
            $data = json_decode(file_get_contents("php://input"), true);
            $controller = new UserController();
            echo $controller->loginUser($data);
        } else {
            header("HTTP/1.0 405 Method Not Allowed");
        }
        break;
    case 'payments':
        $controller = new PaymentController();
        if ($request_method == 'GET') {
            echo $controller->getAllPayments();
        } elseif ($request_method == 'POST') {
            $data = json_decode(file_get_contents("php://input"), true);
            echo $controller->updatePaymentStatus($data);
        } else {
            header("HTTP/1.0 405 Method Not Allowed");
        }
        break;
    default:
        header("HTTP/1.0 404 Not Found");
        break;
}
?>