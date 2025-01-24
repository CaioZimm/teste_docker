<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/home', function () {
    echo "<h1> Hello World! </h1> Test in Docker ";
});