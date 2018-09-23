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
    "ArrivalDate": "2007-11-06",
    "DepartureDate": "2007-11-06",
    "VehicleType": "Car"
};

// Client endpoint
endpoint http:Client clientEP {
    url: "http://localhost:9093/car"
};

// Function to test resource 'driveSg'
@test:Config
function testResourceDriveSg () {
    // Initialize the empty http request
    http:Request req;
    // Set request payload
    req.setJsonPayload(requestPayload);
    // Send a 'post' request and obtain the response
    http:Response response = check clientEP->post("/driveSg", req);
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200, msg = "Car rental service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    string expected = "{\"company\":\"DriveSG\", \"arrivalDate\":\"2007-11-06+05:30\", " + 
        "\"departureDate\":\"2007-11-06+05:30\", \"vehicleType\":\"Car\", \"price\":10}";
    json resPayload = check response.getJsonPayload();
    test:assertEquals(resPayload.toString(), expected, msg = "Response mismatch!");
}
