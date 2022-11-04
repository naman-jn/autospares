<?php

function handleMessage($e_message)
{
    switch ($e_message) {
        case str_contains($e_message, "Duplicate") && str_contains($e_message, "mobile"):
            return "Mobile number already in use.";
            break;

        case str_contains($e_message, "Duplicate") && str_contains($e_message, "email"):
            return "Email already in use.";
            break;
        case str_contains($e_message, "Too few arguments"):
            return "Few arguments in body missing or incorrect";
            break;
        default:
        return $e_message;
    }
}


function handleError($e)
{
    $e_message = handleMessage($e->getMessage());
    http_response_code(400);
    echo json_encode(array('result'=>false,'message'=>"$e_message"));
    die();
}
