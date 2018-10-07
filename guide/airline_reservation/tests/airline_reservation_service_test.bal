// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/test;

// Common request Payload
json requestPayload = {
    "ArrivalDate": "2018-11-06",
    "DepartureDate": "2018-11-06",
    "From": "CMB",
    "To": "DXB"
};

// Client endpoint
endpoint http:Client clientEP {
    url: "http://localhost:9091/airline"
};

// Function to test resource 'flightQatar'
@test:Config
function testResourceFlightQatar () {
    // Send a 'post' request and obtain the response
    http:Response response = check clientEP->post("/qatarAirways", requestPayload);
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200,
        msg = "Airline reservation service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    string expected = "{\"flightNo\":3, \"airline\":\"Qatar\", \"arrivalDate\":\"2018-11-06+05:30\", " + 
        "\"departureDate\":\"2018-11-06+05:30\", \"to\":\"DXB\", \"rom\":\"CMB\", \"price\":300}";
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), expected, msg = "Response mismatch!");
}

// Function to test resource 'flightAsiana'
@test:Config
function testResourceFlightAsiana () {
    // Send a 'post' request and obtain the response
    http:Response response = check clientEP->post("/asiana", requestPayload);
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200,
        msg = "Airline reservation service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    string expected = "{\"flightNo\":2, \"airline\":\"Asiana\", \"arrivalDate\":\"2018-11-06+05:30\", " +
        "\"departureDate\":\"2018-11-06+05:30\", \"to\":\"DXB\", \"rom\":\"CMB\", \"price\":200}";
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), expected, msg = "Response mismatch!");
}

// Function to test resource 'flightEmirates'
@test:Config
function testResourceFlightEmirates () {
    // Send a 'post' request and obtain the response
    http:Response response = check clientEP->post("/emirates", requestPayload);
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200,
        msg = "Airline reservation service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    string expected = "{\"flightNo\":1, \"airline\":\"Emirates\", \"arrivalDate\":\"2018-11-06+05:30\", " + 
        "\"departureDate\":\"2018-11-06+05:30\", \"to\":\"DXB\", \"rom\":\"CMB\", \"price\":100}";
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), expected, msg = "Response mismatch!");
}
