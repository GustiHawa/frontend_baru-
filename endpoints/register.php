<?php
include_once '../controllers/UserController.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);

$controller = new UserController();
$response = $controller->createUser($data);

$responseData = json_decode($response, true);

if ($responseData['message'] === "User was created.") {
    http_response_code(201);
} else {
    http_response_code(400);
}

echo $response;
?>