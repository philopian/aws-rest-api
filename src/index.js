"use strict";

exports.handler = async (event) => {
  let env = process.env.ENV;
  console.log(`Running in ${env} mode`);
  let statusCode = 200;
  let body = {};
  let response = {};
  switch (event.httpMethod) {
    case "GET":
      body = {
        type: "you requested a GET!!!",
      };
      response = {
        statusCode,
        headers: {
          "x-custom-header": "REQUESTED GET",
        },
        body: JSON.stringify(body),
      };
      return response;

    case "POST":
      body = {
        type: "you requested a POST!!!",
        queryStringParameters: event.queryStringParameters,
        body: event.body,
      };
      response = {
        statusCode,
        headers: {
          "x-custom-header": "REQUESTED POST",
        },
        body: JSON.stringify(body),
      };
      return response;
    default:
      statusCode = 200;
      body = {
        type: "OTHER!",
      };
      response = {
        statusCode,
        headers: {
          "x-custom-header": "REQUESTED OTHER",
        },
        body: JSON.stringify(body),
      };
      return response;
  }
  // The output from a Lambda proxy integration must be
  // in the following JSON object. The 'headers' property
  // is for custom response headers in addition to standard
  // ones. The 'body' property  must be a JSON string. For
  // base64-encoded payload, you must also set the 'isBase64Encoded'
  // property to 'true'.
};
