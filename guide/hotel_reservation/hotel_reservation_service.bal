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
import ballerina/log;
//import ballerinax/docker;
//import ballerinax/kubernetes;

//@docker:Config {
//    registry:"ballerina.guides.io",
//    name:"hotel_reservation_service",
//    tag:"v1.0"
//}
//
//@docker:Expose{}

//@kubernetes:Ingress {
//  hostname:"ballerina.guides.io",
//  name:"ballerina-guides-hotel-reservation-service",
//  path:"/"
//}
//
//@kubernetes:Service {
//  serviceType:"NodePort",
//  name:"ballerina-guides-hotel-reservation-service"
//}
//
//@kubernetes:Deployment {
//  image:"ballerina.guides.io/hotel_reservation_service:v1.0",
//  name:"ballerina-guides-hotel-reservation-service"
//}

// Service endpoint
endpoint http:Listener hotelEP {
    port:9092
};

// Hotel reservation service
@http:ServiceConfig {basePath:"/hotel"}
service<http:Service> hotelReservationService bind hotelEP {

    // Resource 'elizabeth', which checks about hotel 'Elizabeth'
    @http:ResourceConfig {
        methods:["POST"],
        path:"/elizabeth",
        consumes:["application/json"],
        produces:["application/json"]
    }
    elizabeth (endpoint caller, http:Request request) {
        http:Response response;
        json reqPayload;

        string resourcePath = "/hotel/elizabeth";
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

        json arrivalDate = reqPayload.ArrivalDate;
        json departureDate = reqPayload.DepartureDate;
        json location = reqPayload.Location;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (arrivalDate == null || departureDate == null || location == null) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = caller -> respond(response);
            log:printWarn("Request with unsufficient info at : " + resourcePath + " : " + check request.getJsonPayload()!toString());
            done;
        }

        // Mock logic
        // Hotel service doesn't do database calls to retrieve information, response in hard-coded
        // Details of the hotel
        json hotelDetails = {
            "HotelName":"Elizabeth",
            "FromDate":arrivalDate,
            "ToDate":departureDate,
            "DistanceToLocation":2
        };
        // Response payload
        log:printDebug("Client response : " + hotelDetails.toString());
        response.setJsonPayload(untaint hotelDetails);
        // Send the response to the caller
        _ = caller -> respond(response);
    }
}
