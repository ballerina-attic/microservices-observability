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
import ballerina/mysql;
import ballerina/sql;
import ballerina/log;
//import ballerinax/docker;
//import ballerinax/kubernetes;

//@docker:Config {
//    registry:"ballerina.guides.io",
//    name:"car_rental_service",
//    tag:"v1.0"
//}
//
//@docker:Expose{}

//@kubernetes:Ingress {
//  hostname:"ballerina.guides.io",
//  name:"ballerina-guides-car-rental-service",
//  path:"/"
//}
//
//@kubernetes:Service {
//  serviceType:"NodePort",
//  name:"ballerina-guides-car-rental-service"
//}
//
//@kubernetes:Deployment {
//  image:"ballerina.guides.io/car_rental_service:v1.0",
//  name:"ballerina-guides-car-rental-service"
//}

// Service endpoint
endpoint http:Listener carEP {
    port:9093
};

// Car rental service
@http:ServiceConfig {basePath:"/car"}
service<http:Service> carRentalService bind carEP {

    // Resource 'driveSg', which checks about hotel 'DriveSg'
    @http:ResourceConfig {
        methods:["POST"],
        path:"/driveSg",
        consumes:["application/json"],
        produces:["application/json"]
    }
    driveSg(endpoint caller, http:Request request) {
        http:Response response;
        json reqPayload;

        string resourcePath = "/car/driveSg";
        log:printDebug("Received at : " + resourcePath);
        // Try parsing the JSON payload from the request
        match request.getJsonPayload() {
            // Valid JSON payload
            json payload => reqPayload = payload;
            // NOT a valid JSON payload
            any => {
                response.statusCode = 400;
                response.setJsonPayload({"Message":"Invalid payload - Not a valid JSON payload"});
                _ = caller -> respond(response);
                log:printWarn("Invalid payload at : " + resourcePath);
                done;
            }
        }

        string arrivalDate = <string> reqPayload.ArrivalDate but {error => ""};
        string departureDate = <string> reqPayload.DepartureDate but {error => ""};
        string vehicleType = <string> reqPayload.VehicleType but {error => ""};
        string company = "DriveSG";

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == null || departureDate == null || vehicleType == null) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = caller -> respond(response);
            log:printWarn("Request with unsufficient info at : " + resourcePath + " : " + check request.getJsonPayload()!toString());
            done;
        }

        // Query the database to retrieve car details
        json carDetails = untaint carDBService(company, departureDate, arrivalDate, vehicleType);
        // Response payload
        log:printDebug("Client response : " + carDetails.toString());
        response.setJsonPayload(carDetails);
        // Send the response to the caller
        _ = caller -> respond(response);
    }
}

// Define car record type
type Car record {
    string company;
    string arrivalDate;
    string departureDate;
    string vehicleType;
    int price;
};

// Database endpoint
endpoint mysql:Client carDB{
    host:"localhost",
    port:3306,
    name:"testdb2",
    username:"root",
    password:"root",
    dbOptions: { useSSL: false }
};

// Function to do databse calls
function carDBService (string company, string departureDate, string arrivalDate, string vehicleType) returns json {
    log:printDebug("Invoking carDBService with parameters - company : " + company + ", departureDate : " + departureDate 
    + ", arrivalDate : " + arrivalDate + ", vehicleType : " + vehicleType);
    // Set arguments for the query
    sql:Parameter p1 = {sqlType:sql:TYPE_VARCHAR, value:company};
    sql:Parameter p2 = {sqlType:sql:TYPE_DATE, value:departureDate};
    sql:Parameter p3 = {sqlType:sql:TYPE_DATE, value:arrivalDate};
    sql:Parameter p4 = {sqlType:sql:TYPE_VARCHAR, value:vehicleType};
    // Query to be executed
    string q = "SELECT * FROM CARS WHERE company = ? AND departureDate = ? AND arrivalDate = ? AND vehicleType = ?";
    log:printDebug("carDBService query : " + q);
    // Perform the SELECT operation on carDB endpoint
    var temp = carDB -> select(q, Car, p1, p2, p3, p4);
    table<Car> cars = check temp;
    Car car = {};
    foreach i in cars {
        car.company = i.company;
        car.departureDate = i.departureDate;
        car.arrivalDate = i.arrivalDate;
        car.vehicleType = i.vehicleType;
        car.price = i.price;
    }
    log:printDebug("carDBService response : ");
    return <json> car but {error => {}};
}
